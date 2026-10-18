@echo off
rem Lists VibeSkuffle and Mugetsu processes with their status. Output: logs\procs.log
cd /d "%~dp0"
if not exist logs mkdir logs
> "%~dp0logs\procs.log" (
  tasklist /v /fi "imagename eq VibeSkuffle.exe"
  tasklist /v /fi "imagename eq Mugetsu.exe"
  tasklist /v /fi "imagename eq VibeSkuffle.Manager.exe"
  powershell -NoProfile -Command "Get-CimInstance Win32_Process -Filter \"name='VibeSkuffle.exe' or name='Mugetsu.exe' or name='VibeSkuffle.Manager.exe'\" | Select-Object ProcessId,ParentProcessId,Name | Format-List"
) 2>&1
