# v1.0.3 - Grid View start option, toasts, Auto Headless and account switcher

## Quality of life
- **Grid View on multi-start:** a new Manager option, **Open Grid View when starting 2 or more accounts**, is off by default. When Start All, Start Selected, a group, or any "in new window" start launches two or more accounts, the client window opens them in Grid View. A single account still opens as a normal tab.
- **Toasts in the Manager:** short one-line messages that need no answer (Setup Saved, Script Loaded, no accounts selected and the like) now slide in at the bottom right instead of opening an OK dialog. Failures stay longer and carry a red bar. Long or multi-line messages, such as compile errors and file paths, stay dialogs so they can be read and copied.
- **Auto Headless:** a new **Headless** tab in Game options. Auto Headless puts any tab that isn't showing into headless by itself, with switches for background tabs, Grid View counting as showing, a minimized window, and showing a tab ending headless. It never overrides Headless Mode set by hand.
- **Account switcher in Game options:** a drop-down shows and changes each account's own game options. Switching with unsaved changes asks Save or Cancel.
- **Command palette:** `Ctrl+K` opens a search over the tools.
- **Full screen:** `F11` switches the client window to borderless full screen and back, and it is also a hotkey action.
- **Grid View tiles** keep the game's proportions, and a short last row is centred.
- **Login All** skips clients that are already in game and logs the others in two seconds apart.
- **Watch Dog notices:** a band under the tab strip shows what Watch Dog and the re-login are doing for each client. A tab's icon turns amber while it works and red when it gives up.
- **Army Control** now shows whether every client has the same script loaded, a mix, or none.
- **Army Queue:** squads can be reordered by dragging.
- **Server list:** the dropdown shows each server's ping, coloured, and refreshes when opened. It shows "Loading servers..." while it loads.
- **Reset Scripts** now renames the Scripts folder to `Scripts-old-<date>` instead of deleting it.

## Versioning
- **VibeSkuffle's own version number:** window titles and the updater now use VibeSkuffle's release number (1.0.3) instead of the upstream VibeSkua 2.1.1. Scripts still see the upstream number, so CoreBots and other version checks are unaffected.

## Fixes
- The "Live rescue status unavailable" text in Rescue Allies no longer shows a garbled dash.

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts and custom plugins are preserved. Script updates remain independent through Skua.

## Limits
The new features were checked by hand in the Manager and client. No automated test suite covers them, and overnight operation and large multi-account armies were not part of this check. The standalone Watch Dog plugin is delivered separately and is unchanged (v1.0.1).
