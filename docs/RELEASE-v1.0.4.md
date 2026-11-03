# v1.0.4 - VibeSkua 2.1.2, Calendar, Game Size and 1650 MB memory restart

## New
- **Calendar** (Tools & Helpers): daily and weekly reset countdowns (server time, US Eastern) and the AQW boosts that are on now or coming up. Its icons keep fixed colours; only the headings follow the Application Theme accent.
- **Game Size button** next to Grid View: play the game at Auto or a fixed size from 640x367 up to 1920x1080, centred in the window and shrunk to fit a smaller one. It sizes the game window; it does not change Ruffle's render quality.
- **Grid View layout button** (Auto, Stacked, Side by side). It appears while Grid View is on, so two accounts can be stacked top to bottom.
- **Follow groups:** accounts that follow another account sit next to their master in the tab strip, in one colour, and the followed account wears a crown.
- **Account drop-down** in the Script Loader and the CoreBots options, to work on any open account.

## Improved
- **Memory restart at 1650 MB** (was 6000 MB). The game window restarts when it uses more than that, out of combat or after 10 minutes over the limit, at most once per 30 minutes. `SKUA_MEMORY_LIMIT_MB` in `ruffle-options.txt` still overrides it, per account too. A busy window often uses 1.5-2.3 GB, so raise it if restarts are too frequent.
- **Pickup AC Drops And Send To Bank** is faster and rejects AC drops the bank already holds.
- **Watch Dog** relogs an account that keeps getting "One Time Quest Only" (8 answers within a minute) and restarts the client if it comes back within 15 minutes.
- Army Control's "Loaded script" line counts accounts with no script as "none" ("2 accounts same, 4 none") instead of "Mixed".
- The Updater page scrolls and keeps Check for Updates and Update & Restart near the top.
- Server ping only counts a sample once the server sends its full reply.

## From upstream VibeSkua 2.1.2
Army Control and Army Queue
- Squads in Army Queue can be reordered by drag and drop; account search and the role/script wording are clearer.
- Redesigned Map Travel: recent destinations, saved presets (map, cell and pad), editable presets, history clearing, the room a client is really in, and private rooms respected.
- A "Change Server for All" menu item, and a player picker that accepts custom usernames.

Relogin
- New **Relogin Fallback** option: relogging only goes to the chosen server unless it is on.
- New **Relogin Watchdog** setting in Application Options > General.

Scripts
- Missing and outdated scripts download at startup, with failures reported; downloads are validated.
- Redesigned Search Scripts and a Scheduler playlist table.
- Fixed a UI freeze caused by script checks running on the UI thread.

Other
- Junk Items has AC and category filters and shows inventory and bank quantities.
- Game Options categories appear in two columns.
- Saved Advanced Skills can be filtered by class.
- Copy All no longer crashes when the clipboard is busy; log rows have a Deselect action.

## Fixes
- Refused drops stay in Current Drops until the server accepts them, and no longer stall pickups.
- Fixed the `killLoginModals` script error (ReferenceError #1069).
- The hidden loading bar no longer animates after the game loads.
- The tab strip no longer clips the first tab's corners; leaving Grid View opens the clicked tab; maximized windows no longer show resize edges; title bar buttons no longer flash.

## Versioning
- Based on upstream VibeSkua 2.1.2 (`d622a57`); the patch in `patches/vibeskua-ruffle.patch` is regenerated against it.

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved. Script updates remain independent through Skua. The standalone Watch Dog plugin has its own release (v1.0.2) with the "One Time Quest Only" rule; it can only relog, not restart the client.

## Limits
The merge with upstream 2.1.2 and the new features compile and the packaged build starts, but they were not checked live with real accounts. No automated test suite covers them, and overnight operation and large multi-account armies were not part of this check.
