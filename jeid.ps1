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

Say "📄 File: $FileSource" "Cyan"
Say "🌐 Uploading to Discord webhook..." "Yellow"

$response = & curl.exe -s -F "file=@$FileSource" $WebhookUrl
$response = $response.Trim()

if ($response -match '"attachments"') {
    try {
        $json = $response | ConvertFrom-Json
        $attachment = $json.attachments[0]
        Say "✅ Upload successful!" "Green"
        Say "📎 Name: $($attachment.filename)" "Cyan"
        Say "📦 Size: $([math]::Round($attachment.size / 1024, 2)) KB" "Cyan"
        Say "🔗 URL: $($attachment.url)" "Magenta"
    } catch {
        Say "⚠ Upload worked but couldn't parse response." "DarkYellow"
        Say "📄 Raw response: $response" "Gray"
    }
} else {
    Say "❌ Upload failed!" "Red"
    Say "📄 Raw response: $response" "DarkGray"
    exit 1
}
