$ErrorActionPreference = "Stop"

$Repo = "birukbelihu/run"
$BinName = "run.exe"
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

Write-Host "📦 Installing run for $Platform/$Arch"

$TmpDir = Join-Path $env:TEMP ("run-install-" + [guid]::NewGuid())
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
Set-Location $TmpDir

Write-Host "⬇️  Downloading release assets..."
iwr -useb "https://github.com/$Repo/releases/latest/download/$Asset" -OutFile $Asset
iwr -useb "https://github.com/$Repo/releases/latest/download/checksums.txt" -OutFile checksums.txt

Write-Host "🔐 Verifying checksum..."
$Expected = (Select-String $Asset checksums.txt).Line.Split(" ")[0].ToLower()
$Actual = (Get-FileHash $Asset -Algorithm SHA256).Hash.ToLower()

if ($Expected -ne $Actual) {
    Write-Error "Checksum verification failed"
    exit 1
}

Write-Host "📂 Extracting..."
Expand-Archive $Asset -Force

if (-not (Test-Path "run.exe")) {
    Write-Error "run.exe not found in archive"
    exit 1
}

Write-Host "🚀 Installing to $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Move-Item run.exe "$InstallDir\$BinName" -Force

# Add to PATH (user scope)
$Path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($Path -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$Path;$InstallDir", "User")
    Write-Host "➕ Added to PATH (restart terminal)"
}

Write-Host "✅ Installed successfully!"
Write-Host "👉 Run: run --help"
