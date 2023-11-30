import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keynames = 'faves';
  // static const _keyban = 'banneruid';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();


  static Future setname(String faves) async =>
      await _preferences?.setString(_keynames, faves);
  static String? getname() => _preferences?.getString(_keynames);
}
