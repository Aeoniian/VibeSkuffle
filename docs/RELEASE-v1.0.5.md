# v1.0.5 - 4000 MB memory restart, Accept AC Drops, Watch Dog rescue changes and Game-Only Full Screen

## Fixes
- **Constant re-logins:** v1.0.4 restarted a game window above 1650 MB, but a busy window normally uses 1.5-2.3 GB, so windows restarted about every 30 minutes and the account logged back in each time. The default is now **4000 MB**. `SKUA_MEMORY_LIMIT_MB` in `ruffle-options.txt` still overrides it, per account too. The release ZIP has no settings or account files; the Relogin Server defaulting to the built-in server was this restart losing the in-memory choice.
- **Accept AC Drops** uses the same rule as Pickup AC Drops And Send To Bank. A drop the server would refuse (a full stack, or an item that can only be owned once and is already in the inventory or the bank) is rejected instead of being asked for again and again, so the red "You already have a full stack of that item" messages are gone. A drop refused for lack of space waits until a slot frees. The bank is read at most once a minute.
- Banking no longer stops after three successful pickups of the same item.

## Watch Dog (Rescue Allies)
Changes from **Noxus2k-AQW**, who suggested them in the GitHub discussion "Watch-Dogs Adjustments" (Watch Dog 1.0.24 and 1.0.25). Thank you!
- **Accounts tab:** every Watch Dog account on this PC with where it is and what it does, a **Can help** switch and a **Request help** button.
- **Boss class and gear:** helpers use the class, skill mode and gear of their CoreBots Boss selection and put their own setup back afterwards. They leave combat first.
- **Helper cooldown** (default on, 10 minutes, 1-30) and **helper death limit** (default 5, 1-100): a helper that dies that often without a kill stops attacking, leaves combat and restores its setup.
- A rescue request stays active while the caller is dead and respawns in the same map. Helpers stay in the map until the caller leaves it; the old 20-minute give-up is gone.
- Added on top: a **hold limit** (default 30 minutes, 0 = no limit) that releases the helpers after that long without a kill or death of the caller, and a switch to turn the helpers' Boss class and gear off (default on).

## New
- **Game-Only Full Screen** (Shift+F11, rebindable as "Game-Only Full Screen" in Hot Keys): full screen with only the game; the title bar, tab bar, notices and every client's menu are hidden. Shift+F11 again, or F11, leaves it. F11 borderless full screen is unchanged.

## Release package
- The ZIP has only `VibeSkuffle.exe` and `VibeSkuffle.Manager.exe` at the top; everything else is in a folder called `source`. The two exes are the normal ones pointed at the program in `source`, so everything runs as before and the updater keeps working. Older versions still find the update manifest.

## Versioning
- Still based on upstream VibeSkua 2.1.2 (`d622a57`); `patches/vibeskua-ruffle.patch` is regenerated against it.

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved. The standalone Watch Dog plugin has its own release (v1.0.3) with the same rescue changes.

## Limits
These changes compile and the packaged build starts, but the Watch Dog rescue changes, Accept AC Drops and Game-Only Full Screen were not checked live with real accounts. No automated test suite covers the VibeSkuffle side.
