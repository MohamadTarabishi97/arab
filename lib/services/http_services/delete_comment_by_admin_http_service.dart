import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteCommentByAdminHttpService {
  static Future deleteCommentByAdmin(int commentId) async {
    try {
      final String deleteCommentURL = 'https://3ard.de/api/deleteComment/?comment_id=$commentId';
      http.Response deleteCommentResponse =
          await http.get(deleteCommentURL);
          String responseAsString=deleteCommentResponse.body;
          print(responseAsString);
      if(deleteCommentResponse.statusCode==200){
        
        Map responseAsMap=json.decode(responseAsString);
        int statusCode=responseAsMap['code'];
        if(statusCode==200){
          return true;
        }
        else return false;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
