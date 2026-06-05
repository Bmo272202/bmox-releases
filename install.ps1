#Requires -Version 5.1
<#
.SYNOPSIS
    Bmox Installer for Windows
.DESCRIPTION
    Downloads and installs the latest Bmox CLI for Windows x64.
    Automatically adds bmox to your User PATH.
.EXAMPLE
    irm https://raw.githubusercontent.com/bmo272202/bmox/main/install.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

$Repo       = "bmo272202/bmox-releases"  # Repositorio público satélite (binarios públicos, código fuente privado)
$InstallDir = "$env:USERPROFILE\.bmox\bin"
$BinaryName = "bmox.exe"

# ── Colors ────────────────────────────────────────────────────────────────────
function Write-Info    ($msg) { Write-Host "  → " -NoNewline -ForegroundColor Cyan;    Write-Host $msg }
function Write-Success ($msg) { Write-Host "  ✓ " -NoNewline -ForegroundColor Green;   Write-Host $msg }
function Write-Warn    ($msg) { Write-Host "  ! " -NoNewline -ForegroundColor Yellow;  Write-Host $msg }
function Write-Fail    ($msg) { Write-Host "  ✗ " -NoNewline -ForegroundColor Red;     Write-Host $msg; exit 1 }

Write-Host ""
Write-Host "  " -NoNewline
Write-Host "◉ Bmox Installer" -ForegroundColor White -BackgroundColor DarkGray
Write-Host "  ─────────────────────────────────────────"
Write-Host ""

# ── Verify Architecture ───────────────────────────────────────────────────────
if ([System.Environment]::Is64BitOperatingSystem -eq $false) {
    Write-Fail "Bmox requires a 64-bit Windows system."
}

$arch = $env:PROCESSOR_ARCHITECTURE
if ($arch -eq "ARM64") {
    $Rid = "win-arm64"
} elseif ($arch -eq "AMD64") {
    $Rid = "win-x64"
} else {
    Write-Fail "Unsupported architecture: $arch. Bmox requires x64 or ARM64."
}

$AssetName = "bmox-$Rid.zip"

Write-Info "Detected platform: $Rid"

# ── Fetch latest release ──────────────────────────────────────────────────────
Write-Info "Fetching latest release..."

try {
    $Releases = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases?per_page=1" `
               -Headers @{ "User-Agent" = "bmox-installer" }
    if ($Releases.Count -eq 0) {
        Write-Fail "No releases found in $Repo."
    }
    $LatestTag = $Releases[0].tag_name
} catch {
    Write-Fail "Could not fetch the latest release from GitHub: $_"
}

Write-Info "Latest version: $LatestTag"

$DownloadUrl = "https://github.com/$Repo/releases/download/$LatestTag/$AssetName"

# ── Download ──────────────────────────────────────────────────────────────────
$TmpDir  = Join-Path $env:TEMP "bmox-install-$([System.IO.Path]::GetRandomFileName())"
$TmpZip  = Join-Path $TmpDir $AssetName

New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

Write-Info "Downloading $AssetName..."
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $TmpZip -UseBasicParsing
} catch {
    Write-Fail "Download failed: $_"
}

# ── Extract ───────────────────────────────────────────────────────────────────
Write-Info "Extracting..."
Expand-Archive -Path $TmpZip -DestinationPath $TmpDir -Force

# ── Install ───────────────────────────────────────────────────────────────────
Write-Info "Installing to $InstallDir..."
New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
Copy-Item -Path (Join-Path $TmpDir $BinaryName) -Destination (Join-Path $InstallDir $BinaryName) -Force
Remove-Item -Path $TmpDir -Recurse -Force

# ── Add to User PATH ──────────────────────────────────────────────────────────
$CurrentPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")
if ($CurrentPath -notlike "*$InstallDir*") {
    Write-Info "Adding $InstallDir to User PATH..."
    [System.Environment]::SetEnvironmentVariable(
        "PATH",
        "$CurrentPath;$InstallDir",
        "User"
    )
    # Also update current session
    $env:PATH = "$env:PATH;$InstallDir"
    Write-Success "PATH updated. Restart your terminal to apply."
} else {
    Write-Info "$InstallDir already in PATH."
}

# ── Verify ────────────────────────────────────────────────────────────────────
$BinPath = Join-Path $InstallDir $BinaryName
if (Test-Path $BinPath) {
    Write-Success "bmox $LatestTag installed successfully at $BinPath"
} else {
    Write-Fail "Installation failed — binary not found at expected location."
}

Write-Host ""
Write-Host "  ─────────────────────────────────────────"
Write-Host "  Getting started:" -ForegroundColor White
Write-Host ""
Write-Host "    bmox init my-project"
Write-Host "    cd my-project"
Write-Host "    bmox config"
Write-Host "    bmox run main `"Hello, Bmox!`""
Write-Host ""
Write-Host "  Docs: " -NoNewline
Write-Host "https://bmox.io/docs" -ForegroundColor Cyan
Write-Host ""
Write-Warn "Restart your terminal for PATH changes to take effect."
Write-Host ""
