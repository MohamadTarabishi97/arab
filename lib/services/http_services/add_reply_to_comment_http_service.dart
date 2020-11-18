import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddReplyToCommentHttpService {
  static Future addReplyToComment({int commentId, String reply}) async {
    try {
      final addReplyToCommentURL = 'https://3ard.de/api/offer/comment/reply';
      User user = FetchUserDataService.fetchUser();
      Map requestBody = {
        "comment_id": commentId?.toString() ?? '',
        "reply": reply?.toString() ?? '',
        "user_id": user?.id?.toString() ?? ''
      };
      http.Response response =
          await http.post(addReplyToCommentURL, body: requestBody);
          print(response.body);
     if(response.statusCode==200){
        String responseAsString=response.body;
      Map responseAsMap=json.decode(responseAsString);
      int statusCode=responseAsMap['code'];
      if(statusCode==200){
        return true;
      }
      else return false;
     }
     else return false;

    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
