import 'dart:convert';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:http/http.dart' as http;

class GetCommentsByOfferIdHttpService {
  static Future<Offer> getCommentsByOfferId(int id) async {
    try {
      final String getOfferByIdURL = 'https://3ard.de/api/offer/$id';
      http.Response response = await http.get(getOfferByIdURL);
      if (response.statusCode == 200) {
        String responseAsString = response.body;
        print(responseAsString);
        Map responseAsMap = json.decode(responseAsString);
        int statusCode = responseAsMap['code'];
        if (statusCode == 200) {
          Offer offer=Offer();
          offer.offersComments=responseAsMap['data']['Comments'];
          offer.commentsNumber=responseAsMap['data']['Number_of_Comments'];
          return offer;
        } else
          return null;
      }
      return null;
    } catch (e) {
      print(e.toString()+'fuch the shit');
      return null;
    }
  }
}
