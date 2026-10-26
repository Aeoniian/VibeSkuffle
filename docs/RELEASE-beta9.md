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
