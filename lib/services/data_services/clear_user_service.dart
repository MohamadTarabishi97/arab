import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearUserDataService {
  static Future<bool> clearUser() async {
    SharedPreferences sharedPreferences =
        SharedPreferencesInstance.getSharedPreferences;
    bool resultOfClreaing=await sharedPreferences.setString('User', null);
    return resultOfClreaing;
  }
}
