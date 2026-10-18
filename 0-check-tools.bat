@echo off
rem Lists which build tools are installed. Output: logs\0-check-tools.log
cd /d "%~dp0"
if not exist logs mkdir logs
set "LOG=%~dp0logs\0-check-tools.log"
> "%LOG%" (
  echo === %date% %time%
  echo --- git
  git --version
  echo --- rust
  rustup --version
  rustup toolchain list
  echo --- java
  java -version 2^>^&1
  echo --- dotnet
  dotnet --list-sdks
  echo --- visual studio c++ build tools
  "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  echo --- winget
  winget --version
  echo --- machine
  powershell -NoProfile -Command "Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors | Format-List; Get-CimInstance Win32_VideoController | Select-Object Name,DriverVersion | Format-List; 'RAM GB: ' + [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory/1GB); Get-PSDrive (Split-Path -Qualifier '%~dp0').TrimEnd(':') | Select-Object @{n='FreeGB';e={[math]::Round($_.Free/1GB)}} | Format-List"
  echo === DONE
) 2>&1
