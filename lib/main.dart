import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/local/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  String? localeStringPreferenced;
  Locale? localePreferenced;
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final prefs = await SharedPreferences.getInstance();
    print('**************${prefs.getString('languagePreferences')}');
    widget.localeStringPreferenced = prefs.getString('languagePreferences');
    print(
        'widget.localeStringPreferenced${prefs.getString('languagePreferences')}');
    widget.localePreferenced = await AppLocalizationsSetup().getSavedLanguage();

    print('widget.localePreferenced${widget.localePreferenced}');
    // AppLocalizationsSetup().savedLocalPreferenceLang =
    //     Locale(widget.localePreferenced.toString());
  }

  Future<String?> getData() async {
    super.didChangeDependencies();
    final prefs = await SharedPreferences.getInstance();
    print('**************${prefs.getString('languagePreferences')}');

    print(
        'widget.localeStringPreferenced${prefs.getString('languagePreferences')}');
    widget.localePreferenced = await AppLocalizationsSetup().getSavedLanguage();

    print('widget.localePreferenced${widget.localePreferenced}');
    // AppLocalizationsSetup().savedLocalPreferenceLang =
    //     Locale(widget.localePreferenced.toString());
    return prefs.getString('languagePreferences');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLocalizationsSetup>(
      create: (_) => AppLocalizationsSetup(),
      child: Consumer<AppLocalizationsSetup>(builder: (_, model, __) {
        /*print(
            'before model.setSavedLocalPreferenceLang ${model.savedLocalPreferenceLang}');
        if (widget.localePreferenced != null) {
          print('ber inside null check');
          model.copyWith(
              savedLocalPreferenceLang:
                  Locale(widget.localePreferenced.toString()));
          print('aft inside null check');
        }
        print(
            'after model.setSavedLocalPreferenceLang ${model.savedLocalPreferenceLang}');*/
        return FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                print(
                    'before model.setSavedLocalPreferenceLang ${model.savedLocalPreferenceLang}');
              if (snapshot.data != null) {
                print('ber inside null check');
                model.copyWith(
                    savedLocalPreferenceLang: Locale(snapshot.data.toString()));
                print('aft inside null check');
              }
              print(
                  'after model.setSavedLocalPreferenceLang ${model.savedLocalPreferenceLang}');

              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                // List all of the app's supported locales here
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                // These delegates make sure that the localization data for the proper language is loaded
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,
                //localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
                locale: model.savedLocalPreferenceLang,
                // locale: model.savedLocalPreferenceLang == null &&
                //         widget.localeStringPreferenced != null
                //     ? Locale(widget.localeStringPreferenced!)
                //     : model.savedLocalPreferenceLang != null &&
                //             widget.localeStringPreferenced == null
                //         ? model.savedLocalPreferenceLang
                //         : null,
                home: MyHomePage(/*model: model*/),
              );
            });
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //AppLocalizationsSetup model;
  String? preferredLanguage;

  MyHomePage({
    super.key,
    /*required this.model*/
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final prefs = await SharedPreferences.getInstance();
    widget.preferredLanguage = prefs.getString('languagePreferences');
    print('====== widget.preferredLanguage${widget.preferredLanguage}');
  }

  @override
  Widget build(BuildContext context) {
    final modelLocale =
        Provider.of<AppLocalizationsSetup>(context, listen: false);
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
                    await modelLocale.changeLanguage('ar');
                    final x = await modelLocale.getSavedLanguage();
                    print('aaarrraabiccc $x');
                    print('aaarrr ${modelLocale.savedLocalPreferenceLang}');
                    setState(() {});
                  },
                  child: Text('Arabic')),
              ElevatedButton(
                  onPressed: () async {
                    await modelLocale.changeLanguage('en');
                    final x = await modelLocale.getSavedLanguage();
                    print('eennggllisshh  $x');
                    print('eeennnn ${modelLocale.savedLocalPreferenceLang}');
                    setState(() {});
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'config/local/app_localizations.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   String? localeStringPreferenced;
//   Locale? localePreferenced;
//   MyApp({super.key});
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Future<void> didChangeDependencies() async {
//     super.didChangeDependencies();
//     final prefs = await SharedPreferences.getInstance();
//     print('**************${prefs.getString('languagePreferences')}');
//     widget.localeStringPreferenced = prefs.getString('languagePreferences');
//     widget.localePreferenced = await AppLocalizationsSetup().getSavedLanguage();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppLocalizationsSetup>(
//       create: (_) => AppLocalizationsSetup(),
//       child: Consumer<AppLocalizationsSetup>(builder: (_, model, __) {
//         model.setSavedLocalPreferenceLang(widget.localePreferenced);
//         return MaterialApp(
//           title: 'Flutter Demo',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//           ),
//           // List all of the app's supported locales here
//           supportedLocales: AppLocalizationsSetup.supportedLocales,
//           // These delegates make sure that the localization data for the proper language is loaded
//           localizationsDelegates: AppLocalizationsSetup.localizationsDelegates,
//           //localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
//           locale: model.savedLocalPreferenceLang,
//           // locale: model.savedLocalPreferenceLang == null &&
//           //         widget.localeStringPreferenced != null
//           //     ? Locale(widget.localeStringPreferenced!)
//           //     : model.savedLocalPreferenceLang != null &&
//           //             widget.localeStringPreferenced == null
//           //         ? model.savedLocalPreferenceLang
//           //         : null,
//           home: MyHomePage(),
//         );
//       }),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key});
//   String? preferredLanguage;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void didChangeDependencies() async {
//     super.didChangeDependencies();
//     final prefs = await SharedPreferences.getInstance();
//     widget.preferredLanguage = prefs.getString('languagePreferences');
//     print('======${widget.preferredLanguage}');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final localModel =
//         Provider.of<AppLocalizationsSetup>(context, listen: false);
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(
//                 AppLocalizations.of(context)!.translate('first_string')!,
//                 style: const TextStyle(fontSize: 25),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 AppLocalizations.of(context)!.translate('second_string')!,
//                 style: const TextStyle(fontSize: 25),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'This will not be translated.',
//                 style: TextStyle(fontSize: 25),
//                 textAlign: TextAlign.center,
//               ),
//               ElevatedButton(
//                   onPressed: () async {
//                     localModel.changeLanguage('ar');
//                     final x = await localModel.getSavedLanguage();
//                     print('aaarrraabiccc $x');
//                   },
//                   child: Text('Arabic')),
//               ElevatedButton(
//                   onPressed: () async {
//                     localModel.changeLanguage('en');
//                     final x = await localModel.getSavedLanguage();
//                     print('eennggllisshh  $x');
//                   },
//                   child: Text('English')),
//               ElevatedButton(
//                   onPressed: () async {
//                     final prefs = await SharedPreferences.getInstance();
//                     widget.preferredLanguage =
//                         prefs.getString('languagePreferences');
//                     print('Beforeee null prefs ${widget.preferredLanguage}');
//                     await prefs.remove('languagePreferences');
//                     widget.preferredLanguage =
//                         prefs.getString('languagePreferences');
//                     print('Afterrrr null prefs ${widget.preferredLanguage}');
//                   },
//                   child: Text('Null')),
//               ElevatedButton(
//                   onPressed: () async {
//                     final prefs = await SharedPreferences.getInstance();
//                     widget.preferredLanguage =
//                         prefs.getString('languagePreferences');
//                     print('Print  prefs ${widget.preferredLanguage}');
//                   },
//                   child: Text('  Print  ')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
