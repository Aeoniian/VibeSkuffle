@echo off
rem Logs memory of the game windows to logs\memory.csv
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\measure-memory.ps1"
