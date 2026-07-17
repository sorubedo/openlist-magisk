#!/system/bin/sh

if [ -x /data/adb/modules/runsvdir/system/bin/sv ]; then
    /data/adb/modules/runsvdir/system/bin/sv down openlist 2>/dev/null
    sleep 1
fi

rm -f /data/adb/runsvdir/service/openlist
rm -rf /data/adb/sv/openlist
