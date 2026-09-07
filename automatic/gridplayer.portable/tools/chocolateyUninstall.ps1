$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir    = Join-Path (Get-ToolsLocation) $packageName
$exePath     = Join-Path $toolsDir 'GridPlayer.exe'

$desktopIcon = Join-Path ([Environment]::GetFolderPath('Desktop')) 'GridPlayer.lnk'
$startIcon   = Join-Path ([Environment]::GetFolderPath('Programs')) 'GridPlayer.lnk'

Remove-Item $desktopIcon -ErrorAction SilentlyContinue
Remove-Item $startIcon -ErrorAction SilentlyContinue

Uninstall-BinFile -Name 'GridPlayer' -Path $exePath

if (Test-Path -LiteralPath $toolsDir) {
  # Keep portable user data across uninstall/reinstall
  Get-ChildItem -LiteralPath $toolsDir -Force -Exclude 'portable_data' |
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}
