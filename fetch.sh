#!/bin/bash
set -euo pipefail

REPO="OpenListTeam/OpenList"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
TMPDIR="$(mktemp -d)"

trap 'rm -rf "$TMPDIR"' EXIT

echo "=> Fetching latest release from $REPO..."
API_URL="https://api.github.com/repos/$REPO/releases/latest"
RELEASE_JSON=$(curl -sLS "$API_URL")
TAG=$(echo "$RELEASE_JSON" | grep -o '"tag_name": *"[^"]*"' | head -1 | cut -d'"' -f4)
echo "   Latest: $TAG"

declare -A ABIS=(
    ["arm64-v8a"]="android-arm64"
    ["armeabi-v7a"]="android-arm"
    ["x86_64"]="android-amd64"
    ["x86"]="android-386"
)

echo "=> Fetching checksums..."
CHECKSUM_URL=$(echo "$RELEASE_JSON" | grep -o "\"browser_download_url\": *\"[^\"]*md5-android.txt\"" | cut -d'"' -f4)
curl -sSL "$CHECKSUM_URL" -o "$TMPDIR/md5-android.txt"

for ABI in "${!ABIS[@]}"; do
    PLATFORM="${ABIS[$ABI]}"
    ASSET="openlist-${PLATFORM}.tar.gz"
    URL=$(echo "$RELEASE_JSON" | grep -o "\"browser_download_url\": *\"[^\"]*${ASSET}\"" | cut -d'"' -f4)

    if [ -z "$URL" ]; then
        echo "   skip $ABI: no $ASSET in release"
        continue
    fi

    echo "=> Downloading $ASSET..."
    curl -sSL "$URL" -o "$TMPDIR/$ASSET"

    echo "=> Verifying checksum for $ASSET..."
    EXPECTED_MD5=$(grep -F "./${ASSET}" "$TMPDIR/md5-android.txt" | awk '{print $1}')
    if [ -z "$EXPECTED_MD5" ]; then
        echo "!! WARNING: no checksum found for $ASSET"
    else
        ACTUAL_MD5=$(md5sum "$TMPDIR/$ASSET" | awk '{print $1}')
        if [ "$ACTUAL_MD5" != "$EXPECTED_MD5" ]; then
            echo "!! CHECKSUM MISMATCH for $ASSET: expected $EXPECTED_MD5, got $ACTUAL_MD5"
            exit 1
        fi
        echo "   checksum ok"
    fi

    echo "=> Extracting openlist for $ABI..."
    mkdir -p "$BIN_DIR/$ABI" "$TMPDIR/$ABI"
    tar xzf "$TMPDIR/$ASSET" -C "$TMPDIR/$ABI"
    mv "$TMPDIR/$ABI/openlist" "$BIN_DIR/$ABI/openlist"
    chmod 755 "$BIN_DIR/$ABI/openlist"
    echo "   ok: bin/$ABI/openlist ($(du -h "$BIN_DIR/$ABI/openlist" | cut -f1))"
done

echo ""
echo "=> Done: $TAG"
