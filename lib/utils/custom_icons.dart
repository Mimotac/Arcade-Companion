import 'package:flutter/material.dart';

class CustomIcons {
  CustomIcons._();

  static const String? _fontPackage = null;
  static const String _ipLabel = 'Ip';
  static const String _portLabel = 'Port';
  static const String _portsLabel = 'Ports';
  static const String _logoLabel = 'Logo';
  static const String _arcadeLabel = 'Arcade';
  static const String _miscLabel = 'Misc';
  static const String _retropieLabel = 'Retropie';
  static const String _recalboxLabel = 'Recalbox';
  static const String _batoceraLabel = 'Batocera';
  static const String _homeLabel = 'Home';
  static const String _portableLabel = 'Portable';
  static const String _computerLabel = 'Computer';

  static const IconData ip =
      IconData(0xe800, fontFamily: _ipLabel, fontPackage: _fontPackage);
  static const IconData port =
      IconData(0xe801, fontFamily: _portLabel, fontPackage: _fontPackage);
  static const IconData ports =
      IconData(0xe804, fontFamily: _portsLabel, fontPackage: _fontPackage);
  static const IconData logo =
      IconData(0xe801, fontFamily: _logoLabel, fontPackage: _fontPackage);
  static const IconData arcade =
      IconData(0xe803, fontFamily: _arcadeLabel, fontPackage: _fontPackage);
  static const IconData misc =
      IconData(0xe802, fontFamily: _miscLabel, fontPackage: _fontPackage);
  static const IconData retropie =
      IconData(0xe800, fontFamily: _retropieLabel, fontPackage: _fontPackage);
  static const IconData recalbox =
      IconData(0xe801, fontFamily: _recalboxLabel, fontPackage: _fontPackage);
  static const IconData batocera =
      IconData(0xe802, fontFamily: _batoceraLabel, fontPackage: _fontPackage);
  static const IconData home =
      IconData(0xe801, fontFamily: _homeLabel, fontPackage: _fontPackage);
  static const IconData portable =
      IconData(0xe805, fontFamily: _portableLabel, fontPackage: _fontPackage);
  static const IconData computer =
      IconData(0xe801, fontFamily: _computerLabel, fontPackage: _fontPackage);

  static const Map<String, IconData> imageMap = {
    "mame": CustomIcons.arcade,
    "fbneo": CustomIcons.arcade,
    "daphne": CustomIcons.arcade,
    "model1": CustomIcons.arcade,
    "model2": CustomIcons.arcade,
    "model3": CustomIcons.arcade,
    "naomi": CustomIcons.arcade,
    "naomi2": CustomIcons.arcade,
    "triforce": CustomIcons.arcade,
    "atomiswave": CustomIcons.arcade,
    "channelf": CustomIcons.home,
    "atari2600": CustomIcons.home,
    "odyssey2": CustomIcons.home,
    "astrocde": CustomIcons.home,
    "apfm1000": CustomIcons.home,
    "intellivision": CustomIcons.home,
    "atari5200": CustomIcons.home,
    "colecovision": CustomIcons.home,
    "advision": CustomIcons.home,
    "vectrex": CustomIcons.home,
    "crvision": CustomIcons.home,
    "arcadia": CustomIcons.home,
    "nes": CustomIcons.home,
    "sg1000": CustomIcons.home,
    "videopacplus": CustomIcons.home,
    "pv1000": CustomIcons.home,
    "scv": CustomIcons.home,
    "mastersystem": CustomIcons.home,
    "fds": CustomIcons.home,
    "atari7800": CustomIcons.home,
    "socrates": CustomIcons.home,
    "pcengine": CustomIcons.home,
    "megadrive": CustomIcons.home,
    "pcenginecd": CustomIcons.home,
    "supergrafx": CustomIcons.home,
    "snes": CustomIcons.home,
    "neogeo": CustomIcons.home,
    "cdi": CustomIcons.home,
    "amigacdtv": CustomIcons.home,
    "gx4000": CustomIcons.home,
    "segacd": CustomIcons.home,
    "snes-msu1": CustomIcons.home,
    "sgb": CustomIcons.home,
    "supracan": CustomIcons.home,
    "jaguar": CustomIcons.home,
    "3do": CustomIcons.home,
    "amigacd32": CustomIcons.home,
    "sega32x": CustomIcons.home,
    "psx": CustomIcons.home,
    "pcfx": CustomIcons.home,
    "neogeocd": CustomIcons.home,
    "saturn": CustomIcons.home,
    "virtualboy": CustomIcons.home,
    "satellaview": CustomIcons.home,
    "sufami": CustomIcons.home,
    "n64": CustomIcons.home,
    "dreamcast": CustomIcons.home,
    "n64dd": CustomIcons.home,
    "ps2": CustomIcons.home,
    "gamecube": CustomIcons.home,
    "xbox": CustomIcons.home,
    "vsmile": CustomIcons.home,
    "xbox360": CustomIcons.home,
    "wii": CustomIcons.home,
    "ps3": CustomIcons.home,
    "wiiu": CustomIcons.home,
    "uzebox": CustomIcons.home,
    "pico8": CustomIcons.home,
    "tic80": CustomIcons.home,
    "lowresnx": CustomIcons.home,
    "wasm4": CustomIcons.home,
    "o2em": CustomIcons.home,
    "vc4000": CustomIcons.home,
    "gameandwatch": CustomIcons.portable,
    "lcdgames": CustomIcons.portable,
    "gb": CustomIcons.portable,
    "gb2players": CustomIcons.portable,
    "lynx": CustomIcons.portable,
    "gamegear": CustomIcons.portable,
    "gamate": CustomIcons.portable,
    "gmaster": CustomIcons.portable,
    "supervision": CustomIcons.portable,
    "megaduck": CustomIcons.portable,
    "gamecom": CustomIcons.portable,
    "gbc": CustomIcons.portable,
    "gbc2players": CustomIcons.portable,
    "ngp": CustomIcons.portable,
    "ngpc": CustomIcons.portable,
    "wswan": CustomIcons.portable,
    "wswanc": CustomIcons.portable,
    "gba": CustomIcons.portable,
    "pokemini": CustomIcons.portable,
    "nds": CustomIcons.portable,
    "psp": CustomIcons.portable,
    "3ds": CustomIcons.portable,
    "psvita": CustomIcons.portable,
    "arduboy": CustomIcons.portable,
    "gamepock": CustomIcons.portable,
    "gp32": CustomIcons.portable,
    "pdp1": CustomIcons.computer,
    "apple2": CustomIcons.computer,
    "pet": CustomIcons.computer,
    "atari800": CustomIcons.computer,
    "atom": CustomIcons.computer,
    "c20": CustomIcons.computer,
    "coco": CustomIcons.computer,
    "pc88": CustomIcons.computer,
    "ti99": CustomIcons.computer,
    "zx81": CustomIcons.computer,
    "bbc": CustomIcons.computer,
    "x1": CustomIcons.computer,
    "zxspectrum": CustomIcons.computer,
    "c64": CustomIcons.computer,
    "pc98": CustomIcons.computer,
    "fm7": CustomIcons.computer,
    "tutor": CustomIcons.computer,
    "electron": CustomIcons.computer,
    "camplynx": CustomIcons.computer,
    "msx1": CustomIcons.computer,
    "adam": CustomIcons.computer,
    "amstradcpc": CustomIcons.computer,
    "macintosh": CustomIcons.computer,
    "thomson": CustomIcons.computer,
    "cplus4": CustomIcons.computer,
    "laser310": CustomIcons.computer,
    "atarist": CustomIcons.computer,
    "msx2": CustomIcons.computer,
    "c128": CustomIcons.computer,
    "apple2gs": CustomIcons.computer,
    "archimedes": CustomIcons.computer,
    "xegs": CustomIcons.computer,
    "amiga500": CustomIcons.computer,
    "x68000": CustomIcons.computer,
    "msx2+": CustomIcons.computer,
    "fmtowns": CustomIcons.computer,
    "samcoupe": CustomIcons.computer,
    "amiga1200": CustomIcons.computer,
    "msxturbor": CustomIcons.computer,
    "abuse": CustomIcons.ports,
    "cannonball": CustomIcons.ports,
    "cavestory": CustomIcons.ports,
    "cdogs": CustomIcons.ports,
    "devilutionx": CustomIcons.ports,
    "easyrpg": CustomIcons.ports,
    "ecwolf": CustomIcons.ports,
    "eduke32": CustomIcons.ports,
    "fpinball": CustomIcons.ports,
    "fury": CustomIcons.ports,
    "gzdoom": CustomIcons.ports,
    "hcl": CustomIcons.ports,
    "hurrican": CustomIcons.ports,
    "lutro": CustomIcons.ports,
    "mrboom": CustomIcons.ports,
    "mugen": CustomIcons.ports,
    "ikemen": CustomIcons.ports,
    "openbor": CustomIcons.ports,
    "openjazz": CustomIcons.ports,
    "prboom": CustomIcons.ports,
    "pygame": CustomIcons.ports,
    "raze": CustomIcons.ports,
    "scummvm": CustomIcons.ports,
    "sdlpop": CustomIcons.ports,
    "solarus": CustomIcons.ports,
    "sonicretro": CustomIcons.ports,
    "superbroswar": CustomIcons.ports,
    "tyrquake": CustomIcons.ports,
    "xash3d_fwgs": CustomIcons.ports,
    "xrick": CustomIcons.ports,
    "vitaquake2": CustomIcons.ports,
    "zc210": CustomIcons.ports,
    "msu-md": CustomIcons.misc,
    "gong": CustomIcons.misc,
    "dos": CustomIcons.misc,
    "flash": CustomIcons.misc,
    "flatpak": CustomIcons.misc,
    "moonlight": CustomIcons.misc,
    "ports": CustomIcons.misc,
    "plugnplay": CustomIcons.misc,
    "steam": CustomIcons.misc,
    "vgmplay": CustomIcons.misc,
    "windows": CustomIcons.misc,
    "windows_installers": CustomIcons.misc,
  };
}
