# benji.ps1 — Final Hardened Version

try {
    # Ensure TLS 1.2+ is used
    [Net.ServicePointManager]::SecurityProtocol = 3072

    # Get external IP
    $ip = ""
    try {
        $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -ErrorAction Stop).ip
    } catch {
        Write-Host "❌ Failed to get public IP."
        $ip = "UNKNOWN"
    }

    # Geolocation lookup
    if ($ip -ne "UNKNOWN") {
        try {
            $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip" -ErrorAction Stop
            if ($geo.status -eq "success") {
                Write-Host "`n🌐 IP: $($geo.query)"
                Write-Host "📍 Location: $($geo.city), $($geo.regionName), $($geo.country)"
                Write-Host "🧭 Coordinates: $($geo.lat), $($geo.lon)"
                Write-Host "🏢 ISP: $($geo.isp)`n"
            } else {
                Write-Host "⚠️ IP-API responded, but with failure: $($geo.message)"
            }
        } catch {
            Write-Host "❌ Geolocation lookup failed: $($_.Exception.Message)"
        }
    }
} catch {
    Write-Host "🔥 Unexpected script error: $($_.Exception.Message)"
}

# Delay to flush output
Start-Sleep -Milliseconds 800

# Self-destruct safely
try {
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force -ErrorAction SilentlyContinue
} catch {}
