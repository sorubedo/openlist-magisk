# openlist-runsv

OpenList as a runsv service for Magisk/KernelSU.

## Dependencies

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## Usage

1. Install both modules in Magisk/KernelSU, then **reboot**.
2. Edit `/data/adb/sv/openlist/conf` to change user/args.
3. Enable `openlist` from the runsvdir WebUI.

## Privilege Dropping

Runs via `chpst -u` by default as `shell:inet:sdcard_r:sdcard_wr`. Customize in `conf`:

```
CHPST_USER=shell:inet:sdcard_r:sdcard_rw
```

## Action Button

Click the action button in Magisk/KernelSU and use volume keys to:
- **Vol Up** — Show admin info
- **Vol Down** — Random reset admin password
