#Requires -Version 5.1
<#
.SYNOPSIS
    Bmox Uninstaller for Windows
.DESCRIPTION
    Removes the Bmox CLI and cleans up the User PATH.
.EXAMPLE
    irm https://bmox.vercel.app/uninstall-win | iex
#>

$ErrorActionPreference = 'Stop'

$InstallDir = "$env:USERPROFILE\.bmox\bin"
$ConfigDir  = "$env:USERPROFILE\.bmox"
$BinaryName = "bmox.exe"

# ── Colors ────────────────────────────────────────────────────────────────────
function Write-Info    ($msg) { Write-Host "  → " -NoNewline -ForegroundColor Cyan;    Write-Host $msg }
function Write-Success ($msg) { Write-Host "  ✓ " -NoNewline -ForegroundColor Green;   Write-Host $msg }
function Write-Warn    ($msg) { Write-Host "  ! " -NoNewline -ForegroundColor Yellow;  Write-Host $msg }

Write-Host ""
Write-Host "  " -NoNewline
Write-Host "◉ Bmox Uninstaller" -ForegroundColor White -BackgroundColor DarkGray
Write-Host "  ─────────────────────────────────────────"
Write-Host ""

# ── Remove Binary ─────────────────────────────────────────────────────────────
$BinPath = Join-Path $InstallDir $BinaryName
if (Test-Path $BinPath) {
    Write-Info "Removing $BinaryName..."
    Remove-Item -Path $BinPath -Force
    Write-Success "Binary removed."
} else {
    Write-Info "Bmox binary not found at $BinPath. Skipping."
}

# ── Clean up User PATH ────────────────────────────────────────────────────────
$CurrentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($CurrentPath -like "*$InstallDir*") {
    Write-Info "Removing $InstallDir from User PATH..."
    
    # Split, filter out the Bmox dir, and join back
    $Paths = $CurrentPath -split ';'
    $NewPaths = $Paths | Where-Object { $_ -ne $InstallDir -and $_ -ne "$InstallDir\" }
    $NewPathString = $NewPaths -join ';'
    
    [System.Environment]::SetEnvironmentVariable("PATH", $NewPathString, "User")
    
    # Also update current session
    $env:PATH = $NewPathString
    Write-Success "PATH cleaned up."
} else {
    Write-Info "Bmox not found in User PATH. Skipping."
}

# ── Optional Config Cleanup ───────────────────────────────────────────────────
if (Test-Path $ConfigDir) {
    Write-Host ""
    $resp = Read-Host "  ? Do you want to remove all Bmox configurations and data in $ConfigDir? (y/N)"
    if ($resp -match "^[yY]") {
        Write-Info "Removing $ConfigDir..."
        Remove-Item -Path $ConfigDir -Recurse -Force
        Write-Success "Configuration removed."
    } else {
        Write-Info "Configuration kept at $ConfigDir."
    }
}

Write-Host ""
Write-Host "  ─────────────────────────────────────────"
Write-Success "Bmox has been uninstalled successfully."
Write-Warn "Restart your terminal for PATH changes to fully take effect."
Write-Host ""
