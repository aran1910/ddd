try {
    $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
    $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"

    if ($geo.status -eq "success") {
        Write-Host "`n🌐 IP: $($geo.query)"
        Write-Host "📍 Location: $($geo.city), $($geo.regionName), $($geo.country)"
        Write-Host "🧭 GPS: $($geo.lat), $($geo.lon)"
        Write-Host "🏢 ISP: $($geo.isp)`n"
    } else {
        Write-Host "❌ Geolocation failed (API status error)."
    }
}
catch {
    Write-Host "🔥 Error: $($_.Exception.Message)"
}

Start-Sleep -Seconds 1

try {
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force
} catch {
    Write-Host "⚠️ Self-deletion failed."
}
