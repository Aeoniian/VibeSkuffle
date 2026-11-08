# v1.0.6 - hotfix: 8192 MB memory restart

## Fix
- The game window restarts for memory above **8192 MB**. v1.0.5 used 4000 MB and v1.0.4 used 1650 MB; a busy window can use more than that, and each restart logs the account back in, which looked like sudden re-logins. `SKUA_MEMORY_LIMIT_MB` in `ruffle-options.txt` still overrides it, per account too. A window is also still restarted when the whole PC is low on free memory and it is the biggest game window.

Nothing else changed since [v1.0.5](RELEASE-v1.0.5.md).

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved.

## Limits
Not checked live with real accounts; the packaged Manager starts.
