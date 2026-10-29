# v1.0.2 - Quality of life, VibeSkua 2.1.1 and Mugetsu 1.6.0

## Quality of life
- **Watch Dog status:** shows live requester and helper status, death and timer progress, and per-requester cooldowns. The built-in and standalone native UI use the same format.
- **Watch Dog restarts scripts after a re-login:** if VibeSkua's own re-login succeeds but the script is not running afterwards, Watch Dog restarts it. A short grace period keeps it from doubling VibeSkua's own restart, it never restarts after a manual stop, it reuses the existing restart limits, and it logs which path restarted the script.
- **Minimize fix:** minimizing no longer leaves a "pillar" of the clients on the desktop; the child windows are hidden on minimize.
- **Drops options regrouped:** *Reject Non AC Drops* and *Pickup AC Drops And Send To Bank* now sit under **Drops & Looting** instead of Gameplay. Saved settings are unchanged.
- **ButlerV5 "Release everyone":** a new roster button releases every butler of every account (two clicks within 5 seconds to confirm), beside the existing per-account "Release all".
- **Script identity:** right-click the loaded-script card in Script Loader to open its folder, or to copy a sanitized path and the SHA256 of the top-level script.
- **Army Misc Options tooltips** show per-account On/Off/missing-report counts and pending confirmations, in current tab order. Numbered aliases protect account names.
- **Support report:** Manager -> Updater -> Preview Support Report lets you review, copy or save an allowlisted summary. Nothing is uploaded. It excludes raw logs, saved accounts, credentials and script contents or options.
- **Update channels:** client updates default to stable releases. *Include preview releases* is an explicit saved choice, and switching channels never downgrades.
- **Launch spacing:** selected, all and group launches have saved 0-60 second spacing and a **Cancel Remaining Launches** button. Clients already started keep running. Army Queue keeps its own delay.

## Upstream and renderer
- Updated to **VibeSkua 2.1.1** (upstream `a3c8cac`).
- Updated to **Mugetsu 1.6.0**, with the VibeSkuffle bridge.

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved. Script updates remain independent through Skua.

## Limits
Standalone native WPF, the older-host fallback live refresh, overnight operation and real multi-account launch and rescue were not covered by automated checks for this release. The standalone Watch Dog plugin is delivered separately and is not bundled. Login recovery, timeouts and renderer scheduling were not changed for the quality-of-life work.
