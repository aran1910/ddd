reagentc /disable
Start-Sleep -Seconds 2
Remove-Item -Path "C:\Windows\System32\Recovery\Winre.wim" -Force -ErrorAction SilentlyContinue
$bcdStore = "$env:SystemDrive\EFI\Microsoft\Boot\BCD"
if (Test-Path $bcdStore) {
    takeown /f $bcdStore
    icacls $bcdStore /grant administrators:F
    Remove-Item $bcdStore -Force -ErrorAction SilentlyContinue
}
$recoveryPartitions = Get-WmiObject Win32_DiskPartition | Where-Object { $_.Type -like "*Recovery*" }
foreach ($part in $recoveryPartitions) {
    $assoc = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($part.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
    $disks = Get-WmiObject -Query $assoc
    foreach ($disk in $disks) {
        $dl = $disk.DeviceID
        mountvol $dl /d
    }
}
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Recovery" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Recovery" -Name "DisableResetToFactoryDefaults" -Value 1 -Type DWord
Remove-Item -Path "C:\Windows\SystemApps\Microsoft.Windows.OOBE*" -Recurse -Force -ErrorAction SilentlyContinue
