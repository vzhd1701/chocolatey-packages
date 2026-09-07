# Chocolatey Packages

[![Update](https://github.com/vzhd1701/chocolatey-packages/actions/workflows/update.yml/badge.svg)](https://github.com/vzhd1701/chocolatey-packages/actions/workflows/update.yml)

Automatic Chocolatey packages, updated with [chocolatey-au](https://github.com/chocolatey-community/chocolatey-au) on GitHub Actions.

## Packages

| Package | Description |
| --- | --- |
| [gridplayer](https://community.chocolatey.org/packages/gridplayer) | Virtual package; installs `gridplayer.install` |
| [gridplayer.install](https://community.chocolatey.org/packages/gridplayer.install) | Inno Setup installer (32-bit and 64-bit) |
| [gridplayer.portable](https://community.chocolatey.org/packages/gridplayer.portable) | Zip portable (32-bit and 64-bit) |
| [evernote-backup](https://community.chocolatey.org/packages/evernote-backup) | CLI to backup and export Evernote notes (x64) |

## Folder structure

* `automatic` — packages maintained by chocolatey-au (`update.ps1` in each package directory)
* `icons` — package icons
* `manual` — packages that are not automatic

## Local update

Requires PowerShell 5+, Chocolatey, and `choco install chocolatey-au`.

```powershell
# one package
cd automatic\gridplayer.install
.\update.ps1

# all packages
.\update_all.ps1
```

Copy `update_vars.ps1` locally (gitignored) if you want to set `api_key` / `github_api_key` for a local run. Leave `au_Push` as `false` unless you intend to publish.

Force a version even when GitHub already matches the nuspec:

```powershell
$au_Force = $true
.\update_all.ps1 -ForcedPackages 'gridplayer.install gridplayer.portable gridplayer'
```

## GitHub Actions

`.github/workflows/update.yml` runs every 8 hours, on push to `master`, and on manual dispatch.

It updates package files from the latest GitHub releases, commits changes, then pushes nupkgs to chocolatey.org (`.install` and `.portable` before virtual packages).

Set these repository secrets:

* `CHOCOLATEY_API_KEY` — required to publish
* `GIST_ID` — optional; AU writes the update report gist when set (needs a PAT with `gist` scope in a custom `github_api_key` if you use this)

Force from the Actions UI (`forced_packages` input) or with a commit message:

```
[AU gridplayer.install gridplayer.portable gridplayer]
```
