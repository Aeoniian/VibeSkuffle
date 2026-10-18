# Changelog

## v1.0.0-beta (2026-10-17)

First public build. Based on VibeSkua `239b20d` and Mugetsu v1.4.0 (Ruffle `fda41800`).

### Player
- VibeSkua talks to Mugetsu over two named pipes instead of hosting Flash (ExternalInterface bridge,
  docked child window, headless mode). About 0.2 ms per call.
- Two AS3 `JSON.stringify` fixes so game data matches Flash (whole numbers without ".0"; Event getters skipped).
- The game's web requests time out (15 s to connect, 30 s without data). Ruffle had no timeout, so a login
  request AQW never answered could hang forever.
- DirectX 12 by default (`--graphics dx12` in `ruffle-options.txt`).
- Each game window writes its own log (`%LOCALAPPDATA%\ruffle\log\skua-*.log`, 25 MB cap, 3 days). Crashes
  go to `skua-crash-*.log` (kept 14 days) instead of a dialog box.
- New "trim" command: frees unused shapes, spare GPU textures and allocator memory.

### Recovery (unattended runs)
- Login watchdog for stuck "Authenticating…" / "Connecting…" / "Loading Character Data…" screens:
  resets the login screen, then restarts the game window. Avoids the stuck server for 3 minutes, spreads
  logins over 0–5 s, and backs off to 1 minute after 6 tries and 10 minutes after 12. Never gives up.
- Logs back in after 3 minutes out of game with nothing happening. Logouts you asked for are respected.
- Game window crash: restarted (30 s pause if it keeps crashing), logged back in, script restarted.
- Game window freeze: 30-second heartbeat; 3 missed → restarted.
- Client crash: the tab window starts it again with the same login and script (max 5 per account per 30 min).
- Tab window crash: every client starts itself again; the first one opens a new tab window and the others join it
  (max 3 per account per 30 min; not when you close the window yourself).
- Memory limit (`SKUA_MEMORY_LIMIT_MB`, default 6000): restart when out of combat, at most once per 30 min.
  Can be set per account.
- Whatever knocked the account out, a script that was running starts again once it's back in game.
- `--run-script` waits up to 5 minutes for the login.
- Windows doesn't sleep while the tab window is open.
- Log caps: `login-watchdog.log` 1 MB, ButlerV5 debug logs 10 MB.

### Memory
- Background accounts are trimmed when they go to the background and every 10 minutes after
  (headless accounts too). 6 idle accounts: ~5.4 GB → ~2.5 GB with DirectX 12.
- Background tabs: 2 fps / low quality only while in game, full speed while logging in.

### Army / ButlerV5
- ButlerV5 "Log in all": logs in the other logged-out accounts on the clicker's server, skips accounts in
  game, retries, and shows progress.
- ButlerV5 finds VibeSkuffle accounts (it only looked for processes named "skua").
- Army Login All reaches background tabs; accounts already in game are left alone; a dead character
  is no longer treated as logged out.
- Army messages and hotkeys reach clients docked in the tab window and only this install's clients.
- "Jump all to map": the cursor starts in the box, the title is shown correctly, and an empty box is ignored.

### Fixes (also in VibeSkua)
- Packet Interceptor "Connect" now waits for the server list instead of reusing the old login token.
- The game loader's "load game" request is answered every time (it was answered once, so a restarted
  player stayed blank).
- The build no longer force-closes every running VibeSkua.
