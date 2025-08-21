#!/usr/bin/env node

/// <reference lib="esnext" />
/// <reference types="node" />

import { glob, readFile } from 'node:fs/promises'
import { basename } from 'node:path'
import { promisify } from 'node:util'
import child_process from 'node:child_process'

const execFile = promisify(child_process.execFile)

const INVALID_VERSION = '-0.0.0'

const compareSemver = (a: string, b: string): number => {
  const parseVersion = (version: string): number[] => version.split('.').map((part) => parseInt(part, 10))

  try {
    const aParts = parseVersion(a)
    const bParts = parseVersion(b)

    for (let i = 0; i < aParts.length; i++) {
      const aPart = aParts[i] || 0
      const bPart = bParts[i] || 0

      if (aPart !== bPart) {
        return aPart - bPart
      }
    }

    return 0
  } catch (error) {
    console.error('Error comparing versions:', error)
    return 0
  }
}

const OVERLAYS_DIRECTORY = './modules/overlays'

/**
 *
 * @returns list of paths to overlay nix files
 */
const getOverlays = async (): Promise<string[]> => {
  const overlays: string[] = []
  for await (const path of glob(`${OVERLAYS_DIRECTORY}/*.nix`)) overlays.push(path)
  return overlays
}

const validateName = (pkgCode: string, name: string) => {
  // lhs
  if (!pkgCode.includes(name) || !pkgCode.includes(`${name} = `)) {
    return false
  }
  if (!pkgCode.includes(`${name} = prev`) && !pkgCode.includes(`${name} = super`)) {
    return false
  }

  // rhs: here, the package could have a different name
  if (!pkgCode.includes(`super.${name}`) && !pkgCode.includes(`prev.${name}`)) {
    console.warn(`NOTE: The pkg '${name}' does not appear on the right hand side.`)
  }

  return true
}

const parseOverlay = async (path: string): Promise<Overlay> => {
  const str = await readFile(path, 'utf-8')
  const versionMatch = str.match(/.*version = \"([^\"]+)\".*/)
  const version = versionMatch ? versionMatch[1] : INVALID_VERSION
  const isGitHub = /(?<!#.*?)fetchFromGitHub/g.test(str)
  const isFetchurl = /(?<!#.*?)\.fetchurl/g.test(str)
  if (isGitHub && isFetchurl) {
    console.warn('In', path, 'are both GitHub and fetchUrl sources.')
  }
  const data: Overlay = { name: basename(path, '.nix'), path, version }
  if (isGitHub) {
    const reOwner = /owner\s?=\s?"(?<owner>.*)"/
    const reRepo = /repo\s?=\s?"(?<repo>.*)"/
    data.owner = str.match(reOwner)?.groups.owner
    data.repo = str.match(reRepo)?.groups.repo
  }
  if (isFetchurl) {
    const urlMatches = str.match(/url = "([^"]+)"/g)
    if (urlMatches && urlMatches.length > 1) {
      console.warn(`multiple (${urlMatches.length}) urls found:`)
      console.debug(urlMatches)
    }
    const urlMatch = str.match(/url = "([^"]+)"/)
    if (urlMatch) {
      const [_, url] = urlMatch
      data.originalUrl = url
      if (version !== INVALID_VERSION) {
        data.url = url.replaceAll('${version}', version)
      }
    }
  }
  return data
}

const cleanVersion = (str: string) => str.replace('v', '')

const fetchGitHubVersion = async (owner: string, repo: string): Promise<string> => {
  const [releaseResponse, tagsResponse] = await Promise.allSettled([
    fetch(`https://api.github.com/repos/${owner}/${repo}/releases/latest`),
    fetch(`https://api.github.com/repos/${owner}/${repo}/tags`),
  ])

  if (
    (releaseResponse.status === 'fulfilled' && releaseResponse.value.status === 403) ||
    (releaseResponse.status === 'fulfilled' && releaseResponse.value.status === 403)
  ) {
    throw new Error('GitHub rate limit')
  }

  // Try release first
  if (releaseResponse.status === 'fulfilled' && releaseResponse.value.ok) {
    const release = await releaseResponse.value.json()
    return release.tag_name
  }

  // Fallback to tags
  if (tagsResponse.status === 'fulfilled' && tagsResponse.value.ok) {
    const tags = await tagsResponse.value.json()
    if (tags.length > 0) {
      return cleanVersion(tags[0].name)
    }
  }

  throw new Error('No releases or tags found')
}

const fetchNPMVersion = async (name: string): Promise<string> => {
  const response = await fetch(`https://registry.npmjs.org/${name}/latest`)
  const data = await response.json()
  return data.version
}

// overlay to GitHub owner and repo
// when this information is not in the overlay
const overlayMap: Record<string, { owner: string; repo: string }> = {
  nodejs_24: {
    owner: 'nodejs',
    repo: 'node',
  },
}

/**
 *
 * @param overlay
 * @throws
 */
const fetchNewestVersion = async (overlay: Overlay): Promise<string> => {
  if (overlay.owner && overlay.repo) {
    return await fetchGitHubVersion(overlay.owner, overlay.repo)
  }
  if (overlay.url) {
    const url = overlay.url
    if (/registry\.npmjs\.org/.test(url)) {
      return await fetchNPMVersion(overlay.name)
    }
  }
  if (Object.hasOwn(overlayMap, overlay.name)) {
    const fromMap = overlayMap[overlay.name]
    return await fetchGitHubVersion(fromMap.owner, fromMap.repo)
  }
  console.error('no version could be found for', overlay.name, Object.hasOwn(overlayMap, overlay.name))
  return INVALID_VERSION
}

const nix = async (options: string[]) => execFile('nix', options)

const fetchNixpkgsVersion = async (name: string) => {
  try {
    const { stdout } = await nix(['search', `nixpkgs#${name}`, '^', '--json'])
    const json = JSON.parse(stdout)
    return json[Object.keys(json)[0]]?.version ?? INVALID_VERSION
  } catch (error) {
    console.error('could not fetch nix version', error)
    return INVALID_VERSION
  }
}

const main = async () => {
  const overlays = await getOverlays()
  for (const path of overlays) {
    const overlay = await parseOverlay(path)
    const overlayVersion = overlay.version
    const latestVersion = cleanVersion(await fetchNewestVersion(overlay))
    const latestNixVersion = await fetchNixpkgsVersion(overlay.name)

    const overlayVSLatest = compareSemver(overlayVersion, latestVersion)
    const isOverlayOutdated = overlayVSLatest < 0
    const isNixpkgsOutdated = compareSemver(latestNixVersion, latestVersion) < 0

    let action = 'nothing to do.'

    if (isOverlayOutdated) {
      action = 'update overlay.'

      if (!isNixpkgsOutdated) {
        action = 'move to nixpkgs.'
      }
    } else {
      if (isNixpkgsOutdated) {
        action = 'nothing to do and wait.'
        //console.info('unfortunately, nixpkgs are still out of date.')
      } else {
        // when nixpkgs are up to date, they should be preferred
        action = 'move to nixpkgs (since they are now up to date).'
      }
    }

    // console.log({ name: overlay.name, action })
    console.debug({ ...overlay, latestNixVersion, latestVersion, action })
  }
  // console.log( await parseOverlay('../Tests/nix-nodejs_24-overaly/flake-github.nix'), await parseOverlay('../Tests/nix-nodejs_24-overaly/flake.nix') )
}

if (import.meta.main) {
  main().catch((error) => console.error(error))
}

type Overlay = {
  /** pkg name (the nix file name) */
  name: string
  /** path to the overlay nix file */
  path: string
  /** version (should be a number and not start with v) */
  version: string

  /** url without replaced version */
  originalUrl?: string

  /** optional: url (with replaced version), if fetchurl is used */
  url?: string

  /** optional, if fetchFromGithub is used */
  owner?: string
  /** optional, if fetchFromGithub is used */
  repo?: string
}
