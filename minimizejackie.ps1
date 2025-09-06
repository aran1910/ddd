# Minimize-All.ps1

try {
    (New-Object -ComObject Shell.Application).MinimizeAll()
    Write-Host "✅ All windows minimized. Desktop is visible." -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to minimize windows." -ForegroundColor Red
}
