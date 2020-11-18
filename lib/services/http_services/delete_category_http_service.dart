import 'dart:convert';

import 'package:http/http.dart' as http;
class DeleteCategoryHttpService{
  static Future<bool> deleteCategory(int id)async{
    try{
      final String deleteCategoryURL="https://3ard.de/api/category/delete";
      http.Response deleteResponse=await http.post(deleteCategoryURL,body: {
        "id":id.toString()
      });
      String responseBodyAsString=deleteResponse.body;
      print(responseBodyAsString);
      Map responseBodyAsMap=json.decode(responseBodyAsString);
      int statusCode=responseBodyAsMap['code'];
      if(statusCode==200){
        return true;
      }
      else return false;
    }catch(e){
      print(e.toString());
      return false;
    }
  }
}