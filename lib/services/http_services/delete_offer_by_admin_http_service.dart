import 'dart:convert';
import 'package:http/http.dart'as http;


class DeleteOfferByAdminHttpService{
  static Future<bool> deleteOfferByAdmin(int id)async{
   try{
     final String deleteOfferByAdminURL='https://3ard.de/api/offer/delete';
     final response=await http.post(deleteOfferByAdminURL,body:{
      'id':id.toString()
     });
     final String responseAsString=response.body;
     print(responseAsString);
     final Map responseAsMap=json.decode(responseAsString);
     final int statusCode=responseAsMap['code'];
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