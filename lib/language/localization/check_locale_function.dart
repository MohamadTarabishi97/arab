import 'package:flutter/cupertino.dart';

bool checkWhetherArabicLocale(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    if (currentLocale.countryCode == 'SY')
      return true;
    else
      return false;
  }