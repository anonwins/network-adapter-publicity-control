<#
.SYNOPSIS
Simple tool to set a network adapter's profile to Private or Public.

.DESCRIPTION
- User manually enters the network adapter name
- User chooses Private or Public
- Script applies the change using Set-NetConnectionProfile

.NOTES
Right-click and select "Run with PowerShell" or run as Administrator.
#>

# Self-elevation to admin
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
if (-not $isAdmin) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell.exe -Verb RunAs -Wait -ArgumentList $arguments
    exit
}

# Get adapter name from user
$adapterName = Read-Host "Enter the network adapter name (e.g., Ethernet 2, Wi-Fi)"
if ([string]::IsNullOrWhiteSpace($adapterName)) {
    Write-Host "Adapter name cannot be empty."
    Read-Host "Press Enter to exit"
    exit 1
}

# Get profile choice from user
Write-Host ""
Write-Host "Select Network Profile"
Write-Host "----------------------"
Write-Host "[1] Private"
Write-Host "[2] Public"

$profile = $null
while ($null -eq $profile) {
    $choice = Read-Host "Choice"
    switch ($choice) {
        "1" { $profile = "Private" }
        "2" { $profile = "Public" }
        default { Write-Host "Invalid selection. Try again." }
    }
}

# Apply the change
try {
    Set-NetConnectionProfile -InterfaceAlias $adapterName -NetworkCategory $profile -ErrorAction Stop
    Write-Host ""
    Write-Host "Successfully changed '$adapterName' network profile to $profile."
}
catch {
    Write-Host "Failed to set network profile: $_"
    Read-Host "Press Enter to exit"
    exit 1
}

Read-Host "Press Enter to exit"
