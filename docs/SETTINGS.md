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
