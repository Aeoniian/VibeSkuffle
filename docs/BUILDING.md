# Building from source

You need Windows 10/11 64-bit and about 15 GB free.

| Step | What it does | Log |
|---|---|---|
| `0-check-tools.bat` | Lists the build tools you have | `logs\0-check-tools.log` |
| `1-install-tools.bat` | Installs what's missing with winget: Git, Visual Studio C++ Build Tools, Rust (1.99.0), Java 17, .NET 10 SDK | `logs\1-install-tools.log` |
| `2-build-ruffle.bat` | Downloads Mugetsu v1.5.1 (and Ruffle at its commit), applies `patches\skua.patch`, builds `out\ruffle\Mugetsu.exe` (~6 min; `2-build-ruffle.bat NOPGO` builds without Mugetsu's speed profile) | `logs\2-build-ruffle.log` |
| `3-build-skua.bat` | Downloads VibeSkua v2.0.6 (`14b0fdb`), applies `patches\vibeskua-ruffle.patch`, builds and copies the player in → `VibeSkua\Build\` (~1 min) | `logs\3-build-skua.log` |
| `5-run-manager.bat` / `4-run-skua.bat` | Starts the Manager / one client | |

`3-build-skua.bat` closes only this folder's VibeSkuffle, Manager and game windows before building.
A normal VibeSkua that's running is left alone. Your `ruffle-options.txt` is kept.

## Helper scripts

| Script | What |
|---|---|
| `procs.bat` | Lists VibeSkuffle / Mugetsu / Manager processes → `logs\procs.log` |
| `save-crash-logs.bat` | Copies game-window crash reports, recent logs and Windows crash events → `logs\` |
| `dump-crash.bat` | Windows crash events only → `logs\crash.log` |
| `measure-memory.bat` | Memory of every game window and client → `logs\memory.csv` |
| `measure-vram.bat` | GPU memory of every game window → `logs\vram.txt` |
| `overnight-monitor.bat` | `measure-memory` every 10 minutes until you close it |

## Patches

- `patches\skua.patch`: Ruffle side, on Mugetsu v1.5.1. `desktop/src/skua.rs` (named-pipe ExternalInterface
  bridge, docked window, headless, trim, per-window logs), web request timeouts, JSON fixes, crash handling.
- `patches\vibeskua-ruffle.patch`: VibeSkua side, on v2.0.6 (`14b0fdb`). Ruffle backend (`RuffleFlashUtil`,
  `RuffleControl`), the rename to VibeSkuffle, login watchdog, crash/freeze/memory recovery, tab window
  recovery, army and ButlerV5 changes.
