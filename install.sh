#!/usr/bin/env bash
set -e

# ===============================
#           Configuration
# ===============================
REPO="birukbelihu/run"
BIN_NAME="run"
INSTALL_DIR="/usr/local/bin"

# ===============================
#        Detect OS / Arch
# ===============================
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# ===============================
#      Normalize Architecture
# ===============================
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# ===============================
#        Detect Platform
# ===============================
case "$OS" in
  linux)  PLATFORM="linux" ;;
  darwin) PLATFORM="darwin" ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# ===============================
#       Prepare Asset Names
# ===============================
ASSET="${BIN_NAME}-${PLATFORM}-${ARCH}.tar.gz"
RAW_BINARY="${BIN_NAME}-${PLATFORM}-${ARCH}"

echo "Installing '$BIN_NAME' for $PLATFORM/$ARCH"

# ===============================
#      Create Temp Workspace
# ===============================
TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

cd "$TMP_DIR"

# ===============================
#        Download Assets
# ===============================
echo "Downloading release assets..."
curl -fsSLO "https://github.com/$REPO/releases/latest/download/$ASSET"
curl -fsSLO "https://github.com/$REPO/releases/latest/download/checksums.txt"

# ===============================
#      Verify Checksum
# ===============================
echo "Verifying checksum..."

if command -v sha256sum >/dev/null 2>&1; then
  CHECK_CMD="sha256sum -c -"
elif command -v shasum >/dev/null 2>&1; then
  CHECK_CMD="shasum -a 256 -c -"
else
  echo "No SHA-256 checksum tool found"
  exit 1
fi

grep "$ASSET" checksums.txt | eval "$CHECK_CMD"

# ===============================
#       Extract Archive
# ===============================
echo "Extracting..."
tar -xzf "$ASSET"

if [[ ! -f "$RAW_BINARY" ]]; then
  echo "Expected binary '$RAW_BINARY' not found"
  exit 1
fi

# ===============================
#        Install Binary
# ===============================
echo "Installing to $INSTALL_DIR"

if [[ ! -w "$INSTALL_DIR" ]]; then
  echo "Administrator privileges required for $INSTALL_DIR"
  SUDO="sudo"
else
  SUDO=""
fi

chmod +x "$RAW_BINARY"
$SUDO mv "$RAW_BINARY" "$INSTALL_DIR/$BIN_NAME"

# ===============================
#            Done
# ===============================
echo ""
echo "'run' installed successfully!"
echo "Try: $BIN_NAME --help"
