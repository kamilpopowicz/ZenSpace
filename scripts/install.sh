#!/bin/bash
# Install ZenSpace from GitHub Releases
set -e

REPO="kamilpopowicz/ZenSpace"
APP_NAME="ZenSpace"
INSTALL_DIR="/Applications"

echo "📥 Downloading latest ${APP_NAME}..."
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep "browser_download_url.*zip" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ No release found"
    exit 1
fi

TMPDIR=$(mktemp -d)
curl -sL "$DOWNLOAD_URL" -o "${TMPDIR}/${APP_NAME}.zip"

echo "📦 Installing to ${INSTALL_DIR}..."
unzip -qo "${TMPDIR}/${APP_NAME}.zip" -d "$TMPDIR"

# Remove old version if exists
[ -d "${INSTALL_DIR}/${APP_NAME}.app" ] && rm -rf "${INSTALL_DIR}/${APP_NAME}.app"

mv "${TMPDIR}/${APP_NAME}.app" "${INSTALL_DIR}/"
rm -rf "$TMPDIR"

echo "✅ Installed: ${INSTALL_DIR}/${APP_NAME}.app"
echo "🚀 Launching..."
open "${INSTALL_DIR}/${APP_NAME}.app"
