# Troubleshooting

**Nothing happens when I start it / "You must install .NET"**
Install the [.NET 10 Desktop Runtime (x64)](https://dotnet.microsoft.com/download/dotnet/10.0).

**The game window is black or crashes at start**
Update your graphics driver. If that doesn't help, remove `--graphics dx12` from `ruffle-options.txt`
to use Vulkan instead.

**Starting the same account twice**
Two clients fighting over one login: one sits on "Loading Character Data", the other goes black. Start each
account once.

**An account keeps logging back in after I logged it out**
It shouldn't: logouts from the game's button, the army, a script or the Manager are respected. If it
does, `login-watchdog.log` says why. Please open an issue with those lines.

**ButlerV5 "Log in all" says no other clients are open**
It only logs in accounts that are already open (started from the Manager). Start them first.

**Memory keeps going up**
Ruffle keeps some memory around for speed; background accounts give it back every 10 minutes. If a
window passes `SKUA_MEMORY_LIMIT_MB` (default 6000 MB) it is restarted when out of combat.

**Reporting a problem**
In the build folder (when building from source): `save-crash-logs.bat` copies the crash reports and recent
logs into `logs\`. `procs.bat` lists running clients. Attach `login-watchdog.log` and the crash logs to your issue.
Check them for anything you don't want to share first. They contain account names (never passwords).
