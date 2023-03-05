import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRequests {
  final String _themeKey = 'theme';
  final String _userKey = 'user';
  late SharedPreferences _preferences;

  Future<void> loadPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setUserPreferences(List<String> identifiers) async {
    await loadPreferences();
    _preferences.setStringList(_userKey, identifiers);
  }

  void setListPreferences(String key, List<String> list) async {
    await loadPreferences();
    _preferences.setStringList(key, list);
  }

  void setRomsPreferences(String key, String list) async {
    await loadPreferences();
    _preferences.setString(key, list);
  }

  Future<List<String>> loadUserPreferences() async {
    await loadPreferences();
    List<String> identifiers = _preferences.getStringList(_userKey) ?? [];
    return identifiers;
  }

  void setTheme(bool? theme) async {
    await loadPreferences();
    _preferences.setBool(_themeKey, theme!);
  }

  Future<bool?> loadTheme() async {
    await loadPreferences();
    return _preferences.getBool(_themeKey);
  }

  Future<List<String>?> loadListPreferences(String key) async {
    await loadPreferences();
    return _preferences.getStringList(key);
  }

  Future<String?> loadRomsPreferences(String key) async {
    await loadPreferences();
    return _preferences.getString(key);
  }

  void removeRomsPreferences(String rom) async {
    await loadPreferences();
    _preferences.remove(rom);
  }
}
