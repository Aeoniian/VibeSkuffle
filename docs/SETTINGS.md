# Settings: `ruffle-options.txt`

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

## Game Options added by VibeSkuffle

Set them in **Options → Game Options** and click **Save Options** (saved per settings file, so every account
started afterwards uses them; a script can also set `Bot.Options.RescueAllies` / `Bot.Options.IgnoreScriptRejectElse`).

| Option | What it does |
|---|---|
| Rescue Allies | While this account runs a script, it goes to help another account on the same server that keeps dying (10 deaths without a kill, or 15 minutes of only deaths), then comes back and starts its script again. |
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
