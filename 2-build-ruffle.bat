@echo off
rem Builds Mugetsu (Ruffle) with the Skua bridge. Output: out\ruffle\Mugetsu.exe, log: logs\2-build-ruffle.log
rem Add NOPGO as an argument to build without Mugetsu's speed profile.
cd /d "%~dp0"
if not exist logs mkdir logs
set "EXTRA="
if /i "%~1"=="NOPGO" set "EXTRA=-NoPgo"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\build-ruffle.ps1" %EXTRA% > "%~dp0logs\2-build-ruffle.log" 2>&1
echo exit %ERRORLEVEL% >> "%~dp0logs\2-build-ruffle.log"
