"""Run after packaging: python make-update-manifest.py <package-folder> <release-version>."""
import hashlib
import json
import re
import sys
from pathlib import Path

def application_file(path):
    value=path.lower().replace('\\','/')
    if any(part in ('','.','..') or ':' in part for part in value.split('/')): return False
    if value.startswith('assemblies/'): return value.endswith(('.dll','.so','.dylib'))
    if value.startswith('ruffle/'): return value=='ruffle/mugetsu.exe' or value.endswith('.dll')
    if value.startswith('plugins/'): return value in ('plugins/butlerv5.dll','plugins/dailytracker.dll','plugins/skua.plugin.dailytracker.dll','plugins/skua.plugin.cosmetics.dll')
    return bool(re.fullmatch(r'vibeskuffle(?:\.manager)?\.(?:exe|dll|deps\.json|runtimeconfig\.json)',value)) or value in {
        'skua.swf','use-ruffle.txt','velopack.dll','build-info.txt','release-version.txt','client-update.ps1'}

if __name__=='__main__':
    directory=Path(sys.argv[1]).resolve()
    version=sys.argv[2]
    (directory/'release-version.txt').write_text(version+'\n',encoding='utf-8')
    files={p.relative_to(directory).as_posix():hashlib.sha256(p.read_bytes()).hexdigest()
           for p in sorted(directory.rglob('*')) if p.is_file() and application_file(p.relative_to(directory).as_posix())}
    (directory/'vibeskuffle-update.json').write_text(json.dumps({'Version':version,'Files':files},indent=2)+'\n',encoding='utf-8')
    print(f'Update manifest: {version}, {len(files)} application files; scripts and user settings excluded.')
