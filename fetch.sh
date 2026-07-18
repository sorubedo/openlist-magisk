#!/bin/bash
set -euo pipefail

BIN_DIR="$(cd "$(dirname "$0")" && pwd)/bin"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

declare -A PLATS=(
    ["arm64-v8a"]="android-arm64"
    ["armeabi-v7a"]="android-arm"
    ["x86_64"]="android-amd64"
    ["x86"]="android-386"
)

echo "=> Fetching latest release from OpenListTeam/OpenList..."

RELEASE=$(curl -sLS "https://api.github.com/repos/OpenListTeam/OpenList/releases/latest")
TAG=$(echo "$RELEASE" | jq -r '.tag_name')
echo "   Tag: $TAG"

CHECKSUM_URL=$(echo "$RELEASE" | jq -r '.assets[] | select(.name == "md5-android.txt") | .browser_download_url')
curl -sSL "$CHECKSUM_URL" -o "$TMPDIR/md5-android.txt"
echo "   checksums downloaded"

for ABI in "${!PLATS[@]}"; do
    PLAT="${PLATS[$ABI]}"
    ASSET="openlist-${PLAT}.tar.gz"
    URL=$(echo "$RELEASE" | jq -r ".assets[] | select(.name == \"${ASSET}\") | .browser_download_url")

    if [ -z "$URL" ] || [ "$URL" = "null" ]; then
        echo "   skip $ABI: $ASSET not found"
        continue
    fi

    echo "   Downloading $ASSET..."
    curl -sSL "$URL" -o "$TMPDIR/$ASSET"

    echo -n "   Verifying... "
    EXPECTED_MD5=$(grep -F "./${ASSET}" "$TMPDIR/md5-android.txt" | awk '{print $1}')
    if [ -z "$EXPECTED_MD5" ]; then
        echo "WARNING: no checksum entry"
    else
        ACTUAL_MD5=$(md5sum "$TMPDIR/$ASSET" | awk '{print $1}')
        if [ "$ACTUAL_MD5" != "$EXPECTED_MD5" ]; then
            echo "FAILED: expected $EXPECTED_MD5 got $ACTUAL_MD5"
            exit 1
        fi
        echo "ok"
    fi

    echo "   Extracting..."
    mkdir -p "$BIN_DIR/$ABI" "$TMPDIR/$ABI"
    tar xzf "$TMPDIR/$ASSET" -C "$TMPDIR/$ABI"
    mv "$TMPDIR/$ABI/openlist" "$BIN_DIR/$ABI/openlist"
    chmod 755 "$BIN_DIR/$ABI/openlist"
    echo "   ok: bin/$ABI/openlist ($(du -h "$BIN_DIR/$ABI/openlist" | cut -f1))"
done

echo ""
echo "=> Done: $TAG"
