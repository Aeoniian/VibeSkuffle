# Renderer performance in v1.0.1

This release improves headless scheduling, GPU admission and optional resource tuning.
Measurements below were collected during development with a preserved v1.0.0 baseline.

The largest measured improvement is headless operation **with frame interpolation enabled**.
Interpolation is normally off by default. These results do not imply the same CPU reduction
for every setup, or a universal visible-mode FPS improvement.

## Changes

- Headless mode suppresses normal redraw requests and interpolation scheduling. Returning
  to visible mode clears the interpolation deadline and requests a fresh picture.
- GPU admission is checked before rendering commits cached bitmap updates. At most two
  tracked movie-frame submissions are admitted; completion callbacks retire them. A busy
  GPU causes a paced retry instead of blocking the game thread for two seconds or forgetting
  unfinished work after a timeout.
- Synchronous offscreen shader work keeps its existing backpressure, because its pixels may
  affect ActionScript. Its timeout now retains the unfinished submission for later checks.
  This does not impose a two-submission limit on every possible GPU operation.
- Emergency graphics-memory cleanup uses a bounded 50 ms GPU wait. When it times out,
  resource destruction remains deferred safely inside wgpu rather than waiting indefinitely.
- Optional headless spare-texture budgets use existing LRU eviction without a GPU wait.
- The serial tessellation comparison switch now also covers rescaled shapes.
- Optional diagnostics record bounded frame/render samples and report p95/p99 times and
  the number of GPU admission deferrals. Existing summaries remain available.
- The command-encoding threshold is adjustable for controlled CPU-budget comparisons.

## Optional tuning

These entries go in `ruffle-options.txt` next to VibeSkuffle.exe. Restart the account's game
process after editing them. Existing global defaults are retained unless explicitly changed.

```text
# Example values for experimentation, not universal recommended settings:
RAYON_NUM_THREADS=2
RUFFLE_POOL_IDLE_MB=128
SKUA_HEADLESS_POOL_IDLE_MB=64
SKUA_PARALLEL_MIN_SEGMENTS=4
SKUA_PERF_DETAILS=1
```

- `RAYON_NUM_THREADS` is Rayon's existing per-process worker limit. It covers the parallel
  shape preparation and graphics-command finishing used by this renderer. It does not cap
  all application threads or throttle game logic. No automatic fair-share limit is imposed.
- `RUFFLE_POOL_IDLE_MB` is the existing limit for **each** spare texture pool, not total
  graphics memory. It protects recently reused sizes, so it is a soft cache budget.
- `SKUA_HEADLESS_POOL_IDLE_MB` optionally trims each idle pool once when entering headless
  mode; 0 releases all spare textures, 1-4096 selects MB, and omission preserves existing
  behavior. In-use textures remain owned until the GPU finishes. Returning to visible mode
  can recreate evicted resources.
- `SKUA_PARALLEL_MIN_SEGMENTS` selects how many recorded command segments justify parallel
  finishing. Minimum 2, default 2 (existing behavior). Higher values can avoid parallel work
  for small scenes but can slow heavier scenes.
- `SKUA_PERF_DETAILS=1` enables percentile diagnostics. Omission avoids collecting samples.

For an account-specific entry, use `accountname: RAYON_NUM_THREADS=2`. Put account-specific
environment entries after shared entries in the current options parser. Avoid publishing
personal account names in shared configuration examples.

## Verification scope

The deterministic workload uses 180 moving filtered shapes through the actual renderer and
named-pipe bridge. A test host embeds 1, 4, and 9 windows so covered standalone windows
cannot accidentally stop rendering and invalidate the comparison. Phases are visible,
headless, and restored. This is a renderer comparison, not nine real game accounts.

Separate saved-account checks use the normal account model and private rooms. Credentials
stay in memory; account/settings files are not copied into test artifacts. The smoke script
checks room transfers and combat progress while visible, headless, and restored, and restores
the original headless choice and location afterwards.

An overnight run, full multi-account gameplay/following/Watch Dog exercise, multiple hardware
configurations, and physical driver-failure recovery require further validation. Synthetic
queue tests do not establish recovery from every driver failure. No conclusion about the
reported mass-login problem follows from this work.

One early nine-window candidate run exited during active testing before detailed exit capture
was enabled. The cause is unresolved; subsequent nine-window runs passed. Both the
preserved baseline and candidate also produced DXGI exception reports during shutdown in
some synthetic runs; those shutdown reports are distinct from the earlier active-test exit.

## Verified results (2026-10-26)

- Final Rust dist build passed with the existing upstream warnings; seven focused policy/queue checks pass.
- Native comparisons covered 1, 4, and 9 embedded renderer windows. The final build passed a nine-window
  visible/headless/restored check with 270 bridge replies; the slowest reply was 13.88 ms.
  The preceding 90-second nine-window check also passed 810 replies. These are synthetic renderers,
  not nine authenticated game accounts.
- Headless CPU with interpolation enabled was about 0.993 CPU cores in the fixed-monitor
  nine-renderer baseline and 0.020 cores in the final check (which also serviced bridge probes).
  Both continued advancing the workload at 24 game FPS. The measurement windows differ in duration;
  this is evidence of the removed busy loop, not a general gameplay benchmark.
- Worker caps reduced thread counts, but visible-mode CPU/RAM measurements were mixed. Worker and
  visible texture-cache defaults remain unchanged. Headless cache trimming remains opt-in.
- The final saved-account script passed private-room transfers and combat in all three phases:

```text
Renderer gameplay smoke check
PASS visible combat progressed; script ticks=40; kills=12
PASS headless combat progressed; script ticks=40; kills=12
PASS restored combat progressed; script ticks=40; kills=12
DONE
```

- All 86 application hashes verify. The release changes the renderer, client DLL and build/version metadata
  relative to v1.0.0. Exact source patch is bundled in `SOURCE/skua.patch`.
- These renderer changes ship in v1.0.1 together with the client script-text compatibility fix.
- Shutdown exit 2170 / DXGI exception 0x87A also reproduces in the unchanged baseline. No test
  process needed forced termination in the final nine-window run. This pre-existing shutdown
  issue remains distinct from the one unresolved early active-test exit described above.

## Combined v1.0.1 validation

The release client includes both the script-text fix and the tested renderer. All 27 text
compatibility checks pass against the staged release DLL. The combined private-room smoke
test completed as follows:

```text
Renderer gameplay smoke check
PASS visible combat progressed; script ticks=40; kills=12
PASS headless combat progressed; script ticks=40; kills=12
PASS restored combat progressed; script ticks=40; kills=11
DONE
```
