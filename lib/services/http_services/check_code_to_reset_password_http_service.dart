import 'dart:convert';
import 'package:ArabDealProject/objects/code.dart';
import 'package:http/http.dart' as http;

class CheckCodeToResetPasswordHttpService {
  static Future<bool> checkCode(Code code) async {
    try {
      final checkCodeURL = 'https://3ard.de/api/email/checkCode';
      Map requestBody = {"email": code.email, "code": code.code};
      http.Response response = await http
          .post(checkCodeURL, body: requestBody);
          //.timeout(Duration(seconds: 20));
      print(response.body);
      if (response.statusCode == 200) {
        String responseBodyAsString = response.body;
        Map responseAsMap = json.decode(responseBodyAsString);
        int statusCode = responseAsMap['code'];
        if (statusCode == 200) {
         return true;
     
        }else return false; 
      }return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
