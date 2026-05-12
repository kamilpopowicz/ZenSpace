#!/bin/bash
# ZenSpace Notarization Script
# STATUS: PLACEHOLDER - requires Apple Developer ID to function
#
# Prerequisites (when ready):
# 1. Apple Developer ID certificate installed in Keychain
# 2. Set TEAM_ID, APPLE_ID, APP_PASSWORD below
# 3. Run: chmod +x scripts/notarize.sh && ./scripts/notarize.sh

set -e

# === CONFIGURATION (fill in APP_PASSWORD when ready) ===
TEAM_ID="SY8DWFNG8P"
APPLE_ID="kamipopowicz@icloud.com"
APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"  # Generate at appleid.apple.com → Security → App-Specific Passwords
BUNDLE_ID="com.zenspace.app"
APP_NAME="ZenSpace"

echo "⚠️  Notarization is DISABLED - APP_PASSWORD not configured."
echo "    Generate one at: appleid.apple.com → Security → App-Specific Passwords"
echo "    Then replace the placeholder in this script."
exit 0

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
