import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ArabDealProject/objects/offer.dart';

class GetOffersToApproveHttpService {
  static Future<List<Offer>> getOffersToApprove() async {
    final String getOffersToApproveUrl = 'https://3ard.de/api/all/offer/confirm';
    try{
          http.Response response = await http.get(getOffersToApproveUrl);     
      if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyMap = json.decode(response.body);
      print(response.body);
       List<dynamic> data = responseBodyMap['data'];
       List<Offer> offers = data.map((offer) => Offer.fromJson(offer)).toList();      
       return offers;
    }
    }
    catch(e){
      print(e.toString());
      return null;
    }    
    return null;
  }
}
