import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// this request is related to get admins editing 
class EditAdminHttpService {
  static Future editAdmin(User admin) async {
    try {
      final String editAdminURL = 'https://3ard.de/api/admin/edit/mobile';
      http.Response response = await http.post(editAdminURL, body: {
        'id':admin.id?.toString()??'',
        "first_name": admin.firstName??'',
        "last_name": admin.lastName??'',
        "user_name":admin.username??'',
        "email": admin.email??'',
        "password": admin.password??'',
        "phone_number": admin.phoneNumber??'',
        "image_url": admin.imageUrl??'',
        "can_add_offer": admin.admin['can_add_offer']?.toString()??'',
        "can_delete_offer": admin.admin['can_delete_offer']?.toString()??'',
        "can_edit_offer": admin.admin['can_edit_offer']?.toString()??'',
        "can_add_category": admin.admin['can_add_category']?.toString()??'',
        "can_edit_category": admin.admin['can_edit_category']?.toString()??'',
        "can_delete_category": admin.admin['can_delete_category']?.toString()??'',
        "can_see_reports": admin.admin['can_see_reports']?.toString()??'',
        "change_can_manage_admin": admin.admin['change_can_manage_admin']?.toString()??''
      });
      print(response.body);
            if (response.statusCode == 200) {
        String responseAsString = response.body;
        print(responseAsString);
        Map responseAsMap = json.decode(responseAsString);
        int statusCode = responseAsMap['code'];
        if(statusCode==200){
          return true;
        }
        else return false;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
