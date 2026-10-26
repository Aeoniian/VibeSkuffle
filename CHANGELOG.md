# Changelog

## v1.0.0-beta9 (2026-10-25)

**VibeSkuffle v1.0.0-beta9** brings VibeSkua 2.0.9, better control of drops, a more useful grid view, persistent Butler assignments, and a VibeSkuffle-specific client updater.

### VibeSkua 2.0.9 + Cosmetics

- Updated from VibeSkua 2.0.7 to **2.0.9**, including upstream main fixes through `d71afc9`.
- Bundled the new **Cosmetics** plugin by NinjaXz and Lord Exelot: preview cosmetic appearances and manage saved outfit loadouts. These are visual changes; they do not give you ownership of an item.
- Included upstream fixes for quest registration and processing, scheduler cancellation and playlist saving, script start/stop controls, script downloads, the property-grid collection viewer, and runtime helpers.
- Included upstream improvements to tray hiding/restoration, tab startup queues, grid positioning, and graceful client shutdown to reduce ghost tray icons.

### Automatic AC banking and better drop controls

- **Options → Game → Drops & Looting → Pickup AC Drops and Send to Bank** is a saved toggle that works even when no script is running.
- The existing **Current Drops → Pickup AC Only and Send to Bank** button stays right where it was.
- AC acceptance and banking wait until the player is out of combat. The banking transaction suppresses new attacks/skills, rechecks combat, waits for inventory acknowledgement, and uses bounded retries instead of repeatedly hammering the same drop.
- Pending transfers stay tied to the current login session so a logout or account change cannot carry old work into the next session.
- Added **Reject Non-AC Drops** as a saved automatic option.
- Added **Reject All** and **Reject All Except AC** to Current Drops. Rejection can happen during combat.
- Current Drops refreshes as automatic actions remove items and shows the banking status.

### Tabs and grid view

- **Drag account tabs to reorder them.** Grid view follows the same order, and the order is saved for later launches.
- The dragged tab fades while moving, with an accent marker showing whether it will land before or after another tab.
- Reordering in grid view keeps grid view active.
- Replaced the garbled characters beside usernames with a proper close icon and tooltip.

### Per-account right-click controls

Right-click the game to control that account without leaving grid view:

- **Start / Stop Script**.
- **Headless** and **Lag Killer** toggles.
- **Restart Client**, keeping its login and script.
- A script information row above Start/Stop: **Running: filename**, **Selected: filename**, or **No script selected**. Long names show their full text on hover.

The headless overlay has account controls and the script-name display too.

### ButlerV5: keep the assignment through interruptions

- Followers retain their master assignment when the master temporarily disappears, instead of abandoning it after a short offline window.
- Saved follower assignments restore after a client restart or login. Explicit stops, releases and declined orders remain respected.
- Master rosters no longer expire simply because more than 30 minutes have passed.
- Account changes clear the previous account's assignment state; disabling/re-enabling Butler preserves the saved assignment.
- VibeSkuffle loads its own bundled ButlerV5 directly, rather than overwriting the shared plugin copy used by another client. Script compilation references that same bundled version.
- Added guards around VibeSkuffle-specific login/server features for stock hosts. Full mixed-client following still needs more testing; this is not a claim that every Skua/VibeSkua combination is verified.

### Manager and updates

- **Manager → Updater now checks VibeSkuffle's GitHub releases** for client updates, including beta versions. It no longer points the client updater at upstream VibeSkua.
- Updates verify the application file hashes, stage the replacement, and keep rollback copies if installation fails.
- Script updates keep their existing source. Client updates leave scripts, saved accounts/settings, graphics preferences, alerts and custom plugins alone.
- **Launcher discovers active VibeSkuffle processes**, including ones started outside that Manager, and removes stopped processes from the list.
- Closing the Launcher model does not terminate discovered accounts. Explicit Stop/Kill All uses the improved shutdown handling.
- Reworked **Info** into readable sections with current build details, project links and credits.

### Shared script folder

- Scripts now default to **`%APPDATA%\Skua\Scripts`**.
- Old absolute paths under `%APPDATA%\VibeSkua\Scripts` resolve to the Skua folder when the matching file exists. Custom script paths still work.
- Settings and accounts remain under `%APPDATA%\VibeSkua`.

### Install / update

**Coming from Beta8 or earlier: install this one manually.** Close VibeSkuffle, extract the ZIP into a new folder, and run `VibeSkuffle.Manager.exe`. Accounts/settings stay in AppData. Copy your old `ruffle-options.txt` and `alerts.txt` into the new folder if you want to keep those folder-specific preferences. After this release, the new Manager updater can install compatible future release packages.

Requires the **[.NET 10 Desktop Runtime (x64)](https://dotnet.microsoft.com/download/dotnet/10.0)**. Mugetsu 1.5.1 is bundled.

### Checked for this release

Client, Manager, ButlerV5, Cosmetics and Mugetsu builds pass. **55 automated checks** cover the application package, update rollback/preservation, combat guards, drop handling, saved options, follower persistence, and script-label states. A saved-account test confirmed login on 2.0.9, both bundled plugins, the running-script label and the game bridge in a private room. The actual Info view was rendered and checked.

Still needs longer/manual validation: a real AC item transfer, overnight following, mixed stock-client following, and the new drag/menu interactions. The earlier live bank-loaded flag did not confirm, so a successful live AC transfer is not claimed here.

**Full changes:** [CHANGELOG.md](https://github.com/Aeoniian/VibeSkuffle/blob/main/CHANGELOG.md). **Source and build instructions:** [VibeSkuffle](https://github.com/Aeoniian/VibeSkuffle).


## v1.0.0-beta8 (2026-10-23)

- Now based on **VibeSkua v2.0.7** (`8774d1c`): Army Queue (squads run one after another, each account with its
  own script and options), VibeSkua's own auto-relogin watchdog (reacts the moment the connection drops, tells
  your own Log Out / Change Server apart from a drop, treats a server-forced logout as a drop), webhook health
  pings, confirmations before removing accounts.
- Our watchdog and VibeSkua's relogin work together: with Auto Relogin on, VibeSkua logs back in and the
  watchdog starts the script again once; ours only steps in when that gets stuck, and claims a relog before
  stopping the script so the two never log in at once. After you click Log Out or Change Server in game,
  neither logs the account back in.
- Army Queue clients (which close when their script stops) no longer close when a recovery stops the script
  for a relog, game window restart or Rescue Allies; they wait for the recovery to settle and close once the
  script has really finished. Tested: a drop mid-run, VibeSkua relogged, the script ran again and finished, the
  client closed and the queue completed.
- Tested on 2.0.7: drop with Auto Relogin off (watchdog relogs at 3 minutes, script restarted without the
  options window), drop with Auto Relogin on (VibeSkua relogs in 10 s, one script restart, no second login),
  logging out on purpose (stays logged out), whole-client restart.
- ButlerV5: an account whose client Windows won't let ButlerV5 inspect (for example one running as
  administrator) is no longer counted as offline and hidden from the roster.
- ButlerV5: when the roster is empty it now lists the other accounts it found and why each isn't shown (logged
  out, client closed, process ID now belongs to another program, file left from an earlier session).
- ButlerV5: each account rewrites its status file at least once a minute, so a client that's been running a
  while without changes is never mistaken for a leftover from an earlier session.
- Fix: **Current Drops → Pickup AC Only and Send to Bank** picked the AC drops up but banked none of them.
  A picked-up item leaves the drop list a moment before it shows in the inventory, and the button checked too
  early; it now waits for the items (up to 10 seconds) before sending them to the bank.

## v1.0.0-beta7 (2026-10-21)

- **Graphics tab** in the menu bar (between Diagnostics and Plugins) with Mugetsu's settings: Edge smoothing
  (Flash-style / MSAA), Frame interpolation, Show FPS, Open Mugetsu's log folder. A change applies to every
  account at once and is kept for game windows started later. It also shows the account's graphics API.
- **Right-click the game** to switch that account between **Vulkan**, **DirectX 12** and **OpenGL**. It's
  saved for that account in `ruffle-options.txt` and the game window restarts, logging back in and starting its
  script again. If the new API doesn't start within 90 seconds it goes back by itself (with a Discord alert).
  Mugetsu itself only offers OpenGL on Linux; VibeSkuffle offers it on Windows too (tested on an NVIDIA card).
- An account's own option line in `ruffle-options.txt` now replaces the same option from the line for
  everyone (before, both were passed and the game window could refuse to start).
- The daily summary counts graphics switches and switches that were undone.

## v1.0.0-beta6 (2026-10-21)

- **Mugetsu 1.5.1** (was 1.4.0), the Windows build. What's new in Mugetsu:
  [1.5.0](https://github.com/mugetsu-aqw/mugetsu/releases/tag/v1.5.0) ·
  [1.5.1](https://github.com/mugetsu-aqw/mugetsu/releases/tag/v1.5.1)
  - **Flash-style edge smoothing** (new default): smooth edges the way Flash Player drew them instead of
    MSAA; about the same look on Medium/High and much faster on laptops and built-in graphics (right-click the
    game → Edge smoothing → MSAA for the old way). 1.5.1 fixes small holes in some shapes and too-thick outlines
    on squashed shapes.
  - **Right-click menu on the game** with Mugetsu's settings: Frame interpolation, Edge smoothing, Show FPS,
    Open log folder. In VibeSkuffle it leaves out Graphics (VibeSkuffle sets that in `ruffle-options.txt`, and
    Mugetsu restarting itself would lose the game) and Full screen (the game is inside the tab window).
  - Frame interpolation costs much less; animated effects at many sizes (torches, spells) stop rebuilding
    their shapes every frame.
  - (1.5.1's Linux version isn't used: VibeSkuffle is Windows-only.)

## v1.0.0-beta5.0.1 (2026-10-21)

- Hotfix: the game plays at **24 FPS** by default (Options → Game → Set FPS), AQW's own frame rate. It was 30,
  which plays the animations faster than intended. The Set FPS option is applied when the game loads, and turning
  headless mode off goes back to it instead of 30. If you saved your options before, your saved value stays.

## v1.0.0-beta5 (2026-10-21)

- Now based on **VibeSkua v2.0.6** (`14b0fdb`): script pinning, scheduler queue reordering, Skua Nexus webhook,
  account name in the script options title, Select All in the Manager, faster script search and options window.
- VibeSkua 2.0.6 asks for a script's options before starting it. Watchdog restarts (after a relog, a game-window
  restart or a whole-client restart) use the saved options instead, so an unattended account never waits on that
  window. Tested with a script that has options: relog → restarted, whole-client restart → running again in 8 s.
- **Discord alerts** (`alerts.txt`): a message when the watchdog needs a person, and a **daily summary** of what
  it fixed per account (also: right-click a tab → Watchdog Summary). Off unless you add a webhook.
- Builds write `build-info.txt` (VibeSkua version and patch hash) and keep `alerts.txt`; release zips leave out
  `alerts.txt` and account-specific lines in `ruffle-options.txt`.

## v1.0.0-beta4 (2026-10-20)

- **Rescue Allies sees questline-locked bosses:** helpers borrow the stuck account's quest progress while helping
  (client-side only, like ButlerV5's quest clone) and put their own back exactly as it was before their scripts
  start again, so their scripts never see quests as done that aren't.
- A restarted script that finishes by itself while the game is fine isn't started again and again.
- Tested: the full "out of sync" escalation (relog → game window restart → whole-client restart with its script).
- README: credits for the VibeSkua, ButlerV5 and Skua authors and contributors.
- New companion: [Watch Dog](https://github.com/Aeoniian/Watch-Dog), the in-game part of this watchdog as a plugin
  for normal Skua and VibeSkua (not needed here, it's built in).

## v1.0.0-beta3 (2026-10-20)

Now based on **VibeSkua v2.0.5** (`2fc9bb5`): the Manager's account context menu, tab → Add to Group, live
settings sync, faster first login (socket policy preloading), webhook dashboard snapshots. No conflicts with
VibeSkuffle's changes. From three nights / two days of 6-account runs:

- **Scripts restart reliably after a relog.** The watchdog now waits until the account has been in game for a few
  seconds, starts the script, checks 15 s later that it is really running, and tries up to 3 times. A script that
  stopped a moment *before* the game was seen as gone (the usual case after a game-window restart) is now counted
  as running; a script that was stopped or finished while the game carried on is not.
- **"Communication with server has been lost"** left on screen (auto relogin off or given up): logs back in after
  1 minute. The log no longer fills with "Connection lost detected" ten times a second.
- **Out of sync with the server:** a second stuck-script / quest-error relog within 45 minutes restarts the game
  window; a third restarts the whole client (the tab window starts it again with its login and script), at most
  once per 2 hours per account. New tab menu item **Restart Client (keeps login and script)**.
- **Rescue Allies** (Game Option, off by default): accounts help an account on the same server that keeps dying,
  then go back and restart their scripts.
- **Ignore Script Reject Else** (Game Option): scripts can't throw away drops they didn't ask for.
- **Current Drops → Pickup AC Only and Send to Bank.**
- **ButlerV5 Summon all** (and the per-row Summon/Follow buttons) work for accounts on another server: they log in
  on the master's server right away and follow.
- Building / close-all: tab windows are marked as closing on purpose and closed first, so no client starts itself
  again mid-build. An existing VibeSkua download is moved to the new base version automatically.
- README: requirements split into 1 account and Armying (6 accounts), with the multi-day VRAM/RAM numbers.

## v1.0.0-beta2 (2026-10-18)

From the first overnight run (6 accounts running FarmerJoeDoAll):

- **ButlerV5 followers re-follow** after the master restarts: automatic re-logins return to the same server and
  room; a follower whose master is on another server logs in there after 30 s (max once per 5 min); a master's
  followers list survives a client restart (30 min).
- **"Quest Complete Failed: Missing Quest Progress"** spam (5 in 2 min) while a script runs → relog, script restarts.
- **Stuck script check:** a running script with no kills, drops, quests, gold or movement for
  `SKUA_STUCK_SCRIPT_MINUTES` (default 15, 0 = off) → relog, script restarts (max once per 20 min).
- A re-login sitting on a blank screen for 5 minutes is started over (one account sat logged out for 75 minutes).
- Scripts now restart after every kind of knock-out (a timing mix-up skipped some).
- The "logged out for 3 minutes" check could fire right away after a restart (a leftover timer).
- PC low on RAM (under 10% free): the biggest game window restarts when out of combat.
- Memory restarts at most once per 30 minutes (a too-low limit can't loop); the limit is re-read at each start;
  `name: ...` lines in `ruffle-options.txt` apply to one account; `SKUA_*` settings there also reach VibeSkuffle.
- **Settings file fix:** saves only write the changed settings onto the current file (the Manager's accounts could
  be wiped by another program's stale copy), an abandoned lock no longer leads to blank settings, a `.bak` is kept.
- Building: closes clients before the tab window (so they don't restart themselves mid-build) and keeps
  `login-watchdog.log` / `host-recovery.log`.

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
