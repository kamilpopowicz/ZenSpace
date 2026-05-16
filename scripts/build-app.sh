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

# Copy resource bundle (SPM generates this for localized resources)
# Bundle.module looks in Bundle.main.bundleURL (root of .app)
RESOURCE_BUNDLE=".build/arm64-apple-macosx/release/ZenSpace_ZenSpace.bundle"
if [ -d "$RESOURCE_BUNDLE" ]; then
    cp -r "$RESOURCE_BUNDLE" "$BUNDLE_DIR/"
fi

# Copy Info.plist
cp "Sources/ZenSpace/Info.plist" "$CONTENTS_DIR/"

# Copy resources
cp -r Sources/ZenSpace/Resources/en.lproj "$RESOURCES_DIR/"
cp -r Sources/ZenSpace/Resources/pl.lproj "$RESOURCES_DIR/"

# Copy app icon
if [ -f "Sources/ZenSpace/Resources/AppIcon.icns" ]; then
    cp Sources/ZenSpace/Resources/AppIcon.icns "$RESOURCES_DIR/"
fi

# Copy sound files (if available in project sounds directory)
if [ -d "Sources/ZenSpace/Resources/Sounds" ]; then
    cp Sources/ZenSpace/Resources/Sounds/*.caf "$RESOURCES_DIR/" 2>/dev/null || true
    cp Sources/ZenSpace/Resources/Sounds/*.m4a "$RESOURCES_DIR/" 2>/dev/null || true
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
