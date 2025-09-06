try {
    $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
    $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"

    if ($geo.status -eq "success") {
        Write-Host "`n🌐 Public IP: $($geo.query)" -ForegroundColor Cyan
        Write-Host "📍 Location: $($geo.city), $($geo.regionName), $($geo.country)" -ForegroundColor Green
        Write-Host "🧭 Coordinates: $($geo.lat), $($geo.lon)" -ForegroundColor Yellow
        Write-Host "🏢 ISP: $($geo.isp)`n" -ForegroundColor Gray
    } else {
        Write-Host "❌ Failed to retrieve geolocation." -ForegroundColor Red
    }
} catch {
    Write-Host "🔥 Error during lookup: $_" -ForegroundColor Red
}

# Self-delete the script
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
