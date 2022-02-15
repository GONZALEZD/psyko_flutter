import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debug_toolbox/debug_toolbox.dart';
import 'package:dgo_puzzle/firebase_options.dart';
import 'package:dgo_puzzle/game/game_data.dart';
import 'package:dgo_puzzle/page/home/home_page.dart';
import 'package:dgo_puzzle/page/login/login_page.dart';
import 'package:dgo_puzzle/page/play/play_page.dart';
import 'package:dgo_puzzle/service/fire_server.dart';
import 'package:dgo_puzzle/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FireServer(
    app: firebaseApp,
    database: FirebaseFirestore.instanceFor(app: firebaseApp),
    storage: FirebaseStorage.instanceFor(
        app: firebaseApp, bucket: "puzzle-challenge-a49fc.appspot.com"),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Toolbox(
      appBuilder: (context, config) {
        debugDefaultTargetPlatformOverride = config.platform;
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.app_title,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('fr', ''), // Spanish, no country code
          ],
          themeMode: config.themeMode,
          onGenerateRoute: (RouteSettings settings) {
            var routes = <String, WidgetBuilder>{
              "/": (context) => const LoginPage(),
              "/home": (context) => const HomePage(),
              "/play": (context) =>
                  PlayPage(game: settings.arguments as GameData),
            };
            WidgetBuilder builder = routes[settings.name]!;
            return MaterialPageRoute(builder: (ctx) => builder(ctx));
          },
          initialRoute: "/",
          showPerformanceOverlay: config.showPerfOverlay,
          shortcuts: config.shortcuts,
          actions: config.actions,
          debugShowCheckedModeBanner: config.showBanner,
          theme: AppTheme().light,
          darkTheme: AppTheme().dark,
        );
      },
    );
  }
}
