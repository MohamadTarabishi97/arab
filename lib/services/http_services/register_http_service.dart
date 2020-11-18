import 'dart:convert';

import 'package:ArabDealProject/constants.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:http/http.dart' as http;

class RegisterHttpService {
  static Future<String> register(User user) async {
    try {
      final loginURL = 'https://3ard.de/api/signup/mobile';
      Map requestBody = {
        'first_name': user.firstName,
        'last_name': user.lastName,
        "user_name":user.username,
        'email': user.email,
        'password': user.password,
        'phone_number': user.phoneNumber,
        'terms_of_use': user.termsOfUse.toString(),
        'image_url': user.imageUrl??'',
        "wantEmail": user.wantEmail.toString()
      };
      http.Response response = await http
          .post(loginURL, body: requestBody)
          .timeout(Duration(seconds: 20));
          print(response.body);
      if (response.statusCode == 200) {
        String responseBodyAsString = response.body;
        Map responseAsMap = json.decode(responseBodyAsString);
        int statusCode = responseAsMap['code'];
        if (statusCode == 200) {
          Map userAsMap= responseAsMap['data'];
          String userAsString=json.encode(userAsMap);
          return userAsString;
        } else if (statusCode == 300) {
          return Constants.missingCredentials;
        } else if (statusCode == 500) {
          return Constants.invalidCredentials;
        } else
          return Constants.somethingWentWrong;
      } else
        return Constants.somethingWentWrong;
    } catch (e) {
      print(e.toString());
      return Constants.somethingWentWrong;
    }
  }
}
