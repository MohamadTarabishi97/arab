import 'package:shared_preferences/shared_preferences.dart';
class SaveUserDataService {
 static Future<bool> saveUser(String userAsString) async {
    final sharedPreference = await SharedPreferences.getInstance();
    bool resultOfStoring = await sharedPreference.setString('User', userAsString);
    return resultOfStoring;
  }
}

