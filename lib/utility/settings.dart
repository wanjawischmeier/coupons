import 'package:shared_preferences/shared_preferences.dart';

Future<Null> setSetting(String setting, bool isSelected) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, isSelected);
}

Future<bool> getSetting(String setting) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(setting) ?? false;
}
