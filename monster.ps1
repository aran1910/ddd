param(
    [string]$FileSource,            # URL or local path
    [string]$WebhookUrl             # Discord webhook URL
)

function Report($msg, $type = "info") {
    switch ($type) {
        "info" { Write-Host "[~] $msg" -ForegroundColor Yellow }
        "ok"   { Write-Host "[+] $msg" -ForegroundColor Green }
        "fail" { Write-Host "[!] $msg" -ForegroundColor Red }
    }
}

$tempFile = "$env:TEMP\$([System.IO.Path]::GetFileName($FileSource))"

# Download if it's a URL
if ($FileSource -match "^https?://") {
    try {
        Invoke-WebRequest -Uri $FileSource -OutFile $tempFile -UseBasicParsing
        Report "Downloaded file to $tempFile" "ok"
    } catch {
        Report "Failed to download file." "fail"
        exit 1
    }
} elseif (Test-Path $FileSource) {
    try {
        Copy-Item $FileSource $tempFile -Force
        Report "Copied local file to $tempFile" "ok"
    } catch {
        Report "Failed to copy local file." "fail"
        exit 1
    }
} else {
    Report "Invalid file source." "fail"
    exit 1
}

# Upload to Discord
try {
    $FileStream = [System.IO.File]::OpenRead($tempFile)
    $Form = @{
        'file' = New-Object System.Net.Http.StreamContent($FileStream)
    }

    $HttpClient = New-Object System.Net.Http.HttpClient
    $Content = New-Object System.Net.Http.MultipartFormDataContent
    $Content.Add($Form.file, 'file', [System.IO.Path]::GetFileName($tempFile))

    $Response = $HttpClient.PostAsync($WebhookUrl, $Content).Result

    if ($Response.IsSuccessStatusCode) {
        Report "File uploaded to Discord webhook." "ok"
    } else {
        Report "Upload failed: $($Response.StatusCode)" "fail"
    }

    $FileStream.Close()
    $HttpClient.Dispose()
} catch {
    Report "Error during upload." "fail"
}
