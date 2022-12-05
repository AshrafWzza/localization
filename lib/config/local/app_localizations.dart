import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String key) => _localizedStrings![key];
}

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs

    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class AppLocalizationsSetup with ChangeNotifier {
  Locale? _savedLocalPreferenceLang;
  Locale? get savedLocalPreferenceLang => _savedLocalPreferenceLang;
  void setSavedLocalPreferenceLang(Locale? locale) {
    _savedLocalPreferenceLang = locale;
  }

  static const Iterable<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
    /*Locale('en', 'US'),
    Locale('sk', 'SK'),*/
  ];

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates =
      [
    // A class which loads the translations from JSON files
    AppLocalizations.delegate,
    // Built-in localization of basic text for Material widgets
    GlobalMaterialLocalizations.delegate,
    // Built-in localization for text direction LTR/RTL
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate
  ];

  // Returns a locale which will be used by the app
  static Locale? localeResolutionCallback(
      Locale? locale, Iterable<Locale>? supportedLocales) {
    // Locale?? Localizations.localeOf(context); // * Check for IOS
    for (Locale supportedLocale in supportedLocales!) {
      if (supportedLocale.languageCode == locale!.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }

  Future<Locale?> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('languagePreferences');
    if (lang != null) {
      _savedLocalPreferenceLang = Locale(lang);
      notifyListeners();
      return _savedLocalPreferenceLang;
    }
    return null;
  }

  Future<void> changeLanguage(String? lang) async {
    final prefs = await SharedPreferences.getInstance();
    switch (lang) {
      case 'ar':
        _savedLocalPreferenceLang = Locale(lang!);
        print('_savedLocalPreferenceLang 000 $_savedLocalPreferenceLang');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('languagePreferences', 'ar');
        print('_savedLocalPreferenceLang 111 $_savedLocalPreferenceLang');
        print('_savedLocalPreferenceLang 222 $savedLocalPreferenceLang');
        break;
      case 'en':
        _savedLocalPreferenceLang = Locale(lang!);
        print('_savedLocalPreferenceLang 000 $_savedLocalPreferenceLang');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('languagePreferences', 'en');
        print('_savedLocalPreferenceLang 111 $_savedLocalPreferenceLang');
        break;
      default:
        _savedLocalPreferenceLang = null;
        break;
    }
    print('En Switchhhh');
    notifyListeners();
  }

/*  Future<Locale?> defaultLocale(Locale? locale) async {
    */ /*  final savedLocale = await getSavedLanguage();
    print('savedLocale 0 $savedLocale');
    if (savedLocale != null) {
      print('savedLocale 1 $savedLocale');
      locale = savedLocale;
    }*/ /*
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode &&
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }*/
}
