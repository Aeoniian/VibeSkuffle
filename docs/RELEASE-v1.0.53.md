# v1.0.53 - empty-room fix that actually triggers

## Fixed
- **The empty-room rule from v1.0.52 did not fire.** It only looked at whether the character was loaded, and in the reported glitch (a character standing in the right room with no monsters, no avatar drawn and other players invisible) the character counted as loaded. Now a room also counts as empty when the map has no monsters at all. With a script running and the room empty for 90 seconds, the Watch Dog jumps to the current cell (what Jump > Current does by hand); a second time if needed; the third time it joins the room again, but only if the character is not loaded. After three tries it only says so in `login-watchdog.log`. It also logs when it first suspects an empty room, so a rule that does not fire can be told from a room that was fine.
- `SKUA_EMPTY_ROOM_SECONDS` sets the time (default 90, 0 = off). A script that works in a map with no monsters at all (a town or a story map) may be jumped to its own cell up to three times; that does no harm.
- Reported with a video by Ramon Douglas (Twigs Arcade Story script).

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved. The standalone Watch Dog plugin has its own release (v1.0.5) with the same change.

## Limits
Not checked live with a real glitch. It assumes the game's monster list is empty during the glitch, as described. The packaged Manager starts.
