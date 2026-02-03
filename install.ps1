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
# Handle WOW64 correctly
$Arch = if ($env:PROCESSOR_ARCHITEW6432) {
    $env:PROCESSOR_ARCHITEW6432
} else {
    $env:PROCESSOR_ARCHITECTURE
}

$Arch = $Arch.ToLower()

switch ($Arch) {
    "amd64" { $Arch = "amd64" }
    "arm64" {
        Write-Error "Windows ARM64 build is not available yet"
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

try {
    Set-Location $TmpDir

    # ===============================
    #         Download
    # ===============================
    Write-Host "Downloading release assets..."
    Invoke-RestMethod `
        "https://github.com/$Repo/releases/latest/download/$Asset" `
        -OutFile $Asset

    Invoke-RestMethod `
        "https://github.com/$Repo/releases/latest/download/checksums.txt" `
        -OutFile "checksums.txt"

    # ===============================
    #      Verify checksum
    # ===============================
    Write-Host "Verifying checksum..."

    $ExpectedHash = (
        Select-String -Path "checksums.txt" -Pattern $Asset |
        Select-Object -First 1
    ).Line.Split(" ")[0].ToLower()

    if (-not $ExpectedHash) {
        Write-Error "Checksum entry not found for $Asset"
        exit 1
    }

    $ActualHash = (Get-FileHash $Asset -Algorithm SHA256).Hash.ToLower()

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
    #     Find executable
    # ===============================
    $Exe = Get-ChildItem -Recurse -Filter "*.exe" | Select-Object -First 1

    if (-not $Exe) {
        Write-Error "No executable found in the archive"
        exit 1
    }

    # ===============================
    #           Install
    # ===============================
    Write-Host "Installing to $InstallDir"
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
    Move-Item $Exe.FullName (Join-Path $InstallDir $FinalBin) -Force

    # ===============================
    #        Add to PATH
    # ===============================
    $UserPath = [Environment]::GetEnvironmentVariable("PATH", "User")

    if ($UserPath -notmatch [regex]::Escape($InstallDir)) {
        [Environment]::SetEnvironmentVariable(
            "PATH",
            "$UserPath;$InstallDir",
            "User"
        )
        Write-Host "Added to PATH (restart terminal required)"
    }

    # ===============================
    #           Done
    # ===============================
    Write-Host ""
    Write-Host "✅ run installed successfully!"
    Write-Host "➡️  Restart your terminal and run:"
    Write-Host "   run --help"
}
finally {
    # ===============================
    #          Cleanup
    # ===============================
    Set-Location $env:TEMP
    Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
}
