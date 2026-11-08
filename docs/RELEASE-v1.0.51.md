# v1.0.51 - memory restart switch and 8192 MB default

## New
- **Memory tab in the Watch Dog window:** a switch for "Restart the game window when it uses too much memory or the PC is low on RAM". Off, the game window is never restarted for memory, however much it uses, so a PC with little RAM (for example 4 GB) can run at 100% memory use without the account being restarted and logged back in over and over. It may slow down or freeze when memory runs out; that is the trade. A window that stops answering is still restarted either way.
- The switch is the line `SKUA_MEMORY_LIMIT_MB=off` in `ruffle-options.txt` (`0`, `none`, `unlimited`, `never` and `disabled` mean the same), for every account. For one account only, write `myalt: SKUA_MEMORY_LIMIT_MB=off`; an account's own line wins. It takes effect within about 30 seconds, no restart needed.

## Changed
- The default memory limit is **8192 MB** (4000 MB in v1.0.5, 1650 MB in v1.0.4). `SKUA_MEMORY_LIMIT_MB=<number>` still sets a limit.

Nothing else changed since [v1.0.5](RELEASE-v1.0.5.md).

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved.

## Limits
Not checked live with real accounts; the packaged Manager starts. The Rust rewrite has the same switch in its Watch Dog window.
