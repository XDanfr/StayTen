# Windows Update Lock GUI Tool for PowerShell
# --------------------------------------------
# This script provides a simple GUI to:
# 1) Lock Windows Update to Windows 10 21H2 (prevent Win11 popups)
# 2) Undo changes if they wish to use Windows 11 (why)
# Requires Administrator rights; will self-elevate if needed.

# Self-elevate if not running as admin
$curUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($curUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process -FilePath "powershell.exe" -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File `"' + $MyInvocation.MyCommand.Definition + '`"' -Verb RunAs
    exit
}

# Registry path
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'

function Set-Lock21H2 {
    # Create key if needed and set values for Windows 10 21H2
    Try {
        New-Item -Path $regPath -Force | Out-Null
        Set-ItemProperty -Path $regPath -Name TargetReleaseVersion -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $regPath -Name ProductVersion -Value 'Windows 10' -Type String -Force
        Set-ItemProperty -Path $regPath -Name TargetReleaseVersionInfo -Value '21H2' -Type String -Force
    } Catch {
        [System.Windows.Forms.MessageBox]::Show("Error applying lock: $_","Error","OK","Error")
    }
}

function Set-Lock24H2 {
    # Set values for Windows 11 24H2
    Try {
        New-Item -Path $regPath -Force | Out-Null
        Set-ItemProperty -Path $regPath -Name TargetReleaseVersion -Value 1 -Type DWord -Force
        Set-ItemProperty -Path $regPath -Name ProductVersion -Value 'Windows 11' -Type String -Force
        Set-ItemProperty -Path $regPath -Name TargetReleaseVersionInfo -Value '24H2' -Type String -Force
    } Catch {
        [System.Windows.Forms.MessageBox]::Show("Error switching to Win11: $_","Error","OK","Error")
    }
}

# Load WinForms assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Build the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows Update Lock Tool'
$form.Size = New-Object System.Drawing.Size(420,150)
$form.StartPosition = 'CenterScreen'

# Button: Lock to Windows 10 21H2
$btnLock = New-Object System.Windows.Forms.Button
$btnLock.Location = New-Object System.Drawing.Point(20,40)
$btnLock.Size = New-Object System.Drawing.Size(160,40)
$btnLock.Text = 'Block Popups!'
$btnLock.Add_Click({
    Set-Lock21H2
    [System.Windows.Forms.MessageBox]::Show('Successfully locked to Windows 10 21H2.','Success','OK','Information')
})

# Button: Undo changes
$btnUndo = New-Object System.Windows.Forms.Button
$btnUndo.Location = New-Object System.Drawing.Point(220,40)
$btnUndo.Size = New-Object System.Drawing.Size(160,40)
$btnUndo.Text = 'Undo Changes'
$btnUndo.Add_Click({
    Set-Lock24H2
    [System.Windows.Forms.MessageBox]::Show('Undone changes and set target to Windows 11 24H2.','Success','OK','Information')
})

# Add controls and run
$form.Controls.AddRange(@($btnLock, $btnUndo))
[System.Windows.Forms.Application]::Run($form)
