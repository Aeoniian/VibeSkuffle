"""Build a clean portable release from Build/. No account settings or runtime logs are copied."""
import argparse, hashlib, json, re, shutil, subprocess, sys, zipfile
from pathlib import Path

def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('version')
    parser.add_argument('--root',type=Path,default=Path(__file__).resolve().parents[1])
    parser.add_argument('--templates',type=Path)
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    if not re.fullmatch(r'v\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?',args.version): parser.error('Invalid release version')
    root=args.root.resolve(); build=root/'VibeSkua/Build'; templates=args.templates or root/'release-template'
    package_name=f'VibeSkuffle-{args.version}-win-x64'; stage=root/'out/release-staging'/package_name
    if stage.exists(): raise SystemExit('Staging folder already exists: '+str(stage))
    stage.mkdir(parents=True)
    def copy(source,relative):
        target=stage/relative; target.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(source,target)
    names=['VibeSkuffle.exe','VibeSkuffle.dll','VibeSkuffle.deps.json','VibeSkuffle.runtimeconfig.json',
           'VibeSkuffle.Manager.exe','VibeSkuffle.Manager.dll','VibeSkuffle.Manager.runtimeconfig.json',
           'VibeSkuffle.Manager.deps.json','Velopack.dll','skua.swf','use-ruffle.txt','client-update.ps1',
           'AdvancedSkills.json','QuestData.json','ScriptDates.json']
    for name in names:
        folder='Skua.Manager.Avalonia/bin/Release/net10.0' if name.startswith('VibeSkuffle.Manager') or name=='client-update.ps1' else 'Skua.App.Avalonia/bin/Release/net10.0-windows'
        fresh=root/'VibeSkua'/folder/name
        source=fresh if fresh.is_file() else build/name
        if source.is_file(): copy(source,name)
    for folder,extensions in [('Assemblies',{'.dll','.xml','.cs'}),('FFDec',{'.bat','.jar','.txt','.md','.license'})]:
        for file in (build/folder).rglob('*'):
            if file.is_file() and file.suffix.lower() in extensions:
                source=file
                if folder=='Assemblies':
                    relative=file.relative_to(build/folder)
                    for bin_folder in ['Skua.App.Avalonia/bin/Release/net10.0-windows','Skua.Manager.Avalonia/bin/Release/net10.0']:
                        fresh=root/'VibeSkua'/bin_folder/relative
                        if fresh.is_file(): source=fresh; break
                copy(source,file.relative_to(build))
    # Include newly added dependencies even when the local Build folder predates them.
    for bin_folder in ['Skua.Manager.Avalonia/bin/Release/net10.0','Skua.App.Avalonia/bin/Release/net10.0-windows']:
        for file in (root/'VibeSkua'/bin_folder).glob('*.dll'):
            if file.name not in ('VibeSkuffle.dll','VibeSkuffle.Manager.dll'):
                copy(file,Path('Assemblies')/file.name)
    for name,project in [('ButlerV5.dll','Skua.Plugin.ButlerV5'),('Skua.Plugin.DailyTracker.dll','Skua.Plugin.DailyTracker'),('Skua.Plugin.Cosmetics.dll','Skua.Plugin.Cosmetics')]:
        fresh=root/'VibeSkua'/project/'bin/Release/net10.0'/name
        copy(fresh if fresh.is_file() else build/'plugins'/name,Path('plugins')/name)
    copy(build/'ruffle/Mugetsu.exe','ruffle/Mugetsu.exe')
    for file in (build/'ruffle/LICENSES').rglob('*'):
        if file.is_file(): copy(file,file.relative_to(build))
    copy(build/'ruffle/THIRD-PARTY-NOTICES.txt','ruffle/THIRD-PARTY-NOTICES.txt')
    copy(root/'mugetsu/LICENSE','ruffle/LICENSE-GPL-3.0.txt')
    for source,target in [('README.txt','README.txt'),('LICENSES-VibeSkuffle.txt','LICENSES-VibeSkuffle.txt'),('ruffle-README.txt','ruffle/README.txt')]:
        text=(templates/source).read_text(encoding='utf-8').replace('__REPO__','Aeoniian/VibeSkuffle').replace('v1.0.0-beta',args.version)
        (stage/target).write_text(text,encoding='utf-8',newline='\r\n')
    (stage/'ruffle-options.txt').write_text('# Shared game-window defaults. Per-account choices can be set in VibeSkuffle.\n--graphics dx12\n',encoding='utf-8')
    base_info=(root/'upstream-base.txt').read_text().splitlines()
    upstream_version=base_info[0]
    base=base_info[1]
    patch_hash=hashlib.sha256((root/'patches/vibeskua-ruffle.patch').read_bytes()).hexdigest()
    (stage/'build-info.txt').write_text(f'VibeSkuffle {args.version}\n{upstream_version} · upstream {base}\nMugetsu 1.5.1 with VibeSkuffle bridge\nFork patch SHA256 {patch_hash}\n',encoding='utf-8')
    subprocess.run([sys.executable,str(root/'scripts/make-update-manifest.py'),str(stage),args.version],check=True)
    manifest=json.loads((stage/'vibeskuffle-update.json').read_text())
    for required in ['VibeSkuffle.exe','VibeSkuffle.Manager.exe','ruffle/Mugetsu.exe','plugins/ButlerV5.dll','plugins/Skua.Plugin.DailyTracker.dll','plugins/Skua.Plugin.Cosmetics.dll','client-update.ps1']:
        if required not in manifest['Files']: raise RuntimeError('Missing release application file: '+required)
    output=args.output or root/'out/releases'; output.mkdir(parents=True,exist_ok=True)
    archive=output/(package_name+'.zip')
    if archive.exists(): raise SystemExit('Archive already exists: '+str(archive))
    with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as package:
        for file in sorted(stage.rglob('*')):
            if file.is_file(): package.write(file,Path(package_name)/file.relative_to(stage))
    digest=hashlib.sha256(archive.read_bytes()).hexdigest()
    checksum=output/(package_name+'.zip.sha256'); checksum.write_text(f'{digest}  {archive.name}\n',encoding='ascii')
    print(json.dumps({'archive':str(archive),'sha256':digest,'bytes':archive.stat().st_size,'application_files':len(manifest['Files'])},indent=2))

if __name__=='__main__': main()
