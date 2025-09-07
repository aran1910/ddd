Add-Type -AssemblyName System.Windows.Forms

$title   = "Confirm"
$message = "Do you like this demo?"
$buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
$icon    = [System.Windows.Forms.MessageBoxIcon]::Question
$webhook = "https://discord.com/api/webhooks/1407832644372267170/e2K57M_-OIhHA4ubSGrniMJ_rvC90zKa8iyzeDDsMtdWkhbdIKGCYwfaSiTvw4uxIix1"

$result  = [System.Windows.Forms.MessageBox]::Show($message,$title,$buttons,$icon)

# Build JSON properly (no invalid 50109 errors)
$json = @{ content = "You clicked: $result" } | ConvertTo-Json -Compress -Depth 3
[System.IO.File]::WriteAllText("C:\Temp\payload.json",$json)   # <— debug line
curl.exe -H "Content-Type: application/json" -X POST -d "@C:\Temp\payload.json" $webhook
