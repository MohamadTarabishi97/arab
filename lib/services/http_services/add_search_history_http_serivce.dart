import 'dart:convert';

import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:http/http.dart' as http;

class AddSearchHistoryHttpService {
  static Future addSearchHistroy(String word) async {
    try {
      int userId = FetchUserDataService.fetchUser()?.id;
      final String addSearchHistroyUrl = 'https://3ard.de/api/addSearchHistory';
      http.Response response = await http.post(addSearchHistroyUrl,
          body: {"word": word, "user_id": userId?.toString()??"0"});
       String responseAsString=response.body;
       Map responseAsMap=json.decode(responseAsString);
       int statusCode=responseAsMap['code'];
       if(statusCode==200){
         return true;
       }  
       else {
         return false;
       }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
