import 'dart:convert';

import 'package:http/http.dart'as http;

class ContactUsHttpService{
  static Future contactUs({String email,String name,String message})async{
    try{
      final String contactUsURL='https://3ard.de/api/email/send';
      http.Response response=await http.post(contactUsURL,body:{
        "email":email,
        "name":name,
        "message":message
      });
      String responseAsString=response.body;
      if(response.statusCode==200){
        Map responseAsMap=json.decode(responseAsString);
        int statusCode=responseAsMap['code'];
        if(statusCode==200)
        return true;
        else return false;
      }
      return false;


    }catch(e){
      print(e.toString());
      return false;
    }
  }
}