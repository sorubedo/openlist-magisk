# openlist-runsv

[OpenList](https://github.com/OpenListTeam/OpenList) as a runsv service for Magisk/KernelSU.

## Dependencies

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## Download

Release attachments are **not** kept in sync with upstream OpenList versions.
Use GitHub Actions to get the latest build:

1. Go to the [Build Workflow](https://github.com/sorubedo/openlist-magisk/actions/workflows/build.yml)
2. Click **Run workflow** → **Run workflow**
3. Wait for the run to finish, then download the zip from **Artifacts**

## Installation

1. Install `runsvdir-magisk` first, then install this module in Magisk/KernelSU.
2. **Reboot** your device.
3. Link `openlist` from the runsvdir WebUI or run `ln -s /data/adb/sv/openlist /data/adb/runsvdir/service/` in a root shell.

## Configuration

Create `/data/adb/sv/openlist/conf` to customize the service. All variables are optional.

| Variable | Default | Description |
|---|---|---|
| `CHPST_USER` | `shell:inet:sdcard_r:sdcard_rw` | User and groups for `chpst` (process privilege) |
| `OPENLIST_ARGS` | `--data /storage/emulated/0/Android/openlist` | Arguments passed to `openlist server` |
| `WAIT_DECRYPT` | `1` | Wait for storage decryption before starting (set `0` to skip) |

Example:

```sh
CHPST_USER=shell:inet:sdcard_r:sdcard_rw
OPENLIST_ARGS="--data /storage/emulated/0/Android/openlist"
WAIT_DECRYPT=1
```

## Action Button

Click the action button in Magisk/KernelSU and use volume keys to:

- **Vol Up** — Show admin info (login credentials)
- **Vol Down** — Random reset admin password

## Command Line

you can control the service from a root shell instead runsvdir webui:

```sh
# Enable / Disable
sv-enable openlist
sv-disable openlist

# up / down / status
sv up openlist
sv down openlist
sv status openlist

# View svlogd logs
tail -f /data/adb/runsvdir/log/sv/openlist/current

```

## Manual Binary Update

Replace just the binary without reinstalling the entire module:

```sh
cp new-openlist-binary /data/adb/modules/openlist-runsv/system/bin/openlist
chmod +x /data/adb/modules/openlist-runsv/system/bin/openlist
reboot
```

## Uninstall

Uninstall the module from Magisk/KernelSU manager. This will:

1. Remove `/data/adb/runsvdir/service/openlist` symlink
2. Remove `/data/adb/sv/openlist` directory

Your data under `/storage/emulated/0/Android/openlist` is preserved.

## Updating the Binary (Developers)

Use `fetch.sh` to download the latest OpenList release and bundle it into the module:

```sh
./fetch.sh       # downloads latest OpenList for all architectures into bin/
./package.sh     # creates out/openlist-runsv-<version>.zip
```

The zip can be flashed directly from Magisk/KernelSU.
