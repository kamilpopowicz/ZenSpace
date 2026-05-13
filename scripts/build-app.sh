#!/bin/bash
# Build ZenSpace.app bundle from SPM binary
set -e

APP_NAME="ZenSpace"
BUNDLE_DIR=".build/release/${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "🔨 Building release binary..."
swift build -c release

echo "📦 Creating .app bundle..."
rm -rf "$BUNDLE_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

# Copy binary
cp ".build/release/${APP_NAME}" "$MACOS_DIR/"

# Copy Info.plist
cp "Sources/ZenSpace/Info.plist" "$CONTENTS_DIR/"

# Copy resources
cp -r Sources/ZenSpace/Resources/en.lproj "$RESOURCES_DIR/"
cp -r Sources/ZenSpace/Resources/pl.lproj "$RESOURCES_DIR/"
if [ -d "Sources/ZenSpace/Resources/Assets.xcassets" ]; then
    cp -r Sources/ZenSpace/Resources/Assets.xcassets "$RESOURCES_DIR/"
fi

# Copy sound files from reference bundle
if [ -d "Contents/Resources" ]; then
    cp Contents/Resources/*.caf "$RESOURCES_DIR/" 2>/dev/null || true
    cp Contents/Resources/*.m4a "$RESOURCES_DIR/" 2>/dev/null || true
    cp Contents/Resources/AppIcon.icns "$RESOURCES_DIR/" 2>/dev/null || true
fi

# PkgInfo
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

echo "✅ Built: $BUNDLE_DIR"
echo "   Size: $(du -sh "$BUNDLE_DIR" | cut -f1)"

# Create zip for distribution
ZIP_PATH=".build/release/${APP_NAME}.zip"
cd .build/release
zip -r -y "${APP_NAME}.zip" "${APP_NAME}.app"
cd ../..
echo "📎 Zipped: $ZIP_PATH ($(du -sh "$ZIP_PATH" | cut -f1))"
