@echo off
rem Builds VibeSkua with the Ruffle backend and puts the Ruffle player next to it.
rem Output: VibeSkua\Build\VibeSkuffle.exe, log: logs\3-build-skua.log
cd /d "%~dp0"
if not exist logs mkdir logs
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\build-skua.ps1" > "%~dp0logs\3-build-skua.log" 2>&1
echo exit %ERRORLEVEL% >> "%~dp0logs\3-build-skua.log"
