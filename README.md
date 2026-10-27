# VibeSkuffle

**VibeSkua, running on Mugetsu (a faster Ruffle) instead of Flash, built to run a whole army for days without babysitting.**

VibeSkuffle is [VibeSkua](https://github.com/NinjaXz/VibeSkua) (v2.1.0) with the Flash player swapped out for
[Mugetsu](https://github.com/mugetsu-aqw/mugetsu), a performance-tuned build of the
[Ruffle](https://ruffle.rs) Flash emulator. Everything VibeSkua does still works: scripts, the Manager, the
army, plugins, hotkeys, the grabber and the packet tools. On top of that it gets back up by itself when something
goes wrong: stuck logins, crashes, freezes, memory build-up, and a crashed tab window.

> **Stable release: v1.0.1.** Download the [latest release](../../releases), or update directly through
> **Manager → Updater**. Report problems in [Issues](../../issues).

v1.0.1 fixes Flash/Ruffle item-name encoding that could make scripts miss owned pets such as
Crag &amp; Bamboozle. It also improves headless scheduling and GPU handling, with optional
resource tuning and diagnostics. See the [release notes](docs/RELEASE-v1.0.1.md) and
[renderer testing details](docs/RENDERER-PERFORMANCE.md).

---

## Download and run

1. Install the **[.NET 10 Desktop Runtime (x64)](https://dotnet.microsoft.com/download/dotnet/10.0)** if you
   don't have it ("Run desktop apps" → Windows x64).
2. Download `VibeSkuffle-<version>-win-x64.zip` from [Releases](../../releases) and unzip it anywhere
   (not inside Program Files).
3. Run **`VibeSkuffle.Manager.exe`**, add your accounts, tick them, and click **Start All**.
   Or run `VibeSkuffle.exe` for a single client.

Nothing else to install. The game player is in the `ruffle` folder. Scripts default to
`%APPDATA%\Skua\Scripts`; accounts and settings remain in `%APPDATA%\VibeSkua`.
VibeSkuffle can run side by side with a normal VibeSkua.

### New in v1.0.0 Stable

- VibeSkua **2.1.0**, including current main through `630c952`, with upstream themes, title-bar artwork and Manager script-options editing.
- **Options → Watch Dog → Rescue Settings:** shared delay (1–120 minutes) and death threshold (1–100), applied live across updated clients. Defaults remain 15 minutes or 10 deaths. Either threshold requests help; the timed path requires at least two deaths without a kill.
- Uniform two-column Current Drops actions, retaining AC pickup/banking and both rejection controls.
- **Search Scripts → Download / Update UltrasLW:** fetches the latest package every click, installs only `Skua/Scripts/UltrasLW`, and refreshes the searchable list. Invalid downloads leave the installed version intact; failed swaps roll back.
- Army Control → Misc Options shows confirmed **On**, **Off**, **Mixed**, **Pending**, or **Unknown** states and includes **Aggro Monsters**. Actions apply to every account in that tab host.

**Already using Beta9 or Beta9.5? Install v1.0.0 directly through Manager → Updater.** Your scripts, accounts, settings and custom plugins are preserved.
[Read the full stable release notes](docs/RELEASE-v1.0.0.md).

### New in Beta9.5

**One live Rescue Allies switch for every updated client, with individual helper opt-outs and idle saviors.**
Use Game Options → Gameplay & Character for the shared switch and the per-account checkbox. Idle helpers
can join, fight, return home and stay idle; existing running/paused scripts restore appropriately. The standalone
[Watch Dog Beta5](https://github.com/Aeoniian/Watch-Dog/releases/tag/beta5) uses the same shared settings.

**On Beta9? Install Beta9.5 directly through Manager → Updater.**
[Read the full release notes](docs/RELEASE-beta9.5.md).

### Added in Beta9

- **VibeSkua 2.0.9 and Cosmetics**, with upstream quest, scheduler, script-control and shutdown fixes.
- **Automatic AC banking and non-AC rejection**, combat guards, and two new Current Drops reject buttons.
- **Drag to reorder tabs and grid cells**, with saved order and visible drag/insertion indicators.
- **Per-account right-click controls** for scripts, Headless, Lag Killer and restart, plus the current script name.
- **Persistent ButlerV5 assignments** across interruptions and restarts, without the old 30-minute roster expiry.
- **VibeSkuffle GitHub client updates**, improved Launcher discovery, and a readable Info tab.

See the [full Beta9 release notes](docs/RELEASE-beta9.md) for changes, validation and remaining beta checks.
Install Beta9 manually if coming from Beta8 or earlier; its new updater handles compatible future packages.

### Requirements

**1 account (plus normal PC use)**

| | Minimum | Recommended |
|---|---|---|
| Windows | 10 or 11, 64-bit | 11 |
| RAM | 8 GB | 16 GB |
| Graphics | DirectX 12 or Vulkan capable | Any card from the last ~8 years |
| VRAM | 2 GB | 4 GB |

**Armying (6 accounts, plus normal PC use)**

| | Minimum | Recommended |
|---|---|---|
| Windows | 10 or 11, 64-bit | 11 |
| RAM | 16 GB | 32 GB |
| Graphics | DirectX 12 or Vulkan capable | Any card from the last ~8 years |
| VRAM | 6 GB | 8 GB+ |

Measured with 6 accounts farming FarmerJoeDoAll for several days, all visible in Grid View (the heaviest case):
each game window used **540–730 MB of VRAM** when fresh; across the runs the game windows together averaged
**about 3.8 GB of VRAM** with short peaks near 8 GB. RAM per game window is roughly 0.5–1.5 GB idle and grows
while farming; on a 32 GB PC the free RAM never dropped below ~2.9 GB (VibeSkuffle restarts the biggest game
window when the PC runs low). With 16 GB those restarts just happen more often.

---

## What's different from VibeSkua

### Speed and memory
- **Mugetsu instead of Flash.** Crowded rooms and big fights stay smooth: about 0.2 ms per bot↔game call.
- **DirectX 12 by default.** In testing, about 1.4 GB less memory for 6 accounts than Vulkan at the same fps.
  You can switch back in `ruffle-options.txt`.
- **Automatic memory cleanup.** Background accounts give unused memory back to Windows when you switch
  away and every 10 minutes after. 6 idle accounts went from ~5.4 GB to ~2.5 GB.
- Background tabs run at 2 fps / low quality while in game, and at full speed while logging in.

### Gets back up by itself (built for unattended, multi-day runs)
Automatic re-logins go back to the **same server and room** the account was on.

| Problem | What happens |
|---|---|
| Stuck on "Authenticating Account Info…" / "Connecting to game server…" | After 20 s: resets the login screen, then restarts the game window, avoids that server for 3 min and logs in again. It never gives up, but slows down to one try every 10 minutes if AQW is down. |
| Logged out with nothing happening (auto relogin gave up, kicked) | Logs back in after 3 minutes. Logouts you asked for are respected. |
| Game window crashes | Restarts it and logs back in. No error box waiting for a click. |
| Game window freezes | Detected within ~1.5 min, restarted, logged back in. |
| A client crashes or is killed | The tab window starts it again with the same login and script. |
| The tab window itself crashes | Every account starts itself again (one at a time) in a new tab window. |
| A game window grows past the memory limit | Restarted when out of combat (default 6000 MB; at most once per 30 min). |
| A script stops doing anything (no kills, drops, quests or moving for 15 min) | Logs out and back in, then starts the script again. |
| AQW spams "Quest Complete Failed: Missing Quest Progress" | Logs out and back in (that clears it), then starts the script again. |
| The PC itself runs low on RAM | The biggest game window restarts when it's out of combat. |
| "Communication with server has been lost" stays on screen | Logs back in after 1 minute. |
| An account keeps getting stuck again right after relogs (out of sync with the server) | 2nd time within 45 min: restarts the game window. 3rd time: restarts the whole client (like closing the tab and starting it from the Manager), keeping its login and script. At most once per 2 hours. |
| A script was running when any of the above happened | It is started again once the account has been back in game for a few seconds, and checked that it really runs (up to 3 tries). |
| Windows wants to sleep | It doesn't while VibeSkuffle is open (the screen can still turn off). |

**Discord alerts:** put a webhook in `alerts.txt` and you get a message when something needs you (a script that
won't start again, AQW looking down, a client that keeps crashing, a rescue that gave up), plus a daily summary of
what the watchdog fixed. See [docs/SETTINGS.md](docs/SETTINGS.md#discord-alerts-and-the-daily-summary-alertstxt).

Everything recovery does is written to `login-watchdog.log` next to `VibeSkuffle.exe` (time and account
name, never passwords). Logs are size-capped so they can't fill your drive.

### Rescue Allies (Options → Watch Dog)

**Rescue Allies - all accounts** is a live master switch shared with every updated Watch Dog/VibeSkuffle client
on this PC. **Allow this account to rescue** is a separate saved opt-out for the logged-in account. Excluded
helpers can still receive help. Defaults: shared master off, account eligibility on.

The **Rescue Settings** tab adjusts the shared delay (1–120 minutes) and death threshold (1–100).
Defaults are 15 minutes or 10 deaths; either threshold triggers, and the timed path requires at least two
deaths without a kill. A kill resets the streak. When a scripted account reaches a threshold, eligible accounts
on the same server go to help. **Helpers can be idle; no running or loaded script is needed.** They return to
their original room/cell afterward. Running scripts pause/resume, previously paused scripts remain paused,
and idle accounts stay idle. Manual stop/logout/new-script actions take precedence. Manual Auto Attack/Hunt
is left alone. Helpers give up after 20 minutes, and temporary quest-progress borrowing is restored.

The plugin exposes live controls under **Plugins → Rescue Allies**. Update/restart all participating copies
once. Shared preferences: `%APPDATA%\Skua\WatchDog\rescue-settings.json`.

### Drops
- **Saved automatic options** under Game Options → Drops & Looting: Pickup AC Drops and Send to Bank,
  and Reject Non-AC Drops. They work without a running script. AC acceptance/banking waits out combat;
  rejection can run during combat.
- **Current Drops → Reject All / Reject All Except AC**, plus automatic banking status updates.
- **Ignore Script Reject Else** (Game Options → Drops & Looting): scripts can no longer throw away drops they
  didn't ask for. They stay in the drop list so you can pick them up. *Reject All Drops* still works.
- **Current Drops → Pickup AC & Bank** remains available for manual use and waits until out of combat before accepting/banking.

### Army and ButlerV5

VibeSkuffle's ButlerV5 is the **VibeSkua/Skua ButlerV5** (from the current VibeSkua base) with these changes:

- **Log in all** (next to Summon all): logs in every other open account that's logged out, **on your server**, so
  you can Summon them straight away. It shows its progress in the footer.
- **Summon all reaches accounts on other servers**: they log in on your server and follow.
- **Followers stay with their master:**
  - If the master restarts or re-logs, its followers follow it again.
  - If it comes back on another server, they log in there by themselves, at most once every 5 minutes.
  - A master whose whole client restarted gets its saved followers list back without a 30-minute expiration.
  - Followers save and restore assignments across restarts/logins, keeping explicit releases and declined orders.
  - A brief offline master no longer causes followers to abandon their assignment.
- **A more reliable roster:**
  - Clients Windows won't let ButlerV5 inspect (for example ones running as administrator) are no longer hidden.
  - Each account refreshes its status file at least once a minute.
  - An empty roster says which accounts it found and why each isn't shown.
- **Debug log housekeeping:** the log keeps one previous file once it passes 10 MB.
- Right-click a tab → **Restart Client** (keeps login and script) fixes an account that's out of sync.
- Army **Login All** reaches every tab (not just the visible one) and leaves accounts already in game alone.
- Army messages only reach this install's clients, so a normal VibeSkua running alongside isn't affected.
- "Jump all to map" box: the cursor is already in it; an empty box no longer sends everyone nowhere.

> **Running VibeSkua/Skua and VibeSkuffle together?** VibeSkuffle loads its bundled ButlerV5 directly
> and does not overwrite the shared plugin copy. Fork-specific login/server methods now have stock-host
> guards. Full mixed-client following is still under validation; keep accounts that need to follow together
> in the same client until your combination is confirmed.

### Fixes that also apply to VibeSkua
- The Manager's saved accounts could be wiped: every program sharing the settings file wrote its whole (possibly
  stale or blank) copy back. Saves now only write what changed, and a `.bak` copy is kept.
- Packet Interceptor "Connect" reused the old login token ("Character data could not be retrieved").
- A dead (respawning) character was treated as logged out by Login All.
- Building no longer force-closes every running VibeSkua.

Full list: [CHANGELOG.md](CHANGELOG.md).

---

## Updates and script locations

**Manager → Updater** checks VibeSkuffle's own GitHub releases, including betas. Packages have a hashed
application manifest, staging and rollback. Script updates keep their existing repository independently;
client updates preserve accounts/settings, scripts, graphics preferences, alerts and custom plugins.

Scripts default to `%APPDATA%\Skua\Scripts`. Old absolute VibeSkua script paths resolve there when a
matching file exists. Explicit custom paths remain supported. Settings stay in `%APPDATA%\VibeSkua`.

## Settings

`ruffle-options.txt` (next to `VibeSkuffle.exe`) controls the game windows. See
[docs/SETTINGS.md](docs/SETTINGS.md). Common ones:

```
--graphics dx12                     # DirectX 12 (default). Remove for Vulkan.
SKUA_MEMORY_LIMIT_MB=6000           # restart a game window above this
myalt: SKUA_MEMORY_LIMIT_MB=8000    # ...or set it for one account only
SKUA_STUCK_SCRIPT_MINUTES=15        # relog a script that does nothing this long (0 = off)
```

Problems? See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

**Dashboards:** VibeSkuffle has VibeSkua v2.0.7's webhook settings, including its own Skua Nexus webhook next to
the Discord one, so a dashboard like [Skua Nexus](https://github.com/wtffidy/Skua-Nexus) should be able to show
your accounts. It's a separate project, not made or tested here.

---

## Building from source

The repo holds two patch files and one-click build scripts. They download VibeSkua and Mugetsu at the exact
versions the patches were made for, apply the patches and build. See [docs/BUILDING.md](docs/BUILDING.md).

```
1-install-tools.bat   →  2-build-ruffle.bat (~6 min)  →  3-build-skua.bat (~1 min)  →  5-run-manager.bat
```

---

## Credits and licenses

VibeSkuffle exists because of the people who built the bot it's made from. Thank you all.

**[VibeSkua](https://github.com/NinjaXz/VibeSkua)**
- **[NinjaXz](https://github.com/NinjaXz)**: creator. Avalonia overhaul, the multi-client tabbed host, army controls
  and grid view, headless mode, the script scheduler, stability work and the release pipeline.
- **[wtffidy](https://github.com/wtffidy)** (Tato): contributor (also a long-time Skua contributor, and the author
  of Skua Nexus).
- **[ArrowDev](https://github.com/ArrowDev123/Skua)** (BlackArrow on Discord): the early Avalonia UI port foundation.

**[ButlerV5](https://github.com/NinjaXz/VibeSkua/tree/main/Skua.Plugin.ButlerV5)** (bundled with VibeSkua)
- **[l0newolf12](https://github.com/l0newolf12)** (lonewolf_12): author of ButlerV5 and of its Avalonia port.

**[Skua](https://github.com/auqw/skua)** (MIT), the original framework and botting API, by the auqw team and
contributors (from the project's commit history):
[SharpTheNightmare](https://github.com/SharpTheNightmare) (Purple),
[d3lfs](https://github.com/d3lfs) (also [slypy](https://github.com/slypy)),
[wtffidy](https://github.com/wtffidy) (Tato),
[BrenoHenrike](https://github.com/BrenoHenrike),
[l0newolf12](https://github.com/l0newolf12),
[blackarrow123](https://github.com/blackarrow123),
[LordExelot](https://github.com/LordExelot),
[robmart](https://github.com/robmart) and
Lucas Correa.

**The game player**
- **[Mugetsu](https://github.com/mugetsu-aqw/mugetsu)** (GPL-3.0), built on
  **[Ruffle](https://github.com/ruffle-rs/ruffle)** (MIT / Apache-2.0) by the Ruffle contributors.
- **[JPEXS FFDec](https://github.com/jindrapetrik/jpexs-decompiler)** (GPL-3.0), bundled with VibeSkua.

If you contributed to any of these and are missing or want your entry changed, open an [issue](../../issues).

The game player shipped here is a **modified** Mugetsu (it adds the bridge VibeSkuffle talks to). Its source is
Mugetsu v1.5.1 plus [`patches/skua.patch`](patches/skua.patch). This repository is licensed under
**GPL-3.0** (see [LICENSE](LICENSE)); see [NOTICE.md](NOTICE.md) for details.

Not affiliated with, endorsed by, or supported by Artix Entertainment, the Ruffle project, Mugetsu, Skua or
VibeSkua. **Using bots breaks AQW's Terms of Service and can get accounts banned. Use at your own risk.**
