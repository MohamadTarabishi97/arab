import 'dart:convert';

import 'package:ArabDealProject/constants.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:http/http.dart' as http;

class ResetPasswordHttpService {
  static Future<bool> resetPassword(User user) async {
    try {
      final loginURL = 'https://3ard.de/api/email/resetPassword';
      Map requestBody = {"email": user.email, "password": user.password};
      http.Response response = await http
          .post(loginURL, body: requestBody);
      print(response.body);
      if (response.statusCode == 200) {
        String responseBodyAsString = response.body;
        Map responseAsMap = json.decode(responseBodyAsString);
        int statusCode = responseAsMap['code'];
        if (statusCode == 200) {
         return true;
      }else return false;
      } else
        return false ;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
