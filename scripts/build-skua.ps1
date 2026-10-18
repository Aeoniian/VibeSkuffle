# Builds VibeSkua with the Ruffle backend (patches\vibeskua-ruffle.patch) and copies the Ruffle
# player in, so VibeSkua\Build\ is ready to run.
# Native tools (git) write progress to stderr, which 'Stop' would treat as failure; exit codes are checked instead.
$ErrorActionPreference = 'Continue'
$root = Split-Path $PSScriptRoot -Parent
$env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
$env:GIT_CONFIG_PARAMETERS = "'core.autocrlf=false'"
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$commit = '239b20da5f706725aeec201d887ad3ada125ccc5'   # VibeSkua version the patch was made against

$skua = Join-Path $root 'VibeSkua'
if (-not (Test-Path (Join-Path $skua '.git'))) {
    Write-Host "== Downloading VibeSkua"
    git clone -q https://github.com/NinjaXz/VibeSkua.git $skua
    if ($LASTEXITCODE -ne 0) { throw "git clone failed" }
    git -C $skua checkout -q -b ruffle $commit
    if ($LASTEXITCODE -ne 0) { throw "git checkout failed" }
}

$patch = Join-Path $root 'patches\vibeskua-ruffle.patch'
git -C $skua apply --reverse --check $patch 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "== Ruffle patch already applied"
} else {
    # An older copy of the patch may be applied: undo local changes to the patched files first.
    git -C $skua checkout -q -- .
    git -C $skua clean -q -f -- Skua.App.Avalonia/Flash
    # Files the patch adds are untracked; remove them so it can add them again.
    foreach ($m in Select-String -Path $patch -Pattern '^diff --git a/(\S+) b/') {
        $file = $m.Matches[0].Groups[1].Value
        git -C $skua ls-files --error-unmatch -- $file 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) { Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path $skua $file) }
    }
    Write-Host "== Applying Ruffle patch"
    git -C $skua apply --whitespace=nowarn $patch
    if ($LASTEXITCODE -ne 0) { throw "git apply failed" }
}

# This fork is named VibeSkuffle; clear out the old VibeSkua-named files from earlier builds.
$oldBuild = Join-Path $skua 'Build'
foreach ($name in 'VibeSkua.exe', 'VibeSkua.dll', 'VibeSkua.runtimeconfig.json', 'VibeSkua.deps.json',
                  'VibeSkua.Manager.exe', 'VibeSkua.Manager.dll', 'VibeSkua.Manager.runtimeconfig.json') {
    Remove-Item -Force -ErrorAction SilentlyContinue (Join-Path $oldBuild $name)
}

# Close only the VibeSkuffle build in this folder (clients, Manager, Mugetsu); a normal VibeSkua is left alone.
$buildDir = (Join-Path $skua 'Build').ToLower()
Get-CimInstance Win32_Process -Filter "name='VibeSkuffle.exe' or name='VibeSkuffle.Manager.exe' or name='Mugetsu.exe'" |
    Where-Object { $_.ExecutablePath -and $_.ExecutablePath.ToLower().StartsWith($buildDir) } |
    ForEach-Object { Write-Host "Closing $($_.Name) ($($_.ProcessId))"; Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
Start-Sleep -Seconds 1

Write-Host "== Building VibeSkuffle"
Push-Location $skua
try {
    # VibeSkua's BuildProject.bat starts by force-closing every running VibeSkua (taskkill), which
    # would also kill any normal VibeSkua that's farming. Use a copy without those lines.
    $bat = Get-Content -Raw 'BuildProject.bat'
    $bat = ($bat -split "`r?`n" | Where-Object { $_ -notmatch '^\s*taskkill\b' }) -join "`r`n"
    Set-Content -Path 'BuildProject-nokill.bat' -Value $bat -Encoding ASCII
    # The build clears Build\; keep the user's game-window options file.
    $opts = Join-Path $skua 'Build\ruffle-options.txt'
    $savedOpts = if (Test-Path $opts) { Get-Content -Raw $opts } else { $null }
    cmd /c "echo.| BuildProject-nokill.bat nopause"
    $buildExit = $LASTEXITCODE
    if ($null -ne $savedOpts) { Set-Content -Path $opts -Value $savedOpts -NoNewline }
    $global:LASTEXITCODE = $buildExit
    if ($LASTEXITCODE -ne 0) { throw "BuildProject.bat failed ($LASTEXITCODE)" }
} finally { Pop-Location }

$build = Join-Path $skua 'Build'
$ruffle = Join-Path $root 'out\ruffle'
if (Test-Path (Join-Path $ruffle 'Mugetsu.exe')) {
    New-Item -ItemType Directory -Force (Join-Path $build 'ruffle') | Out-Null
    Copy-Item -Force -Recurse (Join-Path $ruffle '*') (Join-Path $build 'ruffle')
    Write-Host "== Copied the Ruffle player into $build\ruffle"
} else {
    Write-Host "!! out\ruffle\Mugetsu.exe not found: run 2-build-ruffle.bat first"
}
Set-Content -Path (Join-Path $build 'use-ruffle.txt') -Value 'Delete this file to play with Flash again.'
Write-Host "== Done: $build\VibeSkuffle.exe and $build\VibeSkuffle.Manager.exe"
