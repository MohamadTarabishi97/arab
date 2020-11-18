import 'package:ArabDealProject/objects/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class EditCateogyHttpService{
static Future editCategory(Category category)async{
  try{
    String idAsString=category.id.toString();
    final String editCategoryURL='https://3ard.de/api/category/edit/$idAsString}';
    http.Response response=await http.post(editCategoryURL,body:{
      'arabic_name':category.nameArabic,
      'german_name':category.nameGerman
    });
    if(response.statusCode==200){
      String responseAsString =response.body;
      print(responseAsString);
      Map responseAsMap =json.decode(responseAsString);
      int statusCode=responseAsMap['code'];
      if(statusCode==200){
        Category editedCategory=Category.fromJson(responseAsMap['data']);
        return editedCategory;
      }
      else return null;
    }

  }catch(e){
    print(e.toString());
    return null;
  }
}
}