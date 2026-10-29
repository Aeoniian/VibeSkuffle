VibeSkuffle v1.0.0-beta - VibeSkua on Mugetsu (Ruffle)
=====================================================

Start
-----
1. Needs the .NET 10 Desktop Runtime (x64):
   https://dotnet.microsoft.com/download/dotnet/10.0  ("Run desktop apps", Windows x64)
2. Run VibeSkuffle.Manager.exe, add your accounts, tick them, click Start All.
   (VibeSkuffle.exe on its own starts a single client.)

Settings remain in %APPDATA%\VibeSkua; scripts default to %APPDATA%\Skua\Scripts.
Runs alongside normal VibeSkua/Skua and loads its own bundled ButlerV5.

Manager -> Updater checks VibeSkuffle GitHub releases. Scripts and settings are preserved.
Script updates keep their existing source. Install the first updater-enabled build manually.

Settings
--------
ruffle-options.txt (this folder): DirectX 12 / Vulkan, memory limit, per-account options.
login-watchdog.log (this folder): everything the automatic recovery did (no passwords).

More: https://github.com/__REPO__

Not affiliated with Artix Entertainment, Ruffle, Mugetsu, Skua or VibeSkua.
Using bots breaks AQW's Terms of Service. Use at your own risk.

Licenses: see LICENSES-VibeSkuffle.txt. The player in ruffle\ is a modified Mugetsu (GPL-3.0); its source
is Mugetsu v1.6.0 plus patches/skua.patch at the link above.
