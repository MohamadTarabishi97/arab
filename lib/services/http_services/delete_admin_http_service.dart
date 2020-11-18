import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAdminHttpService{
  static Future deleteAdmin(int id)async{
    try{
      final String deleteAdminURL='https://3ard.de/api/admin/delete';
      http.Response response=await http.post(deleteAdminURL,body: {
        'id':id.toString()
      });
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