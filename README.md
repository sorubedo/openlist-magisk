# openlist-runsv

OpenList as a runsv service for Magisk/KernelSU.

## Dependencies

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## Usage

1. Install both modules in Magisk/KernelSU.
2. Edit `/data/adb/sv/openlist/conf` to change args.
3. Enable `openlist` from the runsvdir WebUI.

## Action Button

Click the action button in Magisk/KernelSU and use volume keys to:
- **Vol Up** — Show admin info
- **Vol Down** — Random reset admin password

## Security Note

This module runs OpenList as `root` without any privilege dropping. Use at your own risk.
