#!/usr/bin/env node

/// <reference lib="esnext" />
/// <reference types="node" />

/**
 * @fileoverview Script to list information and possible actions for (outdated) nix overlays.
 *
 * This script will help:
 *   - list overlays that are out of date.
 *   - list overlays that are not neede since nixpkgs catched up.
 *   - list the latest versions.
 * By default overlays will be searched in `./modules/overlays` as `*.nix` file.
 * Active overlays should be imported in `./modules/overlays/default.nix`, when they are used/active.
 * Right now GitHub (with the keys `owner` and `repo`) and `fetchurl` (with NPM tar files) is supported.
 */

import { glob, readFile } from 'node:fs/promises'
import { basename } from 'node:path'
import { promisify } from 'node:util'
import child_process from 'node:child_process'

/** where are the overlay nix files are placed */
const OVERLAYS_DIRECTORY = './modules/overlays'
/** where _active_ overlays are imported */
const DEFAULT_NIX = 'default.nix'
/** files in the overlays directory that should be ignored (or don't contain overlays) */
const EXCLUDED_FILES = [DEFAULT_NIX]

/** match overlay names to their GitHub repo (if the information cannot be extracted from the overlay itself) */
const overlayMap: Record<string, { owner: string; repo: string }> = {
	nodejs_24: {
		owner: 'nodejs',
		repo: 'node',
	},
}

const INVALID_VERSION = '-0.0.0'

const execFile = promisify(child_process.execFile)

/**
 * Compare SemVer verion strings
 * @param a
 * @param b
 * @returns {number} - 0 if equal or error, positive if param `a` is bigger, otherwise negative if `b` is larger than `a`.
 */
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

/** list of full nix overlay paths */
const getOverlays = async (): Promise<string[]> => {
	const files = (await Array.fromAsync(glob(`${OVERLAYS_DIRECTORY}/*.nix`))) as string[]
	return files.filter((f) => !EXCLUDED_FILES.includes(basename(f)))
}

/** make sure that name exists in the package as overlay */
const validateName = (pkgCode: string, name: string) => {
	// lhs
	if (!pkgCode.includes(name) || !pkgCode.includes(`${name} = `)) {
		return false
	}
	// making sure it is an overlay using `prev` or `super`
	if (!pkgCode.includes(`${name} = prev`) && !pkgCode.includes(`${name} = super`)) {
		return false
	}

	// rhs: here, the package could have a different name -> warn only
	if (!pkgCode.includes(`super.${name}`) && !pkgCode.includes(`prev.${name}`)) {
		console.warn(`NOTE: The pkg '${name}' does not appear on the right hand side.`)
	}

	return true
}

const matchWithGroups = <T extends Record<string, string>>(str: string, regex: RegExp): T | undefined =>
	str.match(regex)?.groups as T

const parseOverlay = async (path: string): Promise<Overlay> => {
	const name = basename(path, '.nix')
	const pkgContents = await readFile(path, 'utf-8')
	const validName = validateName(pkgContents, name)
	const versionMatch = pkgContents.match(/.*version = \"([^\"]+)\".*/)
	const version = versionMatch ? (versionMatch[1] ?? INVALID_VERSION) : INVALID_VERSION
	const isGitHub = /(?<!#.*?)fetchFromGitHub/g.test(pkgContents)
	const isFetchurl = /(?<!#.*?)\.fetchurl/g.test(pkgContents)
	if (isGitHub && isFetchurl) {
		console.warn('In', path, 'are both GitHub and fetchUrl sources.')
	}
	const data: Overlay = { name, path, version, validName }
	if (isGitHub) {
		const reRepo = /repo\s?=\s?"(?<repo>.*)"/
		data.owner = matchWithGroups<{ owner: string }>(pkgContents, /owner\s?=\s?"(?<owner>.*)"/)?.owner ?? ''
		data.repo = matchWithGroups<{ repo: string }>(pkgContents, reRepo)?.repo ?? ''
	}
	if (isFetchurl) {
		const urlMatches = pkgContents.match(/url = "([^"]+)"/g)
		if (urlMatches && urlMatches.length > 1) {
			console.warn(`multiple (${urlMatches.length}) urls found:`)
			console.debug(urlMatches)
		}
		const urlMatch = pkgContents.match(/url = "([^"]+)"/)
		if (urlMatch && urlMatch.length >= 2) {
			const [_, url] = urlMatch
			if (url) {
				data.originalUrl = url
				if (version !== INVALID_VERSION) {
					data.url = url.replaceAll('${version}', version)
				}
			}
		}
	}
	return data
}

const cleanVersion = (str: string) => str.replace(/[A-Za-z-]*/, '')

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

	throw new Error(`No releases or tags found for github:${owner}/${repo}`)
}

const fetchNPMVersion = async (name: string): Promise<string> => {
	const response = await fetch(`https://registry.npmjs.org/${name}/latest`)
	const data = await response.json()
	return data.version
}

/**
 *
 * @param overlay
 * @throws
 */
const fetchNewestVersion = async (overlay: Overlay): Promise<string> => {
	// if there are GitHub repo information
	if (overlay.owner && overlay.repo) {
		return await fetchGitHubVersion(overlay.owner, overlay.repo)
	}
	// if we have a overlay url
	if (overlay.url) {
		// so far only npmjs is supported atm
		if (/registry\.npmjs\.org/.test(overlay.url)) {
			return await fetchNPMVersion(overlay.name)
		}
		// github releases
		if (/github\.com\//.test(overlay.url)) {
			const { owner, repo } = (overlay.url.match(/github\.com\/(?<owner>.*)\/(?<repo>.*)\/releases\//)
				?.groups ?? {
				owner: 'missing',
				repo: 'regex-groups',
			}) as { owner: string; repo: string }
			return await fetchGitHubVersion(owner, repo)
		}
	}
	// otherwise use the overlayMap from above to obtain GitHub information
	if (Object.hasOwn(overlayMap, overlay.name)) {
		const fromMap = overlayMap[overlay.name]
		if (!fromMap) {
			throw new Error(`The package '${overlay.name}' is missing information on the overlayMap.`)
		}
		return await fetchGitHubVersion(fromMap.owner, fromMap.repo)
	}
	console.error('no version could be found for', overlay.name, Object.hasOwn(overlayMap, overlay.name))
	return INVALID_VERSION
}

const nix = async (options: string[]) => execFile('nix', options)

/** get the latest versiom from nixpkgs search. */
const fetchNixpkgsVersion = async (name: string) => {
	try {
		const { stdout } = await nix(['search', `nixpkgs#${name}`, '^', '--json'])
		const json = JSON.parse(stdout)
		const packageName = Object.keys(json)[0]
		if (!packageName) {
			throw new Error(`Could not extract package name from nix search result: ${json}.`)
		}
		const version = json[packageName].version
		if (!version) {
			throw new Error(`Could not extract package version from: ${json}`)
		}
		return version
	} catch (error) {
		console.error('could not fetch nix version', error)
		return INVALID_VERSION
	}
}

/** returns `true` if a overlay is used */
const isOverlayUsed = async (name: string): Promise<boolean> => {
	const contents = await readFile(`${OVERLAYS_DIRECTORY}/${DEFAULT_NIX}`, 'utf-8')
	// const overlays = (await getOverlays()).map((o) => `/${basename(o, 'nix')}`)
	return contents.toLowerCase().includes(name.toLowerCase())
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

		const isUsed = await isOverlayUsed(overlay.name)

		let action = 'nothing to do.'

		if (isOverlayOutdated) {
			action = 'update overlay.'

			if (!isNixpkgsOutdated) {
				action = 'move to nixpkgs.'
			}
		} else {
			if (isNixpkgsOutdated) {
				action = 'nothing to do and wait until nixpkgs catches up.'
				//console.info('unfortunately, nixpkgs are still out of date.')
			} else {
				// when nixpkgs are up to date, they should be preferred
				if (isUsed) {
					action = 'move to nixpkgs (since they are now up to date).'
				}
			}
		}

		// console.log({ name: overlay.name, action })
		console.debug({ ...overlay, latestNixVersion, latestVersion, action, isUsed })
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

	/** if the name is contained in the package contents */
	validName: boolean

	/** url without replaced version */
	originalUrl?: string

	/** optional: url (with replaced version), if fetchurl is used */
	url?: string

	/** optional, if fetchFromGithub is used */
	owner?: string
	/** optional, if fetchFromGithub is used */
	repo?: string
}
