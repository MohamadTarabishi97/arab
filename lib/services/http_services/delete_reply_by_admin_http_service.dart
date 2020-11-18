import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteReplyByAdminHttpService {
  static Future deleteRplayByAdmin(int replyId) async {
    try {
      final String deleteCommentURL = 'https://3ard.de/api/deleteReply?id=$replyId';
      http.Response deleteCommentResponse =
          await http.get(deleteCommentURL);
         
      if(deleteCommentResponse.statusCode==200){
        String responseAsString=deleteCommentResponse.body;
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
