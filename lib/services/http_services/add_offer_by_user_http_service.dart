import 'dart:convert';

import 'package:ArabDealProject/objects/offer.dart';
import 'package:http/http.dart' as http;

class AddOfferByUserHttpService {
  static Future<bool> addOfferByUser(Offer offer) async {
    final addOfferByUserURL = 'https://3ard.de/api/offer/add/user/mobile';
    try {
      Map request = {
         "category_id": offer.categoryId?.toString(),
        "offer_title_arabic": offer.offerTitleArabic?.toString()??'',
        "offer_title_german": offer.offerTitleGerman?.toString()??'',
        "offer_short_description_arabic":
            offer.offerShortDescriptionArabic?.toString()??'',
        "offer_short_description_german":
            offer.offerShortDescriptionGerman?.toString(),
        "offer_description_arabic": offer.offerDescriptionArabic?.toString()??'',
        "offer_description_german": offer.offerDescriptionGerman?.toString()??'',
        "video_url": offer.videoUrl?.toString()??'',
        "vouchersCode": offer.vouchersCode?.toString()??'',
        "offer_url": offer.offerUrl?.toString()??'',
        "price_before": offer.priceBefore?.toString()??'0',
        "price_after": offer.priceAfter?.toString()??'0',
        "created_by": offer.createdBy?.toString(),
        "image_array":
            (offer.imageUrl != null) ? json.encode(offer.imageUrl) :''
       
      };
      http.Response response =
          await http.post(addOfferByUserURL, body: request);
      String responseAsString = response.body;
      Map responseAsMap = json.decode(responseAsString);
      int statusCode = responseAsMap['code'];
      print(response.body);
      if (statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString() + '  fuck man');
      return false;
    }
  }
}
