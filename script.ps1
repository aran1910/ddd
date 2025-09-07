Add-Type -AssemblyName System.Windows.Forms

$title   = "Confirm"
$message = "Do you like this demo?"
$buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
$icon    = [System.Windows.Forms.MessageBoxIcon]::Question
$webhook = "https://discord.com/api/webhooks/1407832644372267170/e2K57M_-OIhHA4ubSGrniMJ_rvC90zKa8iyzeDDsMtdWkhbdIKGCYwfaSiTvw4uxIix1"

$result  = [System.Windows.Forms.MessageBox]::Show($message,$title,$buttons,$icon)
$systemname = whoami
# Proper JSON text
$json = @{ content = "$systemname clicked: $result" } | ConvertTo-Json -Compress

# Force BOM-less UTF-8
$tmp = [System.IO.Path]::GetTempFileName() + ".json"
[System.IO.File]::WriteAllText($tmp, $json, (New-Object System.Text.UTF8Encoding $false))

# Debug: show file contents
Write-Host "Payload file content:" (Get-Content $tmp -Raw)

# Send payload file to Discord
curl.exe -H "Content-Type: application/json" -X POST -d "@$tmp" $webhook
