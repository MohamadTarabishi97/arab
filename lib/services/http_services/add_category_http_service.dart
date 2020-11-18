import 'package:ArabDealProject/objects/category.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class AddCategoryHttpService{
  static Future <Category> addCategory(Category category)async{
    try{
      final String addCategoryURL='https://3ard.de/api/category/add';
       http.Response response=await http.post(addCategoryURL,body:{
         'german_name':category.nameGerman,
         'arabic_name':category.nameArabic
       });
       if(response.statusCode==200){
         String responseAsString=response.body;
         Map responseAsMap=json.decode(responseAsString);
         int statusCode=responseAsMap['code'];
         if(statusCode==200){
           print(responseAsString);
           Category addedCategory=Category.fromJson(responseAsMap['data']);
           return addedCategory;           
         }
         else return null;
       }
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}