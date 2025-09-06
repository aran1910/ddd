Write-Host "✅ jeid.ps1 STARTED"

if ($args.Count -lt 2) {
    Write-Host "❌ Not enough arguments. Args received: $($args.Count)"
    exit 1
}

Write-Host "✅ Arguments passed:"
Write-Host " - $($args[0])"
Write-Host " - $($args[1])"
