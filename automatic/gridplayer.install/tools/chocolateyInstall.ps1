$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  softwareName   = 'GridPlayer*'
  url            = 'https://github.com/vzhd1701/gridplayer/releases/download/v0.5.5/GridPlayer-0.5.5-win32-install.exe'
  url64bit       = 'https://github.com/vzhd1701/gridplayer/releases/download/v0.5.5/GridPlayer-0.5.5-win64-install.exe'
  checksum       = 'e605fdd7732a04b39208ecb2aa74a0118eda35dd600a9459e99f4902ffd5eb81'
  checksum64     = '3c13ac01723d7783d44264dcc7311fe01b1f8b535a1dae7398eea8b9cd899595'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
  # Inno Setup
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
