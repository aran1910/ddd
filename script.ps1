Add-Type -AssemblyName System.Windows.Forms

# Customize
$title   = "Confirm"
$message = "Do you like this demo?"
$buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo
$icon    = [System.Windows.Forms.MessageBoxIcon]::Question
$webhook = "https://discord.com/api/webhooks/1407832644372267170/e2K57M_-OIhHA4ubSGrniMJ_rvC90zKa8iyzeDDsMtdWkhbdIKGCYwfaSiTvw4uxIix1"

# Immediately print so it doesn't stall
Write-Host "✅ Sent message"

# Run message box in separate thread so it's non-blocking
$action = [System.Threading.ThreadStart]{
    $result  = [System.Windows.Forms.MessageBox]::Show($message,$title,$buttons,$icon)
    $payload = @{ content = "You clicked: $result" } | ConvertTo-Json -Compress
    curl.exe -H "Content-Type: application/json" -X POST -d $payload $using:webhook
}

$thread = [System.Threading.Thread]::new($action)
$thread.SetApartmentState([System.Threading.ApartmentState]::STA)
$thread.Start()
