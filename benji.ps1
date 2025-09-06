# benji.ps1 (debug mode)

try {
    Write-Host "`n🧪 START"
    $ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
    Write-Host "🌐 IP: $ip"

    $geo = Invoke-RestMethod -Uri "http://ip-api.com/json/$ip"
    Write-Host "📡 Raw geo response: $($geo | ConvertTo-Json -Depth 3)"

    if ($geo.status -eq "success") {
        Write-Host "📍 Location: $($geo.city), $($geo.regionName), $($geo.country)"
        Write-Host "🧭 GPS: $($geo.lat), $($geo.lon)"
        Write-Host "🏢 ISP: $($geo.isp)"
    } else {
        Write-Host "❌ API returned failure: $($geo.message)"
    }
}
catch {
    Write-Host "🔥 Error: $($_.Exception.Message)"
}

Start-Sleep -Seconds 3

try {
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force
    Write-Host "🧹 Script self-deleted successfully."
} catch {
    Write-Host "⚠️ Self-deletion failed: $($_.Exception.Message)"
}
