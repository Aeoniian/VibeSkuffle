# Installs the tools the two builds need, skipping what's already installed.
$ErrorActionPreference = 'Continue'
function Have($cmd) { [bool](Get-Command $cmd -ErrorAction SilentlyContinue) }
function Install-Pkg($id, [string[]]$extra = @()) {
    Write-Host "== winget install $id"
    winget.exe install --id $id -e --accept-package-agreements --accept-source-agreements --disable-interactivity @extra
}
function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

if (-not (Have git)) { Install-Pkg 'Git.Git' } else { Write-Host "git: ok" }

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vc = if (Test-Path $vswhere) { & $vswhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath } else { $null }
if (-not $vc) {
    # Rust on Windows needs Microsoft's C++ linker and Windows SDK.
    Install-Pkg 'Microsoft.VisualStudio.2022.BuildTools' @('--override', '--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended')
} else { Write-Host "C++ build tools: ok ($vc)" }

if (-not (Have rustup)) { Install-Pkg 'Rustlang.Rustup' } else { Write-Host "rustup: ok" }

$javaOk = $false
if (Have java) {
    $v = (& java -version 2>&1 | Select-Object -First 1) -as [string]
    if ($v -match '"(\d+)') { $javaOk = [int]$Matches[1] -ge 17 }
}
if (-not $javaOk) { Install-Pkg 'Microsoft.OpenJDK.17' } else { Write-Host "java: ok" }

$dotnetOk = (Have dotnet) -and ((& dotnet --list-sdks) -match '^10\.')
if (-not $dotnetOk) { Install-Pkg 'Microsoft.DotNet.SDK.10' } else { Write-Host "dotnet 10: ok" }

Refresh-Path
if (-not (Have rustup)) { $env:Path += ";$env:USERPROFILE\.cargo\bin" }
Write-Host "== rustup toolchain install 1.99.0"
rustup toolchain install 1.99.0 --profile minimal
Write-Host "== done"
