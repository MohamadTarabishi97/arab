import 'dart:convert';

import 'package:ArabDealProject/objects/user.dart';
import 'package:http/http.dart' as http;

//ToDoFromAPI i need the permissions come with this response
class GetAdminsHttpRequest{
  static Future<List<User>> getAdmins()async{
    try{
      final String getAdminsUrl='https://3ard.de/api/allAdmin';
      http.Response response=await http.get(getAdminsUrl);
     if(response.statusCode==200){
       String responseAsString=response.body;  
       print(responseAsString);    
       List<dynamic> responseList=json.decode(response.body);
       List<User> admins=responseList.map((admin)=>User.fromJson(admin)).toList();
        if(admins?.length==0??true)
        return null;
       return admins;
     }
     else return null;
    }
    catch(e){
      print('exception caught : $e');
      return null;
    }

  }
}