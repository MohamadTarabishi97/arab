import 'dart:convert';

import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AddCommentHttpService {
  static Future addComment({@required int offerId,@required String comment}) async {
    try {
      String userId = FetchUserDataService.fetchUser().id.toString();
      final String addSearchHistroyUrl = 'https://3ard.de/api/offer/comment';
      http.Response response = await http.post(addSearchHistroyUrl,
          body: {
            "offer_id": '$offerId',
             "comment":comment , 
             "user_id": userId});
      String responseAsString = response.body;
      print(responseAsString);
      if(response.statusCode==200){
         Map responseAsMap = json.decode(responseAsString);
      int statusCode = responseAsMap['code'];
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
