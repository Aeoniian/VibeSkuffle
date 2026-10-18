@echo off
rem Copies the game windows' crash reports (skua-crash-*.log) and recent logs, plus Windows crash reports, to logs\
cd /d "%~dp0"
if not exist logs\ruffle mkdir logs\ruffle
copy /y "%LOCALAPPDATA%\ruffle\log\skua-crash-*.log" "%~dp0logs\ruffle\" > nul 2>&1
powershell -NoProfile -Command "Get-ChildItem $env:LOCALAPPDATA\ruffle\log\skua-*.log | Sort-Object LastWriteTime | Select-Object -Last 12 | Copy-Item -Destination '%~dp0logs\ruffle' -Force" > nul 2>&1
call "%~dp0dump-crash.bat"
