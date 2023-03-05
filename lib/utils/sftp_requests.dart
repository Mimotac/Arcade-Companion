import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ssh2/ssh2.dart';
import 'preferences_requests.dart';

class SFTPRequests {
  final PreferencesRequests _loadPrefs = PreferencesRequests();
  final List<String> _excludeList = [
    ".txt",
    ".sub",
    ".ccd",
    ".raw",
    ".fs",
    ".xml",
    ".keep",
    ".disabled",
    ".sdlpop",
    ".pygame",
    "manuals",
    "data",
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
    "images"
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
      case "Retropie":
        {
          route = "/home/pi/RetroPie/";
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

  SSHClient _loadClient(List<String> identifiers) {
    return SSHClient(
      host: identifiers[1],
      port: int.parse(identifiers[2]),
      username: identifiers[3],
      passwordOrKey: identifiers[4],
    );
  }

  Future<List<String>?> loadSystems() async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 5));

      if (status == "session_connected") {
        status = await client.connectSFTP().timeout(const Duration(seconds: 5));

        if (status == "sftp_connected") {
          List? data;
          List<String> results = [];

          data = await (client
              .sftpLs("${_systemChoice(identifiers[0])}roms")
              .timeout(const Duration(seconds: 5)));

          if (data != null) {
            for (var element in data) {
              if (element["filename"] != "odcommander") {
                results.add(element["filename"]);
              }
            }
            results.sort();
          } else {
            return null;
          }
          client.disconnect();
          return results;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on PlatformException {
      return null;
    } on TimeoutException {
      return null;
    }
  }

  Future<List<String>?> loadRoms(String? system) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 10));
      if (status == "session_connected") {
        status =
            await client.connectSFTP().timeout(const Duration(seconds: 10));
        if (status == "sftp_connected") {
          List? data;
          List<String> results = [];

          data = await (client
              .sftpLs("${_systemChoice(identifiers[0])}roms/$system")
              .timeout(const Duration(seconds: 10)));

          if (data != null) {
            for (var element in data) {
              if (!_excludeList.any(element["filename"].contains)) {
                results.add(element["filename"]);
              }
            }
            results.sort();
          } else {
            return null;
          }
          client.disconnect();
          return results;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on PlatformException {
      return null;
    } on TimeoutException {
      return null;
    }
  }

  Future<List<String>?> loadBin() async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 10));
      if (status == "session_connected") {
        status =
            await client.connectSFTP().timeout(const Duration(seconds: 10));
        if (status == "sftp_connected") {
          List? data;
          List<String> results = [];
          List? test = await client
              .sftpLs(_systemChoice(identifiers[0]))
              .timeout(const Duration(seconds: 10));

          if (test != null) {
            if (!test.any((element) => element["filename"] == "bin")) {
              await client
                  .sftpMkdir("${_systemChoice(identifiers[0])}bin")
                  .timeout(const Duration(seconds: 10));
            }
          } else {
            return null;
          }
          data = await (client
              .sftpLs("${_systemChoice(identifiers[0])}bin")
              .timeout(const Duration(seconds: 10)));
          if (data != null) {
            for (var element in data) {
              results.add(element["filename"]);
            }
            results.sort();
          } else {
            return null;
          }
          client.disconnect();
          return results;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on PlatformException {
      return null;
    } on TimeoutException {
      return null;
    }
  }

  Future<bool> moveToBin(String? rom, String? system) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 5));

      if (status == "session_connected") {
        status = await client.connectSFTP().timeout(const Duration(seconds: 5));
        if (status == "sftp_connected") {
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

          List? test = await client
              .sftpLs(_systemChoice(identifiers[0]))
              .timeout(const Duration(seconds: 5));

          if (test != null) {
            if (!test.any((element) => element["filename"] == "bin")) {
              await client
                  .sftpMkdir("${_systemChoice(identifiers[0])}bin")
                  .timeout(const Duration(seconds: 5));
            }
          } else {
            return false;
          }
          await client
              .sftpRename(
                oldPath: "${_systemChoice(identifiers[0])}roms/$system/$rom",
                newPath: "${_systemChoice(identifiers[0])}bin/$rom",
              )
              .timeout(const Duration(seconds: 5));
          client.disconnect();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  Future<bool> undo(String? rom, String? system) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 5));
      if (status == "session_connected") {
        status = await client.connectSFTP().timeout(const Duration(seconds: 5));
        if (status == "sftp_connected") {
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

          await client
              .sftpRename(
                oldPath: "${_systemChoice(identifiers[0])}bin/$rom",
                newPath: "${_systemChoice(identifiers[0])}roms/$system/$rom",
              )
              .timeout(const Duration(seconds: 5));
          client.disconnect();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  Future<bool> deleteRom(String? rom) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 5));
      if (status == "session_connected") {
        status = await client.connectSFTP().timeout(const Duration(seconds: 5));
        if (status == "sftp_connected") {
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

          await client
              .sftpRm("${_systemChoice(identifiers[0])}bin/$rom")
              .timeout(const Duration(seconds: 5));
          client.disconnect();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  Future<bool> deleteRoms(List? romsList) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 10));
      if (status == "session_connected") {
        status =
            await client.connectSFTP().timeout(const Duration(seconds: 10));
        if (status == "sftp_connected") {
          for (int i = 0; i < romsList!.length; i++) {
            await client
                .sftpRm("${_systemChoice(identifiers[0])}bin/${romsList[i]}")
                .timeout(const Duration(seconds: 10));
          }

          _loadPrefs.removeRomsPreferences('myList');
          client.disconnect();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  Future<bool> saveRom(String rom) async {
    List<String> identifiers = await _loadPrefs.loadUserPreferences();
    SSHClient client = _loadClient(identifiers);

    try {
      String? status =
          await client.connect().timeout(const Duration(seconds: 5));
      if (status == "session_connected") {
        status = await client.connectSFTP().timeout(const Duration(seconds: 5));
        if (status == "sftp_connected") {
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

          await client
              .sftpRename(
                oldPath: "${_systemChoice(identifiers[0])}bin/$rom",
                newPath:
                    "${_systemChoice(identifiers[0])}roms/${romsList[0]}/$rom",
              )
              .timeout(const Duration(seconds: 5));
          client.disconnect();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    } on TimeoutException {
      return false;
    }
  }
}
