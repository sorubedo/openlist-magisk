#!/system/bin/sh

SVC_DIR=/data/adb/sv/openlist
cd "$SVC_DIR" || exit 1

ui_print() {
    echo "$1"
}

vol_sel() {
    ui_print ""
    ui_print "- Vol Up   = Show admin info"
    ui_print "- Vol Down = Random reset admin password"
    ui_print ""

    while true; do
        event="$(timeout 3 /system/bin/getevent -lqc 1 2>/dev/null)"
        if echo "$event" | grep -q "KEY_VOLUMEUP"; then
            return 0
        elif echo "$event" | grep -q "KEY_VOLUMEDOWN"; then
            return 1
        fi
    done
}

ui_print "=================================="
ui_print "  openlist-runsv"
ui_print "=================================="

if vol_sel; then
    ui_print "=> Admin info:"
    ui_print ""
    openlist admin
else
    ui_print "=> Random reset admin password..."
    ui_print ""
    openlist admin random
fi

ui_print ""
ui_print "Done."
