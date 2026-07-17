#!/system/bin/sh

case "$ARCH" in
    arm64)   ABI=arm64-v8a ;;
    arm)     ABI=armeabi-v7a ;;
    x64)     ABI=x86_64 ;;
    x86)     ABI=x86 ;;
    *)
        ui_print "! Unsupported architecture: $ARCH"
        abort "! Aborting installation"
        ;;
esac

ui_print "- Installing openlist for $ARCH ($ABI)"

OPENLIST_DIR=/data/adb/sv/openlist
OPENLIST_BIN_DIR="$OPENLIST_DIR/bin"

mkdir -p "$OPENLIST_BIN_DIR"
mkdir -p "$OPENLIST_DIR/data"
cp "$MODPATH/bin/$ABI/openlist" "$OPENLIST_BIN_DIR/"
set_perm "$OPENLIST_BIN_DIR/openlist" 0 0 0755

cp -r "$MODPATH/sv/openlist/"* "$OPENLIST_DIR/"
set_perm_recursive "$OPENLIST_DIR" 0 0 0755 0755

rm -rf "$MODPATH/bin" "$MODPATH/sv"

ui_print "- openlist installed to $OPENLIST_DIR"
