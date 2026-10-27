# v1.0.1 - Script compatibility hotfix and Mugetsu improvements

## Fixed
- Fixed item-name encoding differences between Flash and Ruffle. Existing scripts can recognize pets/items such as `Crag &amp; Bamboozle` through inventory and bank checks again, instead of incorrectly choosing a fallback farming method. Script files do not need editing.

## Mugetsu improvements
- Headless mode stops unnecessary redraw/interpolation wake-ups while keeping game logic and script communication active. The largest measured CPU reduction was with frame interpolation enabled.
- Added paced GPU retries before screen rendering, completion-aware submission tracking, and a bounded GPU wait during memory cleanup. Synchronous offscreen shader work retains its required backpressure.
- Added optional headless texture-cache budgets, parallel-command thresholds, and p95/p99 diagnostics. Existing worker and visible-cache defaults stay unchanged; per-account tuning is documented.
- Fixed the serial-tessellation comparison switch for rescaled shapes.

## Update
**Install through Manager -> Updater.** Accounts, settings, scripts, and custom plugins are preserved. Script updates remain independent through Skua.

## Validation and limits
27 script-text checks, seven renderer policy/queue checks, native 1/4/9-window comparisons, bridge-response checks, and private-room combat/headless smoke tests passed. All packaged application files are hash-verified through the actual updater staging code.

The full Leery Exchange farm still needs confirmation from an owner of the relevant pets. One early nine-window development run exited without a diagnosed cause; later repeated runs passed. A separate DXGI shutdown issue also reproduces in the unchanged baseline. Overnight and cross-hardware reliability are not established, and visible-mode CPU/RAM results were mixed.

Watch Dog remains v1.0.0; no standalone plugin update is required for this client hotfix.
