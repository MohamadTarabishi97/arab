import 'package:ArabDealProject/objects/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileHttpService {
  static Future editProfile(User user) async {
    try {
      const editProfileURL = 'https://3ard.de/api/user/edit/mobile';
      http.Response response = await http.post(editProfileURL, body: {
        "first_name": user.firstName ?? "",
        "last_name": user.lastName ?? "",
        "user_name":user.username ??"",
        "email": user.email ?? "",
        "phone_number": user.phoneNumber ?? "",
        "image_url": user.imageUrl ?? "",
        "id": user.id?.toString() ?? "",
        "password": user.password ?? ""
      });
      String responseAsString = response.body;
      print(responseAsString);
      if (response.statusCode == 200) {
        Map responseAsMap = json.decode(responseAsString);
        int statusCode = responseAsMap['code'];
        if (statusCode == 200) {
          Map userAsMap=responseAsMap['data'];
          String userAsString=json.encode(userAsMap);

          return userAsString;
        } else
          return null;
      } else
        return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
