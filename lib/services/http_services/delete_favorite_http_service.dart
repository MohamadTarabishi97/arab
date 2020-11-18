import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteFavoriteHttpService{
  static Future deleteFavorite(int id)async{
    try{
      final String deleteFavoriteURL='https://3ard.de/api/deleteSearchHistory?id=$id';
      http.Response response=await http.get(deleteFavoriteURL);
       if(response.statusCode==200){
             String responseAsString =response.body;
        Map responseAsMap=json.decode(responseAsString);
        int statusCode=responseAsMap['code'];
        if(statusCode==200){
          return true;
        }
       }else return false;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
}