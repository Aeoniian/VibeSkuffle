# VibeSkuffle v1.0.0 — Stable

VibeSkuffle leaves beta with VibeSkua 2.1.0, adjustable shared rescue settings, an UltrasLW installer and clearer Army controls.

**Update directly from Manager → Updater.** Beta9/Beta9.5 users can download and install v1.0.0 there. Accounts, settings, existing scripts, graphics choices and custom plugins are preserved. Beta8 and older require a manual installation first. Script updates continue using their existing Skua source.

## Changes since Beta9.5

- **VibeSkua 2.1.0:** integrated upstream main through `630c952`, including themes/title-bar artwork and the Manager's script-options editor. Retained Ruffle/Mugetsu, saved tab/grid ordering, context controls, combat-safe AC banking, Butler fixes, Skua script-folder defaults and the VibeSkuffle updater.
- **Options → Watch Dog → Rescue Settings:** adjust the shared rescue delay (1–120 minutes) and death threshold (1–100). Defaults remain 15 minutes or 10 deaths; either threshold calls for help. The timer starts at the first death and requires at least two deaths without a kill. A kill resets both counters. Changes apply to current streaks on the next check; existing calls continue until a normal stop condition.
- **Shared rescue controls retained:** one live master switch, separate per-account helper eligibility, and idle rescuers without a loaded/running script. Thresholds are shared with Watch Dog v1.0.0; update all participating clients/plugins.
- **Working Watch Dog window:** fixed missing view registration and added its shield menu icon. The actual menu-opening path is now covered by verification.
- **House returns:** rescue helpers use AQW's house command when returning to their own house.
- **Current Drops:** six uniformly sized buttons in three paired rows, with consistent icons, spacing and AC pickup/bank/reject actions.
- **Download / Update UltrasLW** in Scripts → Script Loader → Search Scripts. Every click fetches the latest package and replaces only `Skua/Scripts/UltrasLW`, then refreshes the searchable list. Includes archive checks, concurrent-install protection, cancellation and rollback.
- **Army Control → Misc Options:** added Aggro Monsters and confirmed state feedback: green On, red Off, amber Mixed/Pending and gray Unknown. Actions apply to all accounts in that tab host. Accounts report immediately after applying commands, prompting immediate menu refresh; periodic reports remain a fallback.
- **Packaging:** fresh dependencies and bundled plugins, Manager dependency manifest, and the new upstream animation dependencies are included.

## Verification

Client, Manager and bundled-plugin builds pass. 124 automated checks cover rescue behavior, installer/Army state, existing updater/drop/Butler/context-label behavior and immediate confirmations. Native Avalonia previews verify the actual Watch Dog menu route, two-way shared controls, plugin tabs and uniform buttons. A saved-account private-room test verified idle rescue, real combat, return home and remaining idle. The fork patch reconstructs the source from clean upstream.

Remaining manual checks: native stock WPF interaction, Army commands across multiple real accounts, and overnight/multi-day runs. Live AC-drop-to-bank transfer remains unverified; simulated combat/banking guards pass.

The portable ZIP contains program files and clean defaults, with no saved accounts, user settings, alerts, runtime logs, test scripts or custom plugins. Requires .NET 10 Desktop Runtime, Windows x64.
