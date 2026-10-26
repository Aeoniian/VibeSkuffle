**VibeSkuffle v1.0.0-beta9.5 — shared Rescue Allies, individual opt-outs, and idle saviors.**

### One switch for the whole army

- **Rescue Allies - all accounts** is now a live shared switch. Toggle it in one account and every open, updated VibeSkuffle/Watch Dog client on the same PC picks it up.
- **Allow this account to rescue** is a separate saved checkbox. Exclude accounts you do not want acting as saviors without disabling rescue for everyone else.
- Excluded accounts can still **receive** help. Changing the shared switch never overwrites individual exclusions.
- Defaults: shared rescue **off**, individual eligibility **on** for logged-in accounts.

### Idle accounts can save you

- Rescuers no longer need a running or loaded script. An eligible idle account can join, fight, return, and remain idle afterward.
- A running script is paused and the same run resumes afterward; an already paused script stays paused.
- Manual Stop, logout, a new script, account/server changes, and manual combat stops take precedence over rescue restoration.
- Manual Auto Attack/Hunt is left alone. Helpers still need to be logged in on the same PC and server.
- Rescue uses the equipped class's available skill slots without replacing saved skill rotations.

### Reliable return and shared settings

- Helpers return to their original room/cell and restore combat preferences.
- Fixed transfers between different private rooms of the same map, with bounded retries when AQW rejects a transfer during its cooldown.
- Turning rescue off globally or excluding an active helper ends its rescue and returns it when possible. Other eligible helpers keep working when only one account is excluded.
- Shared settings use atomic writes, cross-process coordination, live notifications and a polling fallback. Old game-option snapshots cannot reset the shared switch or account exclusions.
- Old rescue calls are cleaned up when accounts change. Added end-of-rescue diagnostics.
- Fixed packaging so an older Manager dependency cannot overwrite a newer client library.

### Where to find it

**VibeSkuffle:** Options → Game → Gameplay & Character.

**Standalone Watch Dog:** Plugins → Rescue Allies, using **[Watch Dog v1.0.0-beta5](https://github.com/Aeoniian/Watch-Dog/releases/tag/beta5)**. VibeSkuffle already has the watchdog built in and does not need the plugin.

Update and restart all participating clients once so they load the new shared controls. Preferences are saved in `%APPDATA%\Skua\WatchDog\rescue-settings.json`; no account passwords are stored there.

### Update straight from the Manager

**Already on Beta9? Open Manager → Updater to download and install Beta9.5.** No manual GitHub download is needed. Account settings, scripts, graphics preferences, alerts and custom plugins are preserved; script updates remain independent.

Coming from Beta8 or earlier: close VibeSkuffle, extract the ZIP into a new folder, and run `VibeSkuffle.Manager.exe`. Copy your old `ruffle-options.txt` and `alerts.txt` if you want those folder-specific preferences.

### Validation

**43 targeted rescue checks and 31 existing regression checks passed.** Client, Manager and plugin builds pass. A live saved-account check confirmed an idle helper joined a private room, killed a real monster, returned to its exact original private room, and stayed idle.

Full stock-client gameplay co-loading, native WPF rescue-window interaction and overnight running still need manual validation. This remains a beta release. The package contains no saved accounts, personal settings or runtime logs.

Still based on VibeSkua 2.0.9 and Mugetsu 1.5.1. All Beta9 features remain included. [Full changelog](https://github.com/Aeoniian/VibeSkuffle/blob/main/CHANGELOG.md).
