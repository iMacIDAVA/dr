import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<LocalizationsApp> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ro', 'it', 'fr', 'en'].contains(locale.languageCode);

  @override
  Future<LocalizationsApp> load(Locale locale) {
    return SynchronousFuture<LocalizationsApp>(LocalizationsApp(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

}
