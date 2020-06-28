import 'package:shared_preferences/shared_preferences.dart';


class Localstorage{

  Localstorage._privateConstructor();
  static final Localstorage instance = Localstorage._privateConstructor();

  Future<bool> setPrefs(key,value) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(key,value);
  }

  Future<String> getPrefs(key) async{
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return  prefs.getString(key);
  }
}