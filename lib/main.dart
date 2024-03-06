// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, body_might_complete_normally_catch_error

// import 'package:admob_flutter/admob_flutter.da
import 'package:cite_phila/page/home_page.dart';
import 'package:cite_phila/page/live_page.dart';
import 'package:cite_phila/screens/search_screen.dart';
import 'package:cite_phila/splash_screen.dart';
import 'package:cite_phila/theme/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language/language_preferences.dart';
import 'models/ProviderManager.dart';
import 'models/preferences_manager/shared.dart';
import 'page/movie_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  await PreferencesService.init();
  String? savedLanguage = prefs.getString('language');

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: [
      'en_US',
      'fr',
    ],
    preferences: TranslatePreferences(savedLanguage),
  );
  // Admob.initialize();
  await MobileAds.instance.initialize();
  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider()..initializeTheme(),
      child: MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (create) => Shop()),
          ChangeNotifierProvider(create: (create) => ProviderManager()),
        ],
        child: LocalizedApp(
          delegate,
          const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: Consumer<ThemeProvider>(builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            localizationDelegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: provider.themeData,
          title: 'walesa',
          initialRoute: '/',
          routes: {
            '/': (context) => const Splash(),
            '/home': (context) => HomePage(),
            '/movie': (context) => const VideoPage(),
            '/live': (context) => LivePage(
              videoUrl: '',
              videoTitle: '',
            ),
            '/search': (context) => SearchPage(videoItems)
          },
        );
      }),
    );
  }
}
