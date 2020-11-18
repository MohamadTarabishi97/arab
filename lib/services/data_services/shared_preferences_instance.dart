import 'package:shared_preferences/shared_preferences.dart';



class SharedPreferencesInstance{
  static SharedPreferences sharedPreferences;

  static Future createInstance()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }
 static get getSharedPreferences =>sharedPreferences;
}