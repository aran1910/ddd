# benji.ps1

try {
    # Force TLS 1.2 to avoid handshake failures
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Get public IP
    $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip

    # Get geolocation from ip-api
    $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"

    if ($geo.status -eq "success") {
        Write-Host "`n🌐 IP: $($geo.query)"
        Write-Host "📍 Location: $($geo.city), $($geo.regionName), $($geo.country)"
        Write-Host "🧭 Coordinates: $($geo.lat), $($geo.lon)"
        Write-Host "🏢 ISP: $($geo.isp)`n"
    }
    else {
        Write-Host "❌ Geolocation failed. API status: $($geo.status)"
    }
}
catch {
    Write-Host "🔥 Error: $($_.Exception.Message)"
}

# Give output time to print before deletion
Start-Sleep -Milliseconds 500

# Self-delete (wrapped safely)
try {
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue
} catch {}
