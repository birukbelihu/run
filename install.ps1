$ErrorActionPreference = "Stop"

# ===============================
#           Config
# ===============================

$Repo       = "birukbelihu/run"
$InstallDir = "$env:LOCALAPPDATA\run"
$Platform   = "windows"
$FinalBin   = "run.exe"

Write-Host "Installing run for Windows..."

# ===============================
#     Detect architecture
# ===============================

$Arch = $env:PROCESSOR_ARCHITECTURE.ToLower()
switch ($Arch) {
    "amd64" { $Arch = "amd64" }
    "arm64" {
        Write-Error "Windows arm64 build not available yet"
        exit 1
    }
    default {
        Write-Error "Unsupported architecture: $Arch"
        exit 1
    }
}

$Asset = "run-$Platform-$Arch.zip"

# ===============================
#      Temp workspace
# ===============================
$TmpDir = Join-Path $env:TEMP ("run-install-" + [guid]::NewGuid())
New-Item -ItemType Directory -Force -Path $TmpDir | Out-Null
Set-Location $TmpDir

# ===============================
#         Download
# ===============================
Write-Host "Downloading release assets..."
irm "https://github.com/$Repo/releases/latest/download/$Asset" -OutFile $Asset
irm "https://github.com/$Repo/releases/latest/download/checksums.txt" -OutFile "checksums.txt"

# ===============================
#      Verify checksum
# ===============================
Write-Host "Verifying checksum..."
$ExpectedHash = (Select-String $Asset checksums.txt).Line.Split(" ")[0].ToLower()
$ActualHash   = (Get-FileHash $Asset -Algorithm SHA256).Hash.ToLower()

if ($ExpectedHash -ne $ActualHash) {
    Write-Error "Checksum verification failed"
    exit 1
}

# ===============================
#          Extract
# ===============================
Write-Host "Extracting..."
Expand-Archive $Asset -Force

# ===============================
#     Find the executable
# ===============================
$Exe = Get-ChildItem -Recurse -Filter "*.exe" | Select-Object -First 1

if (-not $Exe) {
    Write-Error "No executable found in the archive!"
    exit 1
}

# ===============================
#           Install
# ===============================
Write-Host "Installing to $InstallDir"
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Move-Item $Exe.FullName "$InstallDir\$FinalBin" -Force

# ===============================
#     Add to PATH
# ===============================
$UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($UserPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable(
        "PATH",
        "$UserPath;$InstallDir",
        "User"
    )
    Write-Host "Added to PATH (restart terminal)"
}

# ===============================
#           Done
# ===============================
Write-Host "run installed successfully!"
Write-Host "Restart terminal and run:"
Write-Host "run --help"
