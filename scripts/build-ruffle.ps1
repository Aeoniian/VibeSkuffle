# Builds Mugetsu 1.4.0 (performance-tuned Ruffle) plus the Skua bridge (patches\skua.patch).
param([switch]$NoPgo)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User') + ";$env:USERPROFILE\.cargo\bin"
# Keep patch files and sources byte-exact (Git for Windows would otherwise switch them to CRLF).
$env:GIT_CONFIG_PARAMETERS = "'core.autocrlf=false'"
$env:RUSTUP_TOOLCHAIN = '1.99.0'

$mugetsu = Join-Path $root 'mugetsu'
if (-not (Test-Path (Join-Path $mugetsu '.git'))) {
    Write-Host "== Downloading Mugetsu 1.4.0 source"
    git clone -q --depth 1 --branch v1.4.0 https://github.com/mugetsu-aqw/mugetsu.git $mugetsu
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
}
$source = Join-Path $mugetsu 'source'
Copy-Item -Force (Join-Path $root 'patches\skua.patch') (Join-Path $source 'patches\skua.patch')

# Mugetsu's build script, with one more step: apply skua.patch after Mugetsu's own patch.
$script = Get-Content -Raw (Join-Path $source 'build.ps1')
$anchor = "Run git @('-C', `$ruffle, 'apply', '--whitespace=nowarn', (Join-Path `$root 'patches\ruffle.patch'))"
if (-not $script.Contains($anchor)) { throw "build.ps1 changed; can't find where to add skua.patch" }
$script = $script.Replace($anchor, $anchor + "`r`nRun git @('-C', `$ruffle, 'apply', '--whitespace=nowarn', (Join-Path `$root 'patches\skua.patch'))")
$patched = Join-Path $source 'build-skua.ps1'
Set-Content -Path $patched -Value $script -Encoding UTF8

Write-Host "== Building (this takes a while)"
$started = Get-Date
if ($NoPgo) { & $patched -NoPgo } else { & $patched }
Write-Host ("== Build took {0:N0} min" -f ((Get-Date) - $started).TotalMinutes)

$exe = Join-Path $source 'build\out\Mugetsu.exe'
if (-not (Test-Path $exe)) { throw "Mugetsu.exe wasn't built" }
$out = Join-Path $root 'out\ruffle'
New-Item -ItemType Directory -Force $out | Out-Null
Copy-Item -Force $exe $out
Copy-Item -Force -Recurse (Join-Path $source 'release\*') $out
Write-Host "== Built $out\Mugetsu.exe"
