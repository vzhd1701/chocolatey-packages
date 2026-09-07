$ErrorActionPreference = 'SilentlyContinue'
Get-Process 'evernote-backup*' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
