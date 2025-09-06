try {
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
    $geoType = [Windows.Devices.Geolocation.Geolocator, Windows.Devices.Geolocation, ContentType=WindowsRuntime]
    $geolocator = New-Object $geoType
    $position = $geolocator.GetGeopositionAsync().GetAwaiter().GetResult()
    $lat = $position.Coordinate.Point.Position.Latitude
    $lon = $position.Coordinate.Point.Position.Longitude

    Write-Host "`n🛰 Latitude: $lat"
    Write-Host "🛰 Longitude: $lon`n"
}
catch {
    Write-Host "❌ Failed to retrieve exact coordinates: $($_.Exception.Message)"
}
