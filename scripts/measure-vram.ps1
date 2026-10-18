# Logs dedicated + shared GPU memory per game window (Mugetsu) and bot (VibeSkuffle) to logs\vram.txt.
$root = Split-Path $PSScriptRoot -Parent
$out = Join-Path $root 'logs\vram.txt'
$procs = Get-Process Mugetsu, VibeSkuffle -ErrorAction SilentlyContinue | Where-Object { $_.Path -like '*VibeSkuaRuffle*' }
$ded = Get-Counter '\GPU Process Memory(*)\Dedicated Usage' -ErrorAction SilentlyContinue
$sha = Get-Counter '\GPU Process Memory(*)\Shared Usage' -ErrorAction SilentlyContinue
$adapter = Get-Counter '\GPU Adapter Memory(*)\Dedicated Usage' -ErrorAction SilentlyContinue
function SumFor($set, $procId) { ($set.CounterSamples | Where-Object { $_.InstanceName -like "pid_${procId}_*" } | Measure-Object CookedValue -Sum).Sum / 1MB }
$lines = @("time: $(Get-Date -Format 'HH:mm:ss')")
$tD = 0; $tS = 0
foreach ($p in $procs) {
  $d = SumFor $ded $p.Id; $s = SumFor $sha $p.Id; $tD += $d; $tS += $s
  $lines += "{0,-12} {1,6}  dedicated {2,7:F0} MB  shared {3,7:F0} MB" -f $p.ProcessName, $p.Id, $d, $s
}
$lines += "TOTAL this build: dedicated {0:F0} MB, shared {1:F0} MB" -f $tD, $tS
$lines += "Whole GPU dedicated in use (all apps): {0:F0} MB" -f (($adapter.CounterSamples | Measure-Object CookedValue -Sum).Sum / 1MB)
try { $lines += (Get-CimInstance Win32_VideoController | ForEach-Object { "GPU: $($_.Name)" }) } catch {}
$lines | Set-Content $out
