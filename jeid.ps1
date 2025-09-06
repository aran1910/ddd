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

Say "📤 Uploading: $FileSource" "Cyan"
$response = & curl.exe -s -F "file=@$FileSource" $WebhookUrl

if ($response -match '"attachments"') {
    $json = $response | ConvertFrom-Json
    $attachment = $json.attachments[0]
    Say "✅ Uploaded: $($attachment.filename)" "Green"
    Say "📦 $([math]::Round($attachment.size/1024,2)) KB"
    Say "🔗 $($attachment.url)" "Magenta"
} else {
    Say "❌ Upload failed!"
    Say "$response" "DarkGray"
    exit 1
}
