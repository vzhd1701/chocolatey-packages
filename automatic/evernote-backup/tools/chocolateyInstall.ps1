$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = Split-Path -Parent $MyInvocation.MyCommand.Definition
  url64bit       = 'https://github.com/vzhd1701/evernote-backup/releases/download/1.14.0/bin_evernote_backup_1.14.0_win_x64.zip'
  checksum64     = 'b22dec0277496a89e254775b4583b40f695c6ed2c947f722199819bf68c48832'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
