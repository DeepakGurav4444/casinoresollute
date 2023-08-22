import 'package:shared_preferences/shared_preferences.dart';

class SaveData {
  static String userCreditKey = "Credit";

  static Future<bool> saveCredit(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(userCreditKey, value);
  }

  static Future<int?> getCredit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userCreditKey);
  }
}
