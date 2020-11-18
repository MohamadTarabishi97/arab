import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ArabDealProject/objects/offer.dart';

class GetOffersHttpService {
  static Future<List<Offer>> getOffers() async {
    final String getOffersUrl = 'https://3ard.de/api/all/offer';
    try{
          http.Response response = await http.get(getOffersUrl);     
      if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyMap = json.decode(response.body);
      List<dynamic> data = responseBodyMap['data'];
      List<Offer> offers = data.map((offer) => Offer.fromJson(offer)).toList();      
      return offers;
    }else return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }    
    
  }
}
