param (
    [string]$ImageUrl = "https://cdn.discordapp.com/attachments/1414005469336305684/1414007931288158416/Screenshot_2025-08-26_234108.png?ex=68be0101&is=68bcaf81&hm=908e05aeaf33affe66092de044a2ec04f3caaddb4ec04b91382c06eb40216921&"
)

$TempPath = "$env:TEMP\wallpaper.jpg"

try {
    Invoke-WebRequest -Uri $ImageUrl -OutFile $TempPath -UseBasicParsing
} catch {
    Write-Host "Failed to download image."
    exit 1
}

Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

[Wallpaper]::SystemParametersInfo(20, 0, $TempPath, 3)
