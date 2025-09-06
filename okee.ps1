param (
    [string]$FileSource,
    [string]$WebhookUrl
)

function Say($msg, $color = "White") {
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

try {
    Add-Type -AssemblyName System.Net.Http

    $client = [System.Net.Http.HttpClient]::new()
    $content = [System.Net.Http.MultipartFormDataContent]::new()

    $fileStream = [System.IO.File]::OpenRead($tempFile)
    $fileContent = [System.Net.Http.StreamContent]::new($fileStream)
    $fileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse("application/octet-stream")
    $content.Add($fileContent, "file", $fileName)

    $response = $client.PostAsync($WebhookUrl, $content).Result
    $result = $response.Content.ReadAsStringAsync().Result

    if ($response.IsSuccessStatusCode) {
        try {
            $json = $result | ConvertFrom-Json
            $attachment = $json.attachments[0]

            Say "✅ Upload Successful" "Green"
            Say "📄 File: $($attachment.filename)" "Cyan"
            Say "📦 Size: $([math]::Round($attachment.size / 1024, 2)) KB" "Cyan"
            Say "🔗 Link: $($attachment.url)" "Cyan"
        } catch {
            Say "⚠️ Upload worked, but failed to parse Discord JSON." "Yellow"
            Say "Raw response:" "DarkGray"
            Say $result "Gray"
        }

        try { $fileStream.Close(); $client.Dispose() } catch {}
        exit 0
    } else {
        Say "❌ Upload failed: $($response.StatusCode)" "Red"
        Say $result "DarkGray"
        try { $fileStream.Close(); $client.Dispose() } catch {}
        exit 1
    }

} catch {
    Say "‼️ Exception occurred: $($_.Exception.Message)" "Red"
    exit 1
}
