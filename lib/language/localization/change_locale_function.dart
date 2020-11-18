import 'package:flutter/material.dart';
import 'package:ArabDealProject/language/language_classes/language.dart';
import 'package:ArabDealProject/main.dart';

void changeLocale(BuildContext context, Language language) {
  Locale _tempLocale;
  switch (language.languageCode) {
    case 'ar':
      _tempLocale = Locale(language.languageCode, 'SY');
      break;
    case 'de':
      _tempLocale = Locale(language.languageCode, 'DE');
      break;
  }
  App.setLocale(context, _tempLocale);
}
