import 'package:ArabDealProject/objects/favorite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class GetFavoritesHttpService {
  static Future<List<Favorite>> getFavorites(int userId) async {
    final String getFavoritesUrl = 'https://3ard.de/api/getSearchHistory?user_id=$userId';
    try{
          http.Response response = await http.get(getFavoritesUrl);     
      if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyMap = json.decode(response.body);
      List<dynamic> data = responseBodyMap['data'];    
      List<Favorite> favorites = data.map((e) => Favorite.fromJson(e)).toList();    
      return favorites;
    }else return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }    
    
  }
}
