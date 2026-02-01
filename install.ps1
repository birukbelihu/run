#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$REPO = "birukbelihu/run"
$BIN_NAME = "run"
$INSTALL_DIR = "C:\Program Files\run"  # Windows equivalent of /usr/local/bin

# Detect OS and Architecture
$OS = if ($IsWindows) { "windows" } elseif ($IsLinux) { "linux" } elseif ($IsMacOS) { "darwin" } else { $null }
$ARCH = switch ((Get-CimInstance Win32_ComputerSystem).SystemType) {
    { $_ -match "x64|x86_64" } { "amd64" }
    { $_ -match "ARM64" } { "arm64" }
    default { $null }
}

# Alternative architecture detection using environment variable
if (-not $ARCH) {
    $ARCH = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } 
            elseif ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") { "amd64" } 
            else { $null }
}

if (-not $OS -or -not $ARCH) {
    Write-Error "Unsupported OS/Architecture: $OS/$ARCH"
    exit 1
}

$ASSET = "${BIN_NAME}-${OS}-${ARCH}.zip"  # Windows typically uses zip, not tar.gz
$RAW_BINARY = "${BIN_NAME}.exe"  # Windows executable

Write-Host "📦 Installing $BIN_NAME for $OS/$ARCH" -ForegroundColor Cyan

# Create temporary directory
$TMP_DIR = Join-Path $env:TEMP ([System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $TMP_DIR -Force | Out-Null
Set-Location $TMP_DIR

try {
    # Download release assets
    Write-Host "⬇️  Downloading release assets..." -ForegroundColor Yellow
    $releaseUrl = "https://github.com/$REPO/releases/latest/download/$ASSET"
    $checksumUrl = "https://github.com/$REPO/releases/latest/download/checksums.txt"
    
    Invoke-WebRequest -Uri $releaseUrl -OutFile $ASSET -UseBasicParsing
    Invoke-WebRequest -Uri $checksumUrl -OutFile "checksums.txt" -UseBasicParsing

    # Verify checksum (simplified version - adapt based on your checksum format)
    Write-Host "🔐 Verifying checksum..." -ForegroundColor Yellow
    $expectedHash = (Get-Content "checksums.txt" | Select-String $ASSET).ToString().Split()[0]
    $actualHash = (Get-FileHash $ASSET -Algorithm SHA256).Hash.ToLower()
    
    if ($expectedHash -ne $actualHash) {
        Write-Error "Checksum verification failed!"
        exit 1
    }

    # Extract zip file
    Write-Host "📂 Extracting..." -ForegroundColor Yellow
    Expand-Archive -Path $ASSET -DestinationPath $TMP_DIR -Force

    # Verify binary exists
    if (-not (Test-Path $RAW_BINARY)) {
        Write-Error "❌ Expected binary '$RAW_BINARY' not found"
        exit 1
    }

    # Ensure install directory exists
    if (-not (Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
    }

    # Install binary
    Write-Host "🚀 Installing to $INSTALL_DIR" -ForegroundColor Yellow
    Copy-Item -Path $RAW_BINARY -Destination (Join-Path $INSTALL_DIR $BIN_NAME) -Force

    # Add to PATH if not already present
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    if ($currentPath -notlike "*$INSTALL_DIR*") {
        $newPath = $INSTALL_DIR + ";" + $currentPath
        [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        Write-Host "✅ Added $INSTALL_DIR to system PATH" -ForegroundColor Green
    }

    Write-Host "✅ Installed successfully!" -ForegroundColor Green
    Write-Host "👉 Run: $BIN_NAME --help" -ForegroundColor Cyan
}
finally {
    # Cleanup temporary directory
    if (Test-Path $TMP_DIR) {
        Remove-Item -Path $TMP_DIR -Recurse -Force -ErrorAction SilentlyContinue
    }
}