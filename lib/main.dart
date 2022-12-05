import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/local/app_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({super.key});
  String? preferredLanguage;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final prefs = await SharedPreferences.getInstance();
    widget.preferredLanguage = prefs.getString('languagePreferences');
    print('======${widget.preferredLanguage}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // List all of the app's supported locales here
      supportedLocales: AppLocalizationsSetup.supportedLocales,
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
      //localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,

      locale: widget.preferredLanguage != null
          ? Locale(widget.preferredLanguage!)
          : null,
      home: MyHomePage(),
    );
  }
}

/*
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.translate('first_string')!,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.translate('second_string')!,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'This will not be translated.',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});
  String? preferredLanguage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final prefs = await SharedPreferences.getInstance();
    widget.preferredLanguage = prefs.getString('languagePreferences');
    print('======${widget.preferredLanguage}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.translate('first_string')!,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.translate('second_string')!,
                style: const TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'This will not be translated.',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Beforeee Arabic prefs ${widget.preferredLanguage}');
                    await prefs.setString('languagePreferences', 'ar');
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Afterrrr Arabic prefs ${widget.preferredLanguage}');
                  },
                  child: Text('Arabic')),
              ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Beforeee English prefs ${widget.preferredLanguage}');
                    await prefs.setString('languagePreferences', 'en');
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Afterrrr English prefs ${widget.preferredLanguage}');
                  },
                  child: Text('English')),
              ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Beforeee null prefs ${widget.preferredLanguage}');
                    await prefs.remove('languagePreferences');
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Afterrrr null prefs ${widget.preferredLanguage}');
                  },
                  child: Text('Null')),
              ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    widget.preferredLanguage =
                        prefs.getString('languagePreferences');
                    print('Print  prefs ${widget.preferredLanguage}');
                  },
                  child: Text('  Print  ')),
            ],
          ),
        ),
      ),
    );
  }
}
