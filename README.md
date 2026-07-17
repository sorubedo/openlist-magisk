# openlist-runsv

OpenList as a runsv service for Magisk/KernelSU.

## Dependencies

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## Download

Release attachments are **not** kept in sync with upstream OpenList versions.
Use GitHub Actions to get the latest build:

1. Go to the [Build Workflow](https://github.com/sorubedo/openlist-magisk/actions/workflows/build.yml)
2. Click **Run workflow** → **Run workflow**
3. Wait for the run to finish, then download the zip from **Artifacts**

## Usage

1. Install both modules in Magisk/KernelSU, then **reboot**.
2. Edit `/data/adb/sv/openlist/conf` to change user/args.
3. Enable `openlist` from the runsvdir WebUI.

## Manual Binary Update

If you already have the module installed, you can replace just the binary
without reinstalling the entire module:

1. Download the artifact zip from Actions
2. Extract the binary matching your device ABI (`bin/<abi>/openlist`)
3. Copy it to `/data/adb/modules/openlist-runsv/system/bin/openlist`
4. Reboot

Or restart the service via runsvdir WebUI / `sv restart openlist`.

## Privilege Dropping

Runs via `chpst -u` by default as `shell:inet:sdcard_r:sdcard_wr`. Customize in `conf`:

```
CHPST_USER=shell:inet:sdcard_r:sdcard_rw
```

## Action Button

Click the action button in Magisk/KernelSU and use volume keys to:
- **Vol Up** — Show admin info
- **Vol Down** — Random reset admin password
