import 'dart:convert';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class GetOffersByCategoryWithProviderHttpService with ChangeNotifier{
   List<Offer> offers;
   Future getOffersByCategory(String categoryId)async{
try{
      final getOffersByCategoryURL='https://3ard.de/api/category/offers/$categoryId';
      http.Response response=await http.get(getOffersByCategoryURL);
        if (response.statusCode == 200) {
      Map<String, dynamic> responseBodyMap = json.decode(response.body);
      print(responseBodyMap);
      Map data = responseBodyMap['data'];
      List<dynamic>offersDataList=data['Offers'];
      offers = offersDataList.map((offer) => Offer.fromJson(offer)).toList();  
      notifyListeners();      
     }
    return null;
  } 
   catch(e){
      print(e.toString());
      return null;
    }
  }
  
  void dataLoadingAction(){
    offers=null;
    notifyListeners();
  }
}