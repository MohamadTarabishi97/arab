import 'dart:convert';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LikeCommentHttpService {
  static Future likeCeomment(
      {@required int commentId}) async {
    try {

      final String likeCommentUrl = 'https://3ard.de/api/offer/likeComment';
      String userId=FetchUserDataService.fetchUser().id.toString();
      http.Response response = await http.post(likeCommentUrl, body: {
        "comment_id": commentId.toString(),
        "user_id": userId.toString()
      });
      String responseAsString=response.body;
      print(responseAsString);
      Map responseAsMap=json.decode(responseAsString);
      int statusCode=responseAsMap['code'];
      int caseOfLike=responseAsMap['data'];
      if(statusCode==200&&caseOfLike==1){
        return true;
      }
      else if(statusCode==200&&caseOfLike==0) {
        return false;
      }
      else return null;
    } catch (e) {
      print(e.toString());
      return null;
      
    }
  }
}
