@echo off
rem Overnight check: every 10 minutes logs the memory of every game window and bot to logs\memory.csv
rem (label "overnight"). Leave this window open (minimized is fine); close it in the morning.
title VibeSkuffle overnight monitor - close in the morning
:loop
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\measure-memory.ps1" -Label overnight
echo %time% logged
timeout /t 600 /nobreak >nul
goto loop
