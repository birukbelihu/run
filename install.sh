#!/usr/bin/env bash
set -e

# ===============================
#           Config
# ===============================

REPO="birukbelihu/run"
BIN_NAME="run"
INSTALL_DIR="/usr/local/bin"

OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# ===============================
#      Normalize architecture
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
#      Detect platform/OS
# ===============================
if [[ "$OS" == "darwin" ]]; then
  PLATFORM="darwin"
elif [[ "$OS" == "linux" ]]; then
  PLATFORM="linux"
else
  echo "Unsupported OS: $OS"
  exit 1
fi

# ===============================
#         Prepare asset names
# ===============================
ASSET="${BIN_NAME}-${PLATFORM}-${ARCH}.tar.gz"
RAW_BINARY="${BIN_NAME}-${PLATFORM}-${ARCH}"

echo "Installing $BIN_NAME for $PLATFORM/$ARCH"

# ===============================
#      Create temporary workspace
# ===============================
TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

# ===============================
#         Download assets
# ===============================
echo "Downloading release assets..."
curl -fsSLO "https://github.com/$REPO/releases/latest/download/$ASSET"
curl -fsSLO "https://github.com/$REPO/releases/latest/download/checksums.txt"

# ===============================
#        Verify checksum
# ===============================
echo "Verifying checksum..."
grep "$ASSET" checksums.txt | sha256sum -c -

# ===============================
#          Extract archive
# ===============================
echo "Extracting..."
tar -xzf "$ASSET"

if [[ ! -f "$RAW_BINARY" ]]; then
  echo "❌ Expected binary '$RAW_BINARY' not found"
  exit 1
fi

# ===============================
#           Install binary
# ===============================
echo "Installing to $INSTALL_DIR"
chmod +x "$RAW_BINARY"
sudo mv "$RAW_BINARY" "$INSTALL_DIR/$BIN_NAME"

# ===============================
#           Done
# ===============================
echo "Installed successfully!"
echo "Run: $BIN_NAME --help"
