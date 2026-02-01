# Requires PowerShell 7+
$ErrorActionPreference = "Stop"

$REPO = "birukbelihu/run"
$BIN_NAME = "run"

# Detect OS
if ($IsLinux) {
    $OS = "linux"
    $INSTALL_DIR = "/usr/local/bin"
} elseif ($IsMacOS) {
    $OS = "darwin"
    $INSTALL_DIR = "/usr/local/bin"
} elseif ($IsWindows) {
    $OS = "windows"
    $INSTALL_DIR = "$env:USERPROFILE\bin"
    if (-not (Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null
    }
} else {
    Write-Error "Unsupported OS"
    exit 1
}

# Detect architecture
$ARCH = (uname -m)
switch ($ARCH) {
    "x86_64" { $ARCH = "amd64" }
    "arm64" { $ARCH = "arm64" }
    "aarch64" { $ARCH = "arm64" }
    default {
        Write-Error "Unsupported architecture: $ARCH"
        exit 1
    }
}

# Windows binaries are .exe
$EXT = if ($IsWindows) { ".exe" } else { "" }

$ASSET = "$BIN_NAME-$OS-$ARCH.tar.gz"
$RAW_BINARY = "$BIN_NAME-$OS-$ARCH$EXT"

Write-Host "📦 Installing $BIN_NAME for $OS/$ARCH"

# Create temp directory
$TMP_DIR = New-Item -ItemType Directory -Path ([System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.Guid]::NewGuid().ToString()))
Set-Location $TMP_DIR.FullName

Write-Host "⬇️  Downloading release assets..."
Invoke-WebRequest -Uri "https://github.com/$REPO/releases/latest/download/$ASSET" -OutFile $ASSET
Invoke-WebRequest -Uri "https://github.com/$REPO/releases/latest/download/checksums.txt" -OutFile "checksums.txt"

Write-Host "🔐 Verifying checksum..."
$expectedHash = Select-String -Path "checksums.txt" -Pattern $ASSET | ForEach-Object { $_.Line.Split(' ')[0] }
$actualHash = Get-FileHash $ASSET -Algorithm SHA256 | Select-Object -ExpandProperty Hash
if ($expectedHash -ne $actualHash) {
    Write-Error "Checksum verification failed!"
    exit 1
}

Write-Host "📂 Extracting..."
if ($IsWindows) {
    # On Windows, you need tar.exe (comes with Windows 10+)
    tar -xzf $ASSET
} else {
    tar -xzf $ASSET
}

if (-not (Test-Path $RAW_BINARY)) {
    Write-Error "❌ Expected binary '$RAW_BINARY' not found"
    exit 1
}

Write-Host "🚀 Installing to $INSTALL_DIR"
if (-not $IsWindows) {
    chmod +x $RAW_BINARY
}

Move-Item $RAW_BINARY "$INSTALL_DIR\$BIN_NAME$EXT" -Force

# Ensure PATH contains the install directory on Windows
if ($IsWindows -and (-not ($env:PATH -split ';' | Where-Object { $_ -eq $INSTALL_DIR }))) {
    [Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$INSTALL_DIR", [EnvironmentVariableTarget]::User)
    Write-Host "✅ Added $INSTALL_DIR to your PATH. You may need to restart your shell."
}

Write-Host "✅ Installed successfully!"
Write-Host "👉 Run: $BIN_NAME$EXT --help"
