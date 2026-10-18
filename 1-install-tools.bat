@echo off
rem Installs what the builds need (skips what's already there). Output: logs\1-install-tools.log
rem Windows will ask for admin approval for some installers.
cd /d "%~dp0"
if not exist logs mkdir logs
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install-tools.ps1" > "%~dp0logs\1-install-tools.log" 2>&1
echo exit %ERRORLEVEL% >> "%~dp0logs\1-install-tools.log"
