Add-Type -AssemblyName System.Windows.Forms

$title   = "Confirm"
$message = "Do you like this demo?"
$buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
$icon    = [System.Windows.Forms.MessageBoxIcon]::Question
$webhook = "https://discord.com/api/webhooks/1407832644372267170/e2K57M_-OIhHA4ubSGrniMJ_rvC90zKa8iyzeDDsMtdWkhbdIKGCYwfaSiTvw4uxIix1"

Write-Host "✅ Sent message"

$action = {
    Add-Type -AssemblyName System.Windows.Forms
    $result  = [System.Windows.Forms.MessageBox]::Show($using:message,$using:title,$using:buttons,$using:icon)
    $payload = @{ content = "You clicked: $result" } | ConvertTo-Json -Compress
    curl.exe -H "Content-Type: application/json" -X POST -d $payload $using:webhook
}

$thread = New-Object System.Threading.Thread ($action)
$thread.SetApartmentState('STA')
$thread.Start()
