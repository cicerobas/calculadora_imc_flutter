import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences prefs;
  static const sharedPrefsNameKey = 'nome_usuario';

  static void setUsername(String nome) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPrefsNameKey, nome);
  }

  static Future<String> getUsername() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefsNameKey) ?? '';
  }
}
