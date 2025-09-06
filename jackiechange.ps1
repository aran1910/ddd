param (
    [string]$ImageUrl = "https://cdn.discordapp.com/attachments/1414005469336305684/1414007931288158416/Screenshot_2025-08-26_234108.png?ex=68be0101&is=68bcaf81&hm=908e05aeaf33affe66092de044a2ec04f3caaddb4ec04b91382c06eb40216921&"
)

# Path to store the downloaded wallpaper
$TempPath = "$env:TEMP\wallpaper.jpg"

# Download the image
try {
    Invoke-WebRequest -Uri $ImageUrl -OutFile $TempPath -UseBasicParsing
} catch {
    Write-Error "❌ Failed to download image: $ImageUrl"
    exit 1
}

# Add required Windows API to change wallpaper
Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int action, int param, string filePath, int flags);
}
"@

# Set the wallpaper (SPI_SETDESKWALLPAPER = 20, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE = 3)
$success = [Wallpaper]::SystemParametersInfo(20, 0, $TempPath, 3)

if ($success) {
    Write-Output "✅ Wallpaper set successfully from $ImageUrl"
} else {
    Write-Error "❌ Failed to set wallpaper."
}
