# VibeSkuffle

**VibeSkua, running on Mugetsu (a faster Ruffle) instead of Flash, built to run a whole army for days without babysitting.**

VibeSkuffle is [VibeSkua](https://github.com/NinjaXz/VibeSkua) with the Flash player swapped out for
[Mugetsu](https://github.com/mugetsu-aqw/mugetsu), a performance-tuned build of the
[Ruffle](https://ruffle.rs) Flash emulator. Everything VibeSkua does still works: scripts, the Manager, the
army, plugins, hotkeys, the grabber and the packet tools. On top of that it gets back up by itself when something
goes wrong: stuck logins, crashes, freezes, memory build-up, and a crashed tab window.

> **Status: beta.** Long-run (overnight / multi-day) testing is in progress. Use the
> [latest release](../../releases) and report anything odd in [Issues](../../issues).

---

## Download and run

1. Install the **[.NET 10 Desktop Runtime (x64)](https://dotnet.microsoft.com/download/dotnet/10.0)** if you
   don't have it ("Run desktop apps" → Windows x64).
2. Download `VibeSkuffle-<version>-win-x64.zip` from [Releases](../../releases) and unzip it anywhere
   (not inside Program Files).
3. Run **`VibeSkuffle.Manager.exe`**, add your accounts, tick them, and click **Start All**.
   Or run `VibeSkuffle.exe` for a single client.

Nothing else to install. The game player is in the `ruffle` folder. VibeSkuffle uses the same scripts and
settings folder as VibeSkua (`%APPDATA%\VibeSkua`), and can run side by side with a normal VibeSkua.

### Requirements

| | Minimum | Recommended for 6 accounts + normal PC use |
|---|---|---|
| Windows | 10 or 11, 64-bit | 11 |
| RAM | 16 GB | 32 GB |
| Graphics | DirectX 12 or Vulkan capable | Any card from the last ~8 years |
| VRAM | 6 GB | 8 GB+ |

Measured with 6 accounts farming, all visible in Grid View (the heaviest case): each game window used
**540–730 MB of VRAM (about 4.1 GB for 6)**. Background tabs use less. RAM per game window is roughly
0.5–1.5 GB idle and grows while farming (it cleans up after itself, with a restart safety net).

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
| A script was running when any of the above happened | It is started again once the account is back in game. |
| Windows wants to sleep | It doesn't while VibeSkuffle is open (the screen can still turn off). |

Everything recovery does is written to `login-watchdog.log` next to `VibeSkuffle.exe` (time and account
name, never passwords). Logs are size-capped so they can't fill your drive.

### Army and ButlerV5
- **ButlerV5 "Log in all"** (next to Summon all): logs in every other open account that's logged out,
  **on your server**, so you can Summon them straight away. It shows its progress in the footer.
- **Followers stay with their master:** if the master restarts or re-logs, its followers follow it again; if it
  comes back on another server, they log in there by themselves; a master whose whole client restarted gets its
  followers list back.
- Army **Login All** reaches every tab (not just the visible one) and leaves accounts already in game alone.
- Army messages only reach this install's clients, so a normal VibeSkua running alongside isn't affected.
- "Jump all to map" box: the cursor is already in it; an empty box no longer sends everyone nowhere.

### Fixes that also apply to VibeSkua
- The Manager's saved accounts could be wiped: every program sharing the settings file wrote its whole (possibly
  stale or blank) copy back. Saves now only write what changed, and a `.bak` copy is kept.
- Packet Interceptor "Connect" reused the old login token ("Character data could not be retrieved").
- A dead (respawning) character was treated as logged out by Login All.
- Building no longer force-closes every running VibeSkua.

Full list: [CHANGELOG.md](CHANGELOG.md).

---

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

---

## Building from source

The repo holds two patch files and one-click build scripts. They download VibeSkua and Mugetsu at the exact
versions the patches were made for, apply the patches and build. See [docs/BUILDING.md](docs/BUILDING.md).

```
1-install-tools.bat   →  2-build-ruffle.bat (~6 min)  →  3-build-skua.bat (~1 min)  →  5-run-manager.bat
```

---

## Credits and licenses

- **[VibeSkua](https://github.com/NinjaXz/VibeSkua)** by NinjaXz, a derivative of
  [Skua](https://github.com/auqw/skua) (MIT, as stated in VibeSkua's README). Includes the ButlerV5 plugin.
- **[Mugetsu](https://github.com/mugetsu-aqw/mugetsu)**, GPL-3.0, built on
  **[Ruffle](https://github.com/ruffle-rs/ruffle)** (MIT / Apache-2.0).
- **[JPEXS FFDec](https://github.com/jindrapetrik/jpexs-decompiler)** (GPL-3.0), bundled with VibeSkua.

The game player shipped here is a **modified** Mugetsu (it adds the bridge VibeSkuffle talks to). Its source is
Mugetsu v1.4.0 plus [`patches/skua.patch`](patches/skua.patch). This repository is licensed under
**GPL-3.0** (see [LICENSE](LICENSE)); see [NOTICE.md](NOTICE.md) for details.

Not affiliated with, endorsed by, or supported by Artix Entertainment, the Ruffle project, Mugetsu, Skua or
VibeSkua. **Using bots breaks AQW's Terms of Service and can get accounts banned. Use at your own risk.**
