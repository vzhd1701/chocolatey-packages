Import-Module Chocolatey-AU

. "$PSScriptRoot\..\gridplayer\update.ps1"

function global:au_GetLatest {
    $latest = Get-GridPlayerLatest
    @{
        Version        = $latest.Version
        TagVersion     = $latest.TagVersion
        URL32          = $latest.PortableURL32
        URL64          = $latest.PortableURL64
        Checksum32     = $latest.PortableChecksum32
        Checksum64     = $latest.PortableChecksum64
        ChecksumType32 = $latest.ChecksumType32
        ChecksumType64 = $latest.ChecksumType64
    }
}

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*url64bit\s*=\s*)('.*')"     = "`$1'$($Latest.URL64)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
        '.\gridplayer.portable.nuspec' = Get-GridPlayerNuspecReplace
    }
}

update -ChecksumFor none
