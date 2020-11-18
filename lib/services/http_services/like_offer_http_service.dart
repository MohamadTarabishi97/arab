import 'dart:convert';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:http/http.dart' as http;

class LikeOfferHttpService {
  static Future likeOffer(Offer offer) async {
    try {
      final String likeOfferURL = 'https://3ard.de/api/offer/likeOffer';
      User user = FetchUserDataService.fetchUser();
      final response = await http.post(likeOfferURL,
          body: {"offer_id": offer.id.toString(), "user_id": user.id.toString()});
       if(response.statusCode==200){
          String responseAsString = response.body;
      print(responseAsString);
      Map responseAsMap = json.decode(responseAsString);
      int statusCode = responseAsMap['code'];
      
      if (statusCode == 200) {
        int data=responseAsMap['data'];
        
        return data;
      } else
        return -1;
       }
       else return -1;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }
}
