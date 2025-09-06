# minimizejackie.ps1

(New-Object -ComObject Shell.Application).MinimizeAll()
Write-Host "✅ All windows minimized. Desktop is visible."

# Self-delete
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
