@echo off
rem Saves the latest .NET / application crash reports from the Windows event log to logs\crash.log
cd /d "%~dp0"
if not exist logs mkdir logs
> "%~dp0logs\crash.log" (
  echo === .NET Runtime
  wevtutil qe Application /c:3 /rd:true /f:text /q:"*[System[Provider[@Name='.NET Runtime']]]"
  echo === Application Error
  wevtutil qe Application /c:3 /rd:true /f:text /q:"*[System[Provider[@Name='Application Error']]]"
) 2>&1
