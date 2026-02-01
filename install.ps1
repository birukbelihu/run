$ErrorActionPreference = "Stop"

$Repo = "birukbelihu/run"

# Final installed command (users type `run`)
$FinalBinaryName = "run.exe"

$InstallDir = "$env:LOCALAPPDATA\run"
$Platform = "windows"

# Detect architecture
$Arch = $env:PROCESSOR_ARCHITECTURE.ToLower()
switch ($Arch) {
    "amd64" { $Arch = "amd64" }
    "arm64" { $Arch = "arm64" }
    default {
        Write-Error "Unsupported architecture: $Arch"
        exit 1
    }
}

$Asset = "run-$Platform-$Arch.zip"
$ExtractedBinary = "run-$Platform-$Arch.exe"

Write-Host "📦 Installing run for $Platform/$Arch"

# Temp directory
$TempDir = Join-Path $env:TEMP "run-install"
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
Set-Location $TempDir

Write-Host "⬇️  Downloading release assets..."
Invoke-WebRequest "https://github.com/$Repo/releases/latest/download/$Asset" -OutFile $Asset
Invoke-WebRequest "https://github.com/$Repo/releases/latest/download/checksums.txt" -OutFile "checksums.txt"

Write-Host "🔐 Verifying checksum..."
$Line = Get-Content "checksums.txt" | Where-Object { $_ -match $Asset }

if (-not $Line) {
    Write-Error "Checksum entry for $Asset not found"
    exit 1
}

$Expected = ($Line -split '\s+')[0].ToLower()
$Actual   = (Get-FileHash $Asset -Algorithm SHA256).Hash.ToLower()

if ($Expected -ne $Actual) {
    Write-Error "Checksum verification failed!"
    exit 1
}

Write-Host "✔ Checksum OK"

Write-Host "📂 Extracting..."
Expand-Archive $Asset -DestinationPath . -Force

if (-not (Test-Path $ExtractedBinary)) {
    Write-Error "Expected binary '$ExtractedBinary' not found after extraction"
    exit 1
}

Write-Host "🚀 Installing to $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# 🔑 Rename during install: run-windows-amd64.exe → run.exe
Move-Item $ExtractedBinary (Join-Path $InstallDir $FinalBinaryName) -Force

# Add to PATH if missing
if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $InstallDir })) {
    Write-Host "🔧 Adding to PATH"
    setx PATH "$env:PATH;$InstallDir" | Out-Null
}

Write-Host "✅ Installed successfully!"
Write-Host "👉 Restart your terminal, then run: run --help"
