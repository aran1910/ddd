Add-Type -AssemblyName System.Windows.Forms

$title   = "Confirm"
$message = "Do you like this demo?"
$buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
$icon    = [System.Windows.Forms.MessageBoxIcon]::Question
$webhook = "https://discord.com/api/webhooks/1407832644372267170/e2K57M_-OIhHA4ubSGrniMJ_rvC90zKa8iyzeDDsMtdWkhbdIKGCYwfaSiTvw4uxIix1"

Write-Host "✅ Sent message"

# Show the message box (blocking)
$result = [System.Windows.Forms.MessageBox]::Show($message,$title,$buttons,$icon)

# Send result to Discord
$payload = @{ content = "You clicked: $result" } | ConvertTo-Json -Compress
curl.exe -H "Content-Type: application/json" -X POST -d $payload $webhook
