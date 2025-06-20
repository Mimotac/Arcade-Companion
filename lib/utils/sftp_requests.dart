import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'preferences_requests.dart';

class SFTPRequests {
  final PreferencesRequests _loadPrefs = PreferencesRequests();
  final List<String> _excludeFormatList = [
    ".txt",
    ".sub",
    ".sav",
    ".ccd",
    ".raw",
    ".fs",
    ".keep",
    ".disabled",
    ".xml",
    ".p2k",
    ".sdlpop",
    ".pygame",
    ".core",
  ];
  final List<String> _excludeList = [
    ".",
    "..",
    "manuals",
    "data",
    "gamelink",
    "recalbox-tic80",
    "naomi.zip",
    "skns.zip",
    "neogeo.zip",
    "pgm.zip",
    "prboom.wad",
    "awbios.zip",
    "videos",
    "acpsx.zip",
    "cpzn1.zip",
    "cpzn2.zip",
    "cvs.zip",
    "decocass.zip",
    "konamigx.zip",
    "megaplay.zip",
    "megatech.zip",
    "nss.zip",
    "playch10.zip",
    "stvbios.zip",
    "taitotz.zip",
    "tps.zip",
    "mame2003",
    "pygun",
    "filters",
    "gfx",
    "maps",
    "sfx",
    "tours",
    "worlds",
    "retrotrivia",
    "game-musics",
    "music",
    "images",
    "main",
  ];

  String _systemChoice(String system) {
    String route;

    switch (system) {
      case "Recalbox":
        {
          route = "/recalbox/share/";
        }
        break;
      case "Batocera":
        {
          route = "/media/SHARE/";
        }
        break;
      case "RetroPie":
        {
          route = "/home/pi/RetroPie/";
        }
        break;
      case "Lakka":
        {
          route = "/storage/";
        }
        break;
      default:
        {
          route = "/";
        }
        break;
    }
    return route;
  }

  Future<List<String>?> loadSystems() async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    List<String> results = [];

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );

      SftpClient sftp = await client.sftp();
      List<SftpName> files = await sftp
          .listdir("${_systemChoice(identifiers[0])}roms")
          .timeout(const Duration(seconds: 10));

      for (final element in files) {
        if (element.filename != "odcommander" &&
            element.filename != "240ptestsuite" &&
            element.filename != "ports" &&
            element.filename != "." &&
            element.filename != "..") {
          results.add(element.filename);
        }
      }
      results.sort();

      client.close();
      await client.done;
      return results;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>?> loadRoms(String? system) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    List<String> results = [];

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );
      SftpClient sftp = await client.sftp();
      List<SftpName> files = await sftp
          .listdir("${_systemChoice(identifiers[0])}roms/$system")
          .timeout(const Duration(seconds: 10));

      for (final element in files) {
        if (!_excludeList.any((name) => name == element.filename) &&
            !_excludeFormatList.any(element.filename.contains)) {
          results.add(element.filename);
        }
      }
      results.sort();

      client.close();
      await client.done;
      return results;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>?> loadBin() async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    List<String> results = [];

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );

      SftpClient sftp = await client.sftp();
      List<SftpName> files = await sftp
          .listdir(_systemChoice(identifiers[0]))
          .timeout(const Duration(seconds: 10));

      if (!files.any((element) => element.filename == "bin")) {
        await sftp
            .mkdir("${_systemChoice(identifiers[0])}bin")
            .timeout(const Duration(seconds: 10));
      }

      files = await (sftp
          .listdir("${_systemChoice(identifiers[0])}bin")
          .timeout(const Duration(seconds: 10)));

      for (var element in files) {
        if (!(element.filename == ".") && !(element.filename == "..")) {
          results.add(element.filename);
        }
      }
      results.sort();

      client.close();
      await client.done;
      return results;
    } catch (e) {
      return null;
    }
  }

  Future<bool> moveToBin(String? rom, String? system) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );

      List<Map<String, String>> myPairs = [];
      String? jsonString = await _loadPrefs.loadRomsPreferences('myList');
      if (jsonString != null) {
        myPairs = jsonDecode(jsonString)
            .map((item) => Map<String, String>.from(item))
            .toList()
            .cast<Map<String, String>>();
      }
      myPairs.add({"rom": rom!, "folder": system!});

      _loadPrefs.setRomsPreferences('myList', jsonEncode(myPairs));

      SftpClient sftp = await client.sftp();
      List<SftpName> files = await sftp
          .listdir(_systemChoice(identifiers[0]))
          .timeout(const Duration(seconds: 10));

      if (!files.any((element) => element.filename == "bin")) {
        await sftp
            .mkdir("${_systemChoice(identifiers[0])}bin")
            .timeout(const Duration(seconds: 10));
      }
      await sftp
          .rename(
            "${_systemChoice(identifiers[0])}roms/$system/$rom",
            "${_systemChoice(identifiers[0])}bin/$rom",
          )
          .timeout(const Duration(seconds: 10));

      client.close();
      await client.done;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> undo(String? rom, String? system) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );

      List<Map<String, String>> myPairs = [];
      String? jsonString = await _loadPrefs.loadRomsPreferences('myList');

      if (jsonString != null) {
        myPairs = jsonDecode(jsonString)
            .map((item) => Map<String, String>.from(item))
            .toList()
            .cast<Map<String, String>>();
      }

      myPairs.removeWhere((item) => item.containsValue(rom));

      _loadPrefs.setRomsPreferences('myList', jsonEncode(myPairs));

      SftpClient sftp = await client.sftp();

      await sftp
          .rename(
            "${_systemChoice(identifiers[0])}bin/$rom",
            "${_systemChoice(identifiers[0])}roms/$system/$rom",
          )
          .timeout(const Duration(seconds: 10));

      client.close();
      await client.done;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRom(String? rom) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );
      List<Map<String, String>> myPairs = [];
      String? jsonString = await _loadPrefs.loadRomsPreferences('myList');

      if (jsonString != null) {
        myPairs = jsonDecode(jsonString)
            .map((item) => Map<String, String>.from(item))
            .toList()
            .cast<Map<String, String>>();
      }

      myPairs.removeWhere((item) => item.containsValue(rom));

      _loadPrefs.setRomsPreferences('myList', jsonEncode(myPairs));

      SftpClient sftp = await client.sftp();

      await sftp
          .remove("${_systemChoice(identifiers[0])}bin/$rom")
          .timeout(const Duration(seconds: 5));

      client.close();
      await client.done;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteRoms(List? romsList) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );

      SftpClient sftp = await client.sftp();

      for (int i = 0; i < romsList!.length; i++) {
        await sftp
            .remove("${_systemChoice(identifiers[0])}bin/${romsList[i]}")
            .timeout(const Duration(seconds: 10));
      }

      _loadPrefs.removeRomsPreferences('myList');
      client.close();
      await client.done;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveRom(String rom) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();

    try {
      SSHClient client = SSHClient(
        await SSHSocket.connect(identifiers[1], int.parse(identifiers[2])),
        username: identifiers[3],
        onPasswordRequest: () => identifiers[4],
      );

      List<Map<String, String>> myPairs = [];
      List<String?> romsList = [];
      String? jsonString = await _loadPrefs.loadRomsPreferences('myList');

      if (jsonString != null) {
        myPairs = jsonDecode(jsonString)
            .map((item) => Map<String, String>.from(item))
            .toList()
            .cast<Map<String, String>>();
      }

      for (var pair in myPairs) {
        if (pair.containsValue(rom)) {
          romsList.add(pair["folder"]);
        }
      }

      myPairs.removeWhere((item) => item.containsValue(rom));

      _loadPrefs.setRomsPreferences('myList', jsonEncode(myPairs));
      SftpClient sftp = await client.sftp();
      await sftp
          .rename(
            "${_systemChoice(identifiers[0])}bin/$rom",
            "${_systemChoice(identifiers[0])}roms/${romsList[0]}/$rom",
          )
          .timeout(const Duration(seconds: 5));
      client.close();
      await client.done;
      return true;
    } catch (e) {
      return false;
    }
  }
}
