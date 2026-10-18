@echo off
rem Logs how much GPU memory (VRAM) each game window uses to logs\vram.txt
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\measure-vram.ps1" > "%~dp0logs\vram-run.txt" 2>&1
