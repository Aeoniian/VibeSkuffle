# v1.0.52 - empty-room fix and Skip Cutscenes

## Fixed
- **A room that never loads (Watch Dog):** with almost any script, a character can end up in the right room with nothing in it: no monsters, no NPCs, no avatar. A script then farms nothing, or keeps killing the same monster with no quest progress, for hours. By hand, Jump > Current fixes it. Now the Watch Dog does it: when a script is running and the character stays "not loaded" in its room for 90 seconds, it jumps to the current cell, and if that does not help it joins the room again (three tries, then it only says so in `login-watchdog.log`). The rejoin is only used when the map has no monsters at all. `SKUA_EMPTY_ROOM_SECONDS` sets the time (0 = off). Reported by Ramon Douglas. The rare case of a character killing the wrong monster in a loaded room is not covered.
- **Skip Cutscenes hid the world:** a cutscene hides the world while it plays, and Skip Cutscenes removed it early and left the world hidden, which looked like Lag Killer turning itself on in any map with a cutscene. The world is now shown again after each skip unless Lag Killer is really on.

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved. The standalone Watch Dog plugin has its own release (v1.0.4) with the same empty-room fix.

## Limits
Not checked live with real accounts. The empty-room rule was written from a report and a screenshot; the Skip Cutscenes fix from the way the game hides the world. The packaged Manager starts.
