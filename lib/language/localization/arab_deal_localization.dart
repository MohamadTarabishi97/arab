import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ArabDealLocalization {
  final Locale locale;
  ArabDealLocalization(this.locale);
  static ArabDealLocalization of(BuildContext context) {
    return Localizations.of<ArabDealLocalization>(
        context, ArabDealLocalization);
  }

  Map<String, dynamic> _localizedValues;

  Future load() async {
    String jsonStringValues =
        await rootBundle.loadString('lib/language/lang/${locale.languageCode}.json');
    Map<String, dynamic> mappedMessage = json.decode(jsonStringValues);
    _localizedValues =
        mappedMessage.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedWordByKey({String key}) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<ArabDealLocalization> delegate =
      _ArabDealLocalizationDelegate();
}

class _ArabDealLocalizationDelegate
    extends LocalizationsDelegate<ArabDealLocalization> {
  const _ArabDealLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['ar', 'de'].contains(locale.languageCode);
  }

  @override
  Future<ArabDealLocalization> load(Locale locale) async {
    ArabDealLocalization arabDealLocalization =
        new ArabDealLocalization(locale);
    await arabDealLocalization.load();
    return arabDealLocalization;
  }

  @override
  bool shouldReload(_ArabDealLocalizationDelegate old) => false;
}
