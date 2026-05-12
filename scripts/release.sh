#!/bin/bash
# Tag, build, and create GitHub Release with binary
set -e

VERSION="${1:-}"
if [ -z "$VERSION" ]; then
    echo "Usage: ./scripts/release.sh <version>"
    echo "Example: ./scripts/release.sh 1.0.0"
    exit 1
fi

TAG="v${VERSION}"
APP_NAME="ZenSpace"
ZIP_PATH=".build/release/${APP_NAME}.zip"

echo "🏷️  Releasing ${APP_NAME} ${TAG}..."

# Build .app bundle
./scripts/build-app.sh

# Verify zip exists
if [ ! -f "$ZIP_PATH" ]; then
    echo "❌ Build failed - no zip found"
    exit 1
fi

# Tag
echo "🏷️  Creating tag ${TAG}..."
git tag -a "$TAG" -m "Release ${TAG}"
git push origin "$TAG"

# Create GitHub Release
echo "📤 Creating GitHub Release..."
gh release create "$TAG" "$ZIP_PATH" \
    --title "${APP_NAME} ${TAG}" \
    --notes "## ${APP_NAME} ${TAG}

### Changes
- See commit history since last release

### Install
1. Download \`${APP_NAME}.zip\`
2. Unzip and move \`${APP_NAME}.app\` to \`/Applications\`
3. Launch from Applications or menu bar

### Auto-update
If you already have ZenSpace installed, it will prompt you to update automatically."

echo "✅ Released: https://github.com/kamilpopowicz/ZenSpace/releases/tag/${TAG}"
