$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
$geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"

if ($geo.status -eq "success") {
    Write-Host "`n🌐 IP: $($geo.query)"
    Write-Host "📍 Location: $($geo.city), $($geo.regionName), $($geo.country)"
    Write-Host "🧭 GPS: $($geo.lat), $($geo.lon)"
    Write-Host "🏢 ISP: $($geo.isp)`n"
} else {
    Write-Host "❌ Geolocation failed."
}

Start-Sleep -Seconds 1
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
