import 'dart:convert';
import 'package:ArabDealProject/objects/category.dart';
import 'package:http/http.dart' as http;

class GetCategoriesHttpService {
  static Future<List<Category>> getCategories() async {
    try {
      final String getCategoriesUrl = 'https://3ard.de/api/category';
      http.Response response = await http.get(getCategoriesUrl);
      if (response.statusCode == 200) {
        List<dynamic> responseList = json.decode(response.body);
        List<Category> categories = responseList
            .map((category) => Category.fromJson(category))
            .toList();
                    

        return categories;
      } else
        return null;
    } catch (e) {
      print('excption caught : $e');
      return null;
    }
  }
}
