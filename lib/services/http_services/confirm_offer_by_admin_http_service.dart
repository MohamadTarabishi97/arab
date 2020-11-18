import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmOfferByAdminHttpService{
  static Future confirmOfferByAdmin(int id)async{
    try{
      final String confirmOfferByAdminURL='https://3ard.de/api/offer/confirm';
      Map requestBodyMap={
        'id':id?.toString()??''
      };
      http.Response response=await http.post(confirmOfferByAdminURL,body:requestBodyMap);
      if(response.statusCode==200){
         String responseAsString=response.body;
      Map responseAsMap=json.decode(responseAsString);
      int statusCode=responseAsMap['code'];
      if(statusCode==200){
        return true;
      }
      else return false;
      }
      return false;

    }catch(e){
      print(e.toString());
      return false;
    }
  }
}