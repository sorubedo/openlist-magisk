# openlist-runsv

[English](README.md) | [中文](README_zh-CN.md)

将 [OpenList](https://github.com/OpenListTeam/OpenList) 作为 runsv 服务运行，适用于 Magisk/KernelSU。

本项目是 [OpenList](https://github.com/OpenListTeam/OpenList) 的 Magisk/KernelSU 模块封装，将上游二进制打包为 runsv 服务，使其在 Android 设备上持久化后台运行。

| | |
|---|---|
| **上游项目** | [OpenListTeam/OpenList](https://github.com/OpenListTeam/OpenList) |
| **上游协议** | [AGPL-3.0](https://github.com/OpenListTeam/OpenList/blob/main/LICENSE) |

## 依赖

- [runsvdir-magisk](https://github.com/sorubedo/runsvdir-magisk)

## 下载

Release 附件并**未**与上游 OpenList 版本保持同步。
请通过 GitHub Actions 获取最新构建：

1. 进入 [构建工作流](https://github.com/sorubedo/openlist-magisk/actions/workflows/build.yml)
2. 点击 **Run workflow** → **Run workflow**
3. 等待运行完成后，从 **Artifacts** 下载 zip 文件

## 安装

1. 先安装 `runsvdir-magisk`，再在 Magisk/KernelSU 中刷入本模块。
2. **重启**设备。
3. 通过 runsvdir WebUI 链接 `openlist`，或在 root shell 中执行 `ln -s /data/adb/sv/openlist /data/adb/runsvdir/service/`。

## 配置

创建 `/data/adb/sv/openlist/conf` 来自定义服务。所有变量均为可选。

| 变量 | 默认值 | 说明 |
|---|---|---|
| `CHPST_USER` | `shell:inet:sdcard_r:sdcard_rw` | `chpst` 的用户和组（进程权限） |
| `OPENLIST_ARGS` | `--data /storage/emulated/0/Android/openlist` | 传递给 `openlist server` 的参数 |
| `WAIT_DECRYPT` | `1` | 启动前等待存储解密（设为 `0` 跳过） |

示例：

```sh
CHPST_USER=shell:inet:sdcard_r:sdcard_rw
OPENLIST_ARGS="--data /storage/emulated/0/Android/openlist"
WAIT_DECRYPT=1
```

## 操作按钮

在 Magisk/KernelSU 中点击操作按钮，通过音量键执行：

- **音量+** — 显示管理员信息（登录凭据）
- **音量-** — 随机重置管理员密码

## 命令行

也可以通过 root shell 控制服务，无需 runsvdir WebUI：

```sh
# 启用 / 禁用
sv-enable openlist
sv-disable openlist

# 启动 / 停止 / 状态
sv up openlist
sv down openlist
sv status openlist

# 查看 svlogd 日志
tail -f /data/adb/runsvdir/log/sv/openlist/current
```

## 手动更新二进制

无需重新安装整个模块，直接替换二进制文件：

```sh
cp new-openlist-binary /data/adb/modules/openlist-runsv/system/bin/openlist
chmod +x /data/adb/modules/openlist-runsv/system/bin/openlist
reboot
```

## 卸载

通过 Magisk/KernelSU 管理器卸载本模块。这将：

1. 移除 `/data/adb/runsvdir/service/openlist` 软链接
2. 删除 `/data/adb/sv/openlist` 目录

`/storage/emulated/0/Android/openlist` 下的数据不会被删除。

## 更新二进制（开发者）

使用 `fetch.sh` 下载最新 OpenList 发布版本并打包到模块中：

```sh
./fetch.sh       # 下载各架构的最新 OpenList 到 bin/
./package.sh     # 生成 out/openlist-runsv-<version>.zip
```

生成的 zip 可直接在 Magisk/KernelSU 中刷入。
