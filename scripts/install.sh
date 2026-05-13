#!/bin/bash
# Install ZenSpace from GitHub Releases with checksum verification
set -e

REPO="kamilpopowicz/ZenSpace"
APP_NAME="ZenSpace"
INSTALL_DIR="/Applications"

echo "📥 Downloading latest ${APP_NAME}..."
RELEASE_JSON=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest")
DOWNLOAD_URL=$(echo "$RELEASE_JSON" | grep "browser_download_url.*\.zip\"" | cut -d '"' -f 4)
SHA_URL=$(echo "$RELEASE_JSON" | grep "browser_download_url.*\.sha256\"" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ No release found"
    exit 1
fi

TMPDIR=$(mktemp -d)
curl -sL "$DOWNLOAD_URL" -o "${TMPDIR}/${APP_NAME}.zip"

# Verify checksum if available
if [ -n "$SHA_URL" ]; then
    echo "🔒 Verifying checksum..."
    EXPECTED=$(curl -sL "$SHA_URL" | awk '{print $1}')
    ACTUAL=$(shasum -a 256 "${TMPDIR}/${APP_NAME}.zip" | awk '{print $1}')
    if [ "$EXPECTED" != "$ACTUAL" ]; then
        echo "❌ Checksum mismatch! Download may be corrupted."
        echo "   Expected: $EXPECTED"
        echo "   Got:      $ACTUAL"
        rm -rf "$TMPDIR"
        exit 1
    fi
    echo "   ✅ Checksum verified"
fi

echo "📦 Installing to ${INSTALL_DIR}..."
unzip -qo "${TMPDIR}/${APP_NAME}.zip" -d "$TMPDIR"

# Remove old version if exists
[ -d "${INSTALL_DIR}/${APP_NAME}.app" ] && rm -rf "${INSTALL_DIR}/${APP_NAME}.app"

mv "${TMPDIR}/${APP_NAME}.app" "${INSTALL_DIR}/"
rm -rf "$TMPDIR"

echo "✅ Installed: ${INSTALL_DIR}/${APP_NAME}.app"
echo "🚀 Launching..."
open "${INSTALL_DIR}/${APP_NAME}.app"
