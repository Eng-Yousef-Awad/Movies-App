import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setOnBoardingSeen(bool seen) async {
    await _prefs?.setBool('onBoardingSeen', seen);
  }

  static bool getOnBoardingSeen() {
    return _prefs?.getBool('onBoardingSeen') ?? false;
  }

}
