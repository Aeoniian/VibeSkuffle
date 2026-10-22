# Notice

VibeSkuffle combines and modifies these projects:

| Project | License | What's used |
|---|---|---|
| [VibeSkua](https://github.com/NinjaXz/VibeSkua) by NinjaXz (from [Skua](https://github.com/auqw/skua)) | MIT (as stated in VibeSkua's README) | The bot, Manager and plugins, modified by `patches/vibeskua-ruffle.patch` |
| [Mugetsu](https://github.com/mugetsu-aqw/mugetsu) | GPL-3.0 | The game player, modified by `patches/skua.patch` |
| [Ruffle](https://github.com/ruffle-rs/ruffle) | MIT or Apache-2.0 | Mugetsu is built on it ([licenses/Ruffle-LICENSE.md](licenses/Ruffle-LICENSE.md)) |
| [JPEXS FFDec](https://github.com/jindrapetrik/jpexs-decompiler) | GPL-3.0 | Bundled with VibeSkua (`FFDec/`), unchanged |

**Modified Mugetsu.** The `ruffle/Mugetsu.exe` in VibeSkuffle releases is a modified version of Mugetsu
v1.5.1 (changes made 2026-10). Its complete source is Mugetsu v1.5.1
(`https://github.com/mugetsu-aqw/mugetsu`, tag `v1.5.1`) plus `patches/skua.patch` in this repository;
`2-build-ruffle.bat` rebuilds it. Released under GPL-3.0 (see `LICENSE`). It is not an official Mugetsu
release, so please don't report its problems to the Mugetsu author.

This repository as a whole is distributed under GPL-3.0. The MIT-licensed parts keep their MIT terms.

Not affiliated with Artix Entertainment, Ruffle, Mugetsu, Skua or VibeSkua. AdventureQuest Worlds and
related names are trademarks of Artix Entertainment.
