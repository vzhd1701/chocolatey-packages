Import-Module Chocolatey-AU

$releasesRepo = 'vzhd1701/evernote-backup'

function Get-EvernoteBackupAsset($Release, $Pattern) {
    $asset = $Release.assets | Where-Object { $_.name -match $Pattern } | Select-Object -First 1
    if (-not $asset) {
        throw "No GitHub asset matching '$Pattern' in $($Release.tag_name)"
    }

    $checksum = $null
    if ($asset.digest -match '^sha256:(.+)$') {
        $checksum = $Matches[1]
    }
    if (-not $checksum) {
        $checksum = Get-RemoteChecksum $asset.browser_download_url
    }

    @{
        Url      = $asset.browser_download_url
        Checksum = $checksum
    }
}

function global:au_GetLatest {
    $headers = @{
        Accept       = 'application/vnd.github+json'
        'User-Agent' = 'chocolatey-au'
    }
    $token = $env:github_api_key
    if (-not $token) { $token = $env:GITHUB_TOKEN }
    if ($token) {
        $headers['Authorization'] = "Bearer $token"
    }

    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$releasesRepo/releases/latest" -Headers $headers
    $asset64 = Get-EvernoteBackupAsset $release 'win_x64\.zip$'

    @{
        Version        = $release.tag_name.TrimStart('v')
        URL64          = $asset64.Url
        Checksum64     = $asset64.Checksum
        ChecksumType64 = 'sha256'
    }
}

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

update -ChecksumFor none
