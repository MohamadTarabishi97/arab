import 'dart:convert';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';

class FetchUserDataService {
  static User fetchUser() {
    final sharedPreference = SharedPreferencesInstance.getSharedPreferences;
    String userAsString = sharedPreference.getString('User');
    if (userAsString != null) {
      Map userAsMap = json.decode(userAsString);
      if (userAsMap != null) {
        User user = User.fromJson(userAsMap);
        print(user);
        return user;
      } else
        return null;
    } else
      return null;
  }
}
