$ErrorActionPreference = 'Stop'

$packageName   = $env:ChocolateyPackageName
$unzipLocation = Join-Path (Get-ToolsLocation) $packageName
$params        = Get-PackageParameters

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $unzipLocation
  url            = 'https://github.com/vzhd1701/gridplayer/releases/download/v0.5.5/GridPlayer-0.5.5-win32-portable.zip'
  url64bit       = 'https://github.com/vzhd1701/gridplayer/releases/download/v0.5.5/GridPlayer-0.5.5-win64-portable.zip'
  checksum       = '8478c5b982752cf55f65096d3588f2dc300b3674c2518710fd9c09146eac1709'
  checksum64     = '13a7e2ff20267bd902128e4ab07edce135615f1c94efabc327b13c4ec0a94d3d'
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Zip root is GridPlayer/; hoist contents so the package dir is the app root
$nestedDir = Join-Path $unzipLocation 'GridPlayer'
if (Test-Path -LiteralPath $nestedDir) {
  Get-ChildItem -LiteralPath $nestedDir -Force | Move-Item -Destination $unzipLocation -Force
  Remove-Item -LiteralPath $nestedDir -Recurse -Force
}

$exePath = Join-Path $unzipLocation 'GridPlayer.exe'

Install-BinFile -Name 'GridPlayer' -Path $exePath -UseStart

if ($params.DesktopIcon) {
  $desktopIcon = Join-Path ([Environment]::GetFolderPath('Desktop')) 'GridPlayer.lnk'
  Write-Host -ForegroundColor White "Adding $desktopIcon"
  Install-ChocolateyShortcut -ShortcutFilePath $desktopIcon -TargetPath $exePath
}

if (-not $params.NoStart) {
  $startIcon = Join-Path ([Environment]::GetFolderPath('Programs')) 'GridPlayer.lnk'
  Write-Host -ForegroundColor White "Adding $startIcon"
  Install-ChocolateyShortcut -ShortcutFilePath $startIcon -TargetPath $exePath
}
