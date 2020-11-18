import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordHttpService {
  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      const editProfileURL = 'https://3ard.de/api/editUserPassword';
      User user = FetchUserDataService.fetchUser();
      http.Response response = await http.post(editProfileURL,
          body: {"old_password": oldPassword, "new_password": newPassword},
          headers: {"Authorization": "Bearer ${user.tokens}"});
      String responseAsString = response.body;
      print(responseAsString);
      if (response.statusCode == 200) {
        Map responseAsMap = json.decode(responseAsString);
        int statusCode = responseAsMap['code'];
        if (statusCode == 200) {
          return true;
        } else
          return false;
      } else
        return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
