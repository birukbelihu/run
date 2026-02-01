$ErrorActionPreference = "Stop"

$Repo = "birukbelihu/run"
$BinName = "run.exe"
$InstallDir = "$env:LOCALAPPDATA\run"

$Asset = "run-windows-amd64.zip"

Write-Host "📦 Installing run (Windows amd64)"

$TempDir = New-Item -ItemType Directory -Force -Path ([System.IO.Path]::GetTempPath() + "run-install")
Set-Location $TempDir

Write-Host "⬇️  Downloading release assets..."
Invoke-WebRequest "https://github.com/$Repo/releases/latest/download/$Asset" -OutFile $Asset
Invoke-WebRequest "https://github.com/$Repo/releases/latest/download/checksums.txt" -OutFile "checksums.txt"

Write-Host "🔐 Verifying checksum..."
$Expected = (Select-String $Asset checksums.txt).ToString().Split(" ")[0]
$Actual = (Get-FileHash $Asset -Algorithm SHA256).Hash.ToLower()

if ($Expected -ne $Actual) {
    Write-Error "Checksum verification failed!"
    exit 1
}

Write-Host "📂 Extracting..."
Expand-Archive $Asset -Force

Write-Host "🚀 Installing to $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Move-Item $BinName "$InstallDir\$BinName" -Force

if (-not ($env:PATH -like "*$InstallDir*")) {
    Write-Host "🔧 Adding to PATH"
    setx PATH "$env:PATH;$InstallDir" | Out-Null
}

Write-Host "✅ Installed successfully!"
Write-Host "👉 Restart your terminal, then run: run --help"
