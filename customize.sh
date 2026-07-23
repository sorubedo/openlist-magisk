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

if [ ! -f "$MODPATH/bin/$ABI/openlist" ]; then
    abort "! Wrong package: download the $ABI build for this device"
fi

mkdir -p "$MODPATH/system/bin"
cp "$MODPATH/bin/$ABI/openlist" "$MODPATH/system/bin/"
set_perm_recursive "$MODPATH/system/bin" 0 0 0755 0755

OPENLIST_DIR=/data/adb/sv/openlist
mkdir -p "$OPENLIST_DIR"
cp -r "$MODPATH/sv/openlist/"* "$OPENLIST_DIR/"
set_perm_recursive "$OPENLIST_DIR" 0 0 0755 0755

rm -rf "${MODPATH:?}/bin" "${MODPATH:?}/sv"

ui_print "- openlist installed to $OPENLIST_DIR"
ui_print "- Reboot required for Magisk to mount /system/bin/openlist"
