# Settings: `ruffle-options.txt`

## v1.0.0: rescue settings, Army feedback and UltrasLW

Open **Options → Watch Dog → Rescue Settings** to set rescue delay (1–120 minutes) and deaths before
requesting rescue (1–100). Both values are shared immediately across updated clients on this PC.
Defaults are 15 minutes or 10 deaths. Either threshold triggers; the timer starts at the first death and
requires two deaths without a kill. A kill resets both counters. Edits affect the current streak on the
next watchdog check, while existing calls continue until a kill or another normal stop condition.
The existing master and per-account eligibility controls remain available under Game Options too.

**Army Control → Misc Options** acts on every open account in that tab host. Green On and red Off
require matching reports from all accounts. Amber Mixed means disagreement, Pending means a command
is awaiting confirmation, and gray Unknown means a report is missing or stale. Mixed and Unknown
clicks enable the option for all accounts. Aggro Monsters follows the same rules.
Accounts report immediately after an Army option command, and notify the host to refresh immediately.
Periodic account reports and host polling remain active as a fallback.

**Search Scripts → Download / Update UltrasLW** downloads the current main branch from
`l0newolf12/UltrasLW` on each click and replaces only `%APPDATA%/Skua/Scripts/UltrasLW`.
The normal Skua script updater remains independent. Invalid downloads and failed installs preserve
the installed version. Close running UltrasLW scripts before updating their files.

This file sits next to `VibeSkuffle.exe` and controls the game windows (the `Mugetsu.exe` processes).
Each window reads it when it starts, so restart the clients after editing it. Rebuilding keeps your copy.

- Lines starting with `#` are comments.
- Lines starting with `-` are passed to the game window as command-line options.
- `NAME=VALUE` lines are environment variables for the game window.
- Start a line with an account name and a colon to apply it to that account only.

```
# DirectX 12 (default). Remove or put # in front to use Vulkan.
--graphics dx12

# Restart a game window once it uses more than this much memory (MB). Default 6000.
SKUA_MEMORY_LIMIT_MB=6000

# The same for one account only (the login name, not the character name)
myalt: SKUA_MEMORY_LIMIT_MB=8000

# Relog a running script that has done nothing (no kills, drops, quests, gold or moving) this long. 0 = off.
SKUA_STUCK_SCRIPT_MINUTES=15

# Size limit of each game window's own log file in MB (default 25)
SKUA_LOG_CAP_MB=25
```

Besides the memory limit, when the whole PC drops under 10% free RAM the biggest game window restarts
(out of combat, at most once per 30 minutes per window).

## Where things are written

| File | What |
|---|---|
| `login-watchdog.log` (next to VibeSkuffle.exe) | Every recovery: stuck logins, crashes, freezes, memory restarts, relaunches |
| `host-recovery.log` (next to VibeSkuffle.exe) | Step-by-step trace when the tab window goes away |
| `%LOCALAPPDATA%\ruffle\log\skua-*.log` | Each game window's log (25 MB cap, 3 days) |
| `%LOCALAPPDATA%\ruffle\log\skua-crash-*.log` | Game window crash reports (14 days) |
| `%APPDATA%\Skua\butlerv5_logs\` | ButlerV5 debug logs (when enabled; 10 MB cap) |

None of these contain passwords.

## Switching back to Flash

Delete `use-ruffle.txt` next to `VibeSkuffle.exe` to use the Flash player instead (needs Flash installed,
like normal VibeSkua).

## Graphics menu and the game's right-click menu

The **Graphics** tab in each client's menu bar has Mugetsu's own settings. A change applies to **every
account** at once (the other clients follow within 2 seconds) and is kept for game windows started later:

- **Edge smoothing:** Flash-style (default, lighter on laptops and built-in graphics) or MSAA.
- **Frame interpolation:** smoother motion between game frames, for strong PCs.
- **Show FPS:** a small frame counter in the corner of the game.
- **Open Mugetsu's log folder.**

It also shows the graphics API this account uses. To change that, **right-click the game** and choose
**Vulkan**, **DirectX 12** or **OpenGL**. That's for that account only: VibeSkuffle saves it in
`ruffle-options.txt` as `account: --graphics vulkan` (an account's own line wins over the line for
everyone) and restarts that game window, which logs back in and starts its script again. If the game
doesn't come up with the new API within 90 seconds, it goes back to the previous one by itself (and sends a
Discord alert if alerts are on). To go back to the setting for everyone, delete the account's line.

## Game Options added by VibeSkuffle

Set ordinary options in **Options → Game** and click **Save Options**. Rescue preferences and the AC banking/
non-AC rejection toggles save immediately through their own stores. Scripts can also set
`Bot.Options.RescueAllies` / `Bot.Options.IgnoreScriptRejectElse`.

| Option | What it does |
|---|---|
| Rescue Allies | Shared master switch. Eligible idle or scripted accounts help a caller on the same server, then restore their previous state. Default trigger: 10 deaths without a kill, or 15 minutes with repeated deaths; adjustable in Options → Watch Dog → Rescue Settings. |
| Ignore Script Reject Else | A script's "Reject Else" no longer throws away drops it didn't ask for. |

## Discord alerts and the daily summary (`alerts.txt`)

Create `alerts.txt` next to `VibeSkuffle.exe` to get a Discord message when the watchdog needs a person, and a
summary of everything it did once a day:

```
webhook=https://discord.com/api/webhooks/...   # Discord channel → Edit → Integrations → Webhooks → Copy URL
summary_hour=8                                  # hour of the day (0-23) for the summary; -1 = no daily summary
```

You get a message when: a script couldn't be started again after 3 tries, an account has needed 6 recoveries in a
row (and 12: AQW may be down), it's back in game after that, a whole client was restarted because relogs didn't
help, a client or the tab window keeps crashing, an account has no saved login, or a rescue gave up. The same alert
for the same account is sent at most once every 10 minutes. Every send is noted in `login-watchdog.log` (never the
webhook itself). Right-click a tab → **Watchdog Summary (last 24 hours)** shows the summary any time.

`alerts.txt` is kept when you rebuild and is never put in a release zip. It's separate from VibeSkua's own
"Discord Webhook URL" setting (script started/stopped messages). Keep the webhook private: anyone with it can post
to your channel.

## Beta9: drops, tab order and client updates

Options → Game → Drops & Looting has saved **Pickup AC Drops and Send to Bank** and **Reject Non-AC Drops**
toggles. These work without a script. Banking waits until out of combat; rejection is allowed during combat.
The manual AC banking button stays in Current Drops, alongside Reject All and Reject All Except AC.

Drag account tabs to set their order; grid view follows it and the order persists. The active tab fades while
dragging and an accent edge marks the insertion point. Right-click the game or headless overlay for per-account
script/display controls and the selected/running script's name.

Scripts default to `%APPDATA%\Skua\Scripts`; settings/accounts remain in `%APPDATA%\VibeSkua`.
Client updates use VibeSkuffle GitHub releases. Script updates remain independent.

## Beta9.5: shared Rescue Allies controls

Game Options → Gameplay & Character has **Rescue Allies - all accounts** and **Allow this account to rescue**.
The master switch updates every open updated client; the second checkbox only excludes the logged-in account
from helping and does not stop it receiving help. Defaults are master off and eligibility on.

Idle accounts can rescue without a script. Supported running scripts pause/resume, previously paused scripts
stay paused, and idle accounts return idle. Manual stop/logout/new-script actions take precedence.

The standalone Watch Dog plugin exposes the same live controls under Plugins → Rescue Allies. Shared values
and exclusions are saved in `%APPDATA%\Skua\WatchDog\rescue-settings.json`. All participating clients need
the updated code loaded; restart once after installation. Settings apply immediately without Save Options.
