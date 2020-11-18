import 'package:ArabDealProject/objects/offer.dart';
import 'package:flutter/material.dart';

class SearchOffer with ChangeNotifier {
   List<Offer> offers;

  void searchAndReturn(
      {@required List listOfOffers, @required String currentText}) {
        currentText=currentText?.toLowerCase();
    offers = [];
    for (Offer offer in listOfOffers) {
      if((offer.offerTitleArabic==null||offer.offerTitleGerman==null)){
        offers.add(offer);
      }
      else{
        if (offer.offerTitleArabic.toLowerCase().contains(currentText) ||
          offer.offerTitleGerman.toLowerCase().contains(currentText)) {
        offers.add(offer);
      }
      }
    }
    notifyListeners();
  }
}
