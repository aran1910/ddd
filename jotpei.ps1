param (
    [string]$FileSource,
    [string]$WebhookUrl
)

function Say($msg, $color = "White") {
    Write-Host ">> $msg" -ForegroundColor $color
}

if (!(Test-Path $FileSource)) {
    Say "❌ File not found: $FileSource" "Red"
    exit 1
}

Say "📄 Sending file: $FileSource" "Yellow"

# Use curl to send the file to the webhook
$response = & curl.exe -s -F "file=@$FileSource" $WebhookUrl

if ($LASTEXITCODE -eq 0 -and $response -like '*"attachments":*') {
    $json = $response | ConvertFrom-Json
    $attachment = $json.attachments[0]

    Say "✅ Upload successful!" "Green"
    Say "📎 Name: $($attachment.filename)" "Cyan"
    Say "📦 Size: $([math]::Round($attachment.size / 1024, 2)) KB" "Cyan"
    Say "🔗 URL: $($attachment.url)" "Magenta"
} else {
    Say "❌ Upload failed." "Red"
    Say $response "DarkGray"
}
