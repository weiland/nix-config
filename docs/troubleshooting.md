# Troubleshooting and Debugging

## Changelogs

### nix-darwin

- https://github.com/nix-darwin/nix-darwin/blob/master/CHANGELOG
- `man 5 configuration.nix` or `darwin-help`

### home-manager

- Release Notes https://nix-community.github.io/home-manager/release-notes.xhtml


## An error occurred

Re-run command with `--show-trace`.


## A nix package just broke

> this mostly happens during updates

I.e. https://github.com/nix-community/home-manager/issues/7352 running `nixpkgs#git-open` did fail with something like
_error: Package ‘hostname-debian-3.25’ […] is not available on the requested hostPlatform "arm64-apple-darwin"_

### Solution (temp)

Move package to `homebrew`.


## A nix package is not yet up to date

> coming from homebrew, I'm spoiled with very short update times.

### Search for or create an overlay

for that package.

### Switch to homebrew

or manual installation.


## How many `nix` are there?

```shell
which -a nix`
```


## List profile packages

```bash
nix profile list

# and
sudo nix profile list
```

### Remove profile package

i.e. another installed `nix` package:

```bash
sudo nix profile remove nix
```

## When missing `nss-cacert`

when you ran

```bash
sudo nix profile remove nss-cacert
```

commands like `npm`, `git`, or `curl` might fail.

### Fix npm

Create (if not already existing) a `.npmrc` in your home directory and append the `cafile` config.

```shell
# ~/.npmrc
cafile = /etc/ssl/certs/ca-certificates.crt
```

Make sure `/etc/ssl/certs/ca-certificates.crt` exists.

```console
❯ eza --long --follow-symlinks /etc/ssl/certs/ca-certificates.crt
lrwxr-xr-x - root 25 May 11:13 /etc/ssl/certs/ca-certificates.crt -> /etc/static/ssl/certs/ca-certificates.crt

❯ ll /etc/static/ssl/certs/ca-certificates.crt
lrwxr-xr-x@ - root  1 Jan  1970 /etc/static/ssl/certs/ca-certificates.crt -> /nix/store/n8fqyynv2a15qcqcw188vy57wvb09ck1-ca-certificates.crt
```

## If ca-certificates are missing

Make sure in nix-darwin config `security.pki.installCACerts` is set to `true` (which it is by default).
See https://nix-darwin.github.io/nix-darwin/manual/index.html#opt-security.pki.certificates

If the certificates are still not available, there is the `cacert` nix package.


## config check (formerly `nix doctor`)

```shell
nix config check
```
