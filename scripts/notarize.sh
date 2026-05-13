#!/bin/bash
# ZenSpace Notarization Script
# STATUS: PLACEHOLDER - requires Apple Developer ID to function
#
# Prerequisites (when ready):
# 1. Apple Developer ID certificate installed in Keychain
# 2. Set TEAM_ID, APPLE_ID, APP_PASSWORD below
# 3. Run: chmod +x scripts/notarize.sh && ./scripts/notarize.sh

set -e

# === CONFIGURATION (from environment variables) ===
TEAM_ID="${ZENSPACE_TEAM_ID:-SY8DWFNG8P}"
APPLE_ID="${ZENSPACE_APPLE_ID:-kamipopowicz@icloud.com}"
APP_PASSWORD="${ZENSPACE_APP_PASSWORD:-}"
BUNDLE_ID="com.zenspace.app"
APP_NAME="ZenSpace"

if [ -z "$APP_PASSWORD" ]; then
    echo "⚠️  Notarization is DISABLED - ZENSPACE_APP_PASSWORD not set."
    echo "    Generate one at: appleid.apple.com → Security → App-Specific Passwords"
    echo "    Then: export ZENSPACE_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx"
    exit 0
fi

# === BUILD ===
echo "🔨 Building release..."
swift build -c release

# === SIGN ===
echo "🔏 Signing with hardened runtime..."
codesign --force --deep --options runtime \
    --sign "Developer ID Application: Your Name ($TEAM_ID)" \
    --entitlements Sources/ZenSpace/Resources/ZenSpace.entitlements \
    .build/release/$APP_NAME

# === PACKAGE ===
echo "📦 Creating ZIP..."
ditto -c -k --keepParent .build/release/$APP_NAME $APP_NAME.zip

# === NOTARIZE ===
echo "📤 Submitting for notarization..."
xcrun notarytool submit $APP_NAME.zip \
    --apple-id "$APPLE_ID" \
    --password "$APP_PASSWORD" \
    --team-id "$TEAM_ID" \
    --wait

# === STAPLE ===
echo "📎 Stapling ticket..."
xcrun stapler staple .build/release/$APP_NAME

echo "✅ Done! $APP_NAME is notarized and ready for distribution."
