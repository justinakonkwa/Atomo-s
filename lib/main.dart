// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, body_might_complete_normally_catch_error

import 'package:cite_phila/pages/home_page.dart';
import 'package:cite_phila/pages/live_page.dart';
import 'package:cite_phila/pages/movie_page.dart';
import 'package:cite_phila/provider/dark_theme_provider.dart';
import 'package:cite_phila/splash_screen.dart';
import 'package:cite_phila/widgets/dark_theme.dart';
import 'package:cite_phila/widgets/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  // debugPrint = (String? message, {int? wrapWidth}) {};
  WidgetsFlutterBinding.ensureInitialized();
  // Admob.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChandeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChandeProvider.darkTheme =
        await themeChandeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChandeProvider;
        }),
      ],
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeData, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'walesa',
            theme: Styles.themeData(themeChandeProvider.darkTheme, context),
            initialRoute: '/',
            routes: {
              '/': (context) => const Splash(),
              '/home': (context) => HomePage(),
              '/movie': (context) => const VideoPage(),
              '/live': (context) => LivePage(
                    videoUrl: '',
                    videoTitre: '',
                  ),
              '/search': (context) => SearchPage(videoItems)
            },
          );
        },
      ),
    );
  }
}
