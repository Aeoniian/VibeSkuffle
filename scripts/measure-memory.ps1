param([string]$Label = "sample", [switch]$Trim)
# Logs memory of this build's game windows (Mugetsu) and bots (VibeSkuffle) to logs\memory.csv.
# -Trim first asks Windows to trim the game windows' working sets (test for idea #4).
$root = Split-Path $PSScriptRoot -Parent
$csv = Join-Path $root 'logs\memory.csv'
if ($Trim) {
  Add-Type -Name P -Namespace W -MemberDefinition '[DllImport("psapi.dll")] public static extern bool EmptyWorkingSet(System.IntPtr h);'
  Get-Process Mugetsu -ErrorAction SilentlyContinue | Where-Object { $_.Path -like '*VibeSkuaRuffle*' } | ForEach-Object { [void][W.P]::EmptyWorkingSet($_.Handle) }
  Start-Sleep -Seconds 2
}
if (-not (Test-Path $csv)) { 'time,label,name,pid,workingset_mb,private_ws_mb,commit_mb,cpu_s' | Set-Content $csv }
$t = Get-Date -Format 'HH:mm:ss'
$procs = Get-Process Mugetsu, VibeSkuffle -ErrorAction SilentlyContinue | Where-Object { $_.Path -like '*VibeSkuaRuffle*' }
# "Working set - private" is what Task Manager's Memory column shows.
$perf = @{}
Get-CimInstance Win32_PerfFormattedData_PerfProc_Process | ForEach-Object { $perf[[int]$_.IDProcess] = $_.WorkingSetPrivate }
foreach ($p in $procs) {
  "{0},{1},{2},{3},{4:F0},{5:F0},{6:F0},{7:F0}" -f $t, $Label, $p.ProcessName, $p.Id, ($p.WorkingSet64/1MB), ($perf[$p.Id]/1MB), ($p.PrivateMemorySize64/1MB), $p.TotalProcessorTime.TotalSeconds | Add-Content $csv
}
