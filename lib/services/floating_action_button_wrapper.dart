import 'package:flutter/cupertino.dart';

class FloatingAcitonButtonWrapper with ChangeNotifier{
  bool showAddOfferButton;
   
   void assignShowActionButton(bool result){
     showAddOfferButton=result;
     notifyListeners();
   }

}

