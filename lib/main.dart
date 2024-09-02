import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sos_bebe_profil_bebe_doctor/firebase_options.dart';
import 'package:sos_bebe_profil_bebe_doctor/intro/intro_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     'pk_test_51NiZpwCOKR6JfYKlesMUOOQJyJLVZPUPgsjQIBbTHDGXFD0ocGELdZ3uVPrJn4knnhsdhTkRVm9h1Ij3WUU8EEdg00MhGEEoPS';
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('bf049046-edaf-41f1-bb07-e2ac883af161');
  await OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //InitializareNumarPacientiWidget widget = InitializareNumarPacientiWidget();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        highlightColor: Colors.white, //added by Iordache George Valentin
        primarySwatch: Colors.green, //added by Iordache George Valentin
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        LocalizationsApp.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'), // American English
        //Locale('ro', 'RO'),
        Locale.fromSubtags(languageCode: 'ro'),

        Locale('ro', 'RO'), // Romanian
      ],

      locale: const Locale('ro'),

      home: const IntroScreen(), // ecranul principal
    );
  }
}
