import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddSearchHistoryHttpService {
  static Future addSearchHistory({String word}) async {
    try {
      String userId=FetchUserDataService.fetchUser().id.toString();
      final String addSearchHistoryURL = 'https://3ard.de/api/addSearchHistory';
      http.Response response = await http
          .post(addSearchHistoryURL, body: {"word": word, "user_id": userId});
     if(response.statusCode==200){
        String responseAsString=response.body; 
        print(responseAsString);
      Map responseAsMap=json.decode(responseAsString);
      int stautsCode =responseAsMap['code'];
      if(stautsCode==200){
        print('word added');
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
