import 'dart:convert';

import 'package:http/http.dart' as http;

class SaveTokenForNotificationHttpService {
  static Future saveTokenForNotification({String token, int userId}) async {
    try {
      final String saveTokenForNotificationURL = 'https://3ard.de/api/getToken';

      http.Response response = await http.post(saveTokenForNotificationURL,
          body: {"token": '"$token"', "user_id": userId.toString()});
      String responseAsString=response.body;
      if(responseAsString=="success")
      return true;
      else return false;
          
    } catch (e) {
      print(e.toString());
    }
  }
}
