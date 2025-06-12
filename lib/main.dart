import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/firebase_options.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/chat.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/screens/videoCallScreen.dart';
import 'package:sos_bebe_profil_bebe_doctor/intro/intro_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/notification_confirm_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'fix/screens/requeste_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> ensureDeviceToken({int retries = 5}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  for (int i = 0; i < retries; i++) {
    final String? newToken = OneSignal.User.pushSubscription.id;

    if (newToken != null && newToken.isNotEmpty) {
      await prefs.setString('deviceToken', newToken);
      print('✅ Device token saved: $newToken');
      return;
    }

    print('⏳ Waiting for device token... (attempt ${i + 1})');
    await Future.delayed(const Duration(seconds: 2));
  }

  print('❌ Failed to get OneSignal token after $retries retries.');
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://28348af376e7d2a0347d6ab007685fa3@o4509014972366848.ingest.de.sentry.io/4509015124541520';
      options.tracesSampleRate = 1.0;
      options.debug = true;
      options.sendDefaultPii = true;
    },
    appRunner: () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize('bf049046-edaf-41f1-bb07-e2ac883af161');
      await OneSignal.Notifications.requestPermission(true);

      await ensureDeviceToken();


      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        handleNotification(event.notification);
      });
      OneSignal.Notifications.addClickListener((event) {
        handleNotification(event.notification);
      });

      runApp(const MyApp());
    },
  );
}

ApiCallFunctions apiCallFunctions = ApiCallFunctions();
String oneSignalId = '';
TotaluriMedic? totaluriMedic;


Future<void> navigateToNotificationScreen(BuildContext context, String page) async {
  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String user = prefs.getString('user') ?? '';
  String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
  String deviceToken = prefs.getString('deviceToken') ?? '';

  TotaluriMedic? resGetTotaluriDashboardMedic = await apiCallFunctions.getTotaluriDashboardMedic(
    pUser: user,
    pParola: userPassMD5,
  );

  ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
    pUser: user,
    pParola: userPassMD5,
    pDeviceToken: deviceToken,
    pTipDispozitiv: Platform.isAndroid ? '1' : '2',
    pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
    pTokenVoip: '',
  );

  if (resGetCont != null && resGetTotaluriDashboardMedic != null) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailsScreen(
          totaluriMedic: resGetTotaluriDashboardMedic,
          contMedicMobile: resGetCont,
          page: page,
        ),
      ),
          (route) => false,
    );
  }
}

void handleNotification(OSNotification notification) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('notificationTitle', notification.title ?? 'Fără Titlu');
  await prefs.setString('notificationBody', notification.body ?? 'Fără corp');
  await prefs.setString('notificationData', notification.additionalData?.toString() ?? 'Fără date');

  String? alertMessage = notification.body;
  if (alertMessage != null) {
    if (alertMessage.toLowerCase().contains('apel')) {
      navigateToNotificationScreen(navigatorKey.currentState!.context, 'apel');
    } else if (alertMessage.toLowerCase().contains('recomandare')) {
      navigateToNotificationScreen(navigatorKey.currentState!.context, 'recomandare');
    } else if (alertMessage.toLowerCase().contains('întrebare')) {
      navigateToNotificationScreen(navigatorKey.currentState!.context, 'întrebare');
    }
  }

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        highlightColor: Colors.white,
        primarySwatch: Colors.green,
      ),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        LocalizationsApp.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale.fromSubtags(languageCode: 'ro'),
        Locale('ro', 'RO'),
      ],
      locale: const Locale('ro'),
     // home:ChatScreen(isDoctor: true,doctorId: 'DOCTOR_12345',
     //   patientId: 'PATIENT_67890',
     //   doctorName: 'Dr. Smith',
     //   patientName: 'John Doe',
     //   chatRoomId: 'DOCTOR_12345_PATIENT_67891',)

     home :const IntroScreen(), //
    );
  }
}





