Import-Module Chocolatey-AU

$releasesRepo = 'vzhd1701/gridplayer'

function Get-GridPlayerAsset($Release, $Pattern) {
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

function Get-GridPlayerLatest {
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
    $version = $release.tag_name.TrimStart('v')

    $install32  = Get-GridPlayerAsset $release 'win32-install\.exe$'
    $install64  = Get-GridPlayerAsset $release 'win64-install\.exe$'
    $portable32 = Get-GridPlayerAsset $release 'win32-portable\.zip$'
    $portable64 = Get-GridPlayerAsset $release 'win64-portable\.zip$'

    @{
        Version            = $version
        TagVersion         = $version
        InstallURL32       = $install32.Url
        InstallChecksum32  = $install32.Checksum
        InstallURL64       = $install64.Url
        InstallChecksum64  = $install64.Checksum
        PortableURL32      = $portable32.Url
        PortableChecksum32 = $portable32.Checksum
        PortableURL64      = $portable64.Url
        PortableChecksum64 = $portable64.Checksum
        ChecksumType32     = 'sha256'
        ChecksumType64     = 'sha256'
    }
}

function Get-GridPlayerNuspecReplace {
    @{
        '(gridplayer@v)[\d.]+' = "`${1}$($Latest.TagVersion)"
    }
}

function global:au_GetLatest {
    $latest = Get-GridPlayerLatest
    @{
        Version    = $latest.Version
        TagVersion = $latest.TagVersion
    }
}

function global:au_SearchReplace {
    @{
        '.\gridplayer.nuspec' = @{
            '(gridplayer@v)[\d.]+' = "`${1}$($Latest.TagVersion)"
            "(\<dependency .+?`"gridplayer.install`" version=)`"[^`"]+`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}
