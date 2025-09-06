Add-Type -AssemblyName System.Device

$GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher
$GeoWatcher.Start()

Write-Host "`n[~] Acquiring your coordinates..." -ForegroundColor Yellow

while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
    Start-Sleep -Milliseconds 100
}  

if ($GeoWatcher.Permission -eq 'Denied') {
    Write-Host "`n[!] Access to location data was denied." -ForegroundColor Red
} else {
    $location = $GeoWatcher.Position.Location
    if ($location.IsUnknown) {
        Write-Host "`n[!] Unable to resolve location data." -ForegroundColor Red
    } else {
        $lat = "{0:N6}" -f $location.Latitude
        $lon = "{0:N6}" -f $location.Longitude

        Write-Host "`n[+] Location Acquired:" -ForegroundColor Green
        Write-Host "    Latitude : $lat"
        Write-Host "    Longitude: $lon"
        Write-Host "`n[~] Google Maps Link:" -ForegroundColor Cyan
        Write-Host "    https://www.google.com/maps?q=$lat,$lon" -ForegroundColor DarkGray
    }
}
