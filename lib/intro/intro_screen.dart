import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/agora_call_service.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import '../notification_confirm_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  String oneSignalId = '';
  TotaluriMedic? totaluriMedic;
  // CallService callService = CallService();

  Future<void> initOneSignal() async {
    await ensureDeviceToken();
    await getUserData();

    // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    //   saveNotificationData(event.notification);
    // });
    // OneSignal.Notifications.addClickListener((event) {
    //   saveNotificationData(event.notification);
    // });
  }

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


  Future<void> saveNotificationData(OSNotification notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(pref_keys.notificationTitle, notification.title ?? 'Fără Titlu');
    await prefs.setString(pref_keys.notificationBody, notification.body ?? 'Fără corp');
    await prefs.setString(pref_keys.notificationData, notification.additionalData?.toString() ?? 'Fără date');

    String? alertMessage = notification.body;
    if (alertMessage != null) {
      if (alertMessage.toLowerCase().contains('apel')) {
        navigateToNotificationScreen(context, 'apel');
      } else if (alertMessage.toLowerCase().contains('recomandare')) {
        navigateToNotificationScreen(context, 'recomandare');
      } else if (alertMessage.toLowerCase().contains('întrebare')) {
        navigateToNotificationScreen(context, 'întrebare');
      }
    }
  }


  Future<void> ensureDeviceToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? deviceToken = prefs.getString('deviceToken');

    if (deviceToken == null || deviceToken.isEmpty) {
      final String? newToken = OneSignal.User.pushSubscription.id;

      if (newToken != null) {
        await prefs.setString('deviceToken', newToken);
      } else {}
    } else {}
  }

  aa()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? deviceToken = prefs.getString('deviceToken');

    print('bbbb : ${deviceToken}');
  }

  Future<TotaluriMedic?> getTotaluriDashboardMedic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedic(
      pUser: user,
      pParola: userPassMD5,
    );

    return totaluriMedic;
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceToken = prefs.getString('deviceToken') ?? '';

    try {
      if (user.isNotEmpty) {
        TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();

        ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
          pUser: user,
          pParola: userPassMD5,
          pDeviceToken: deviceToken,
          pTipDispozitiv: Platform.isAndroid ? '1' : '2',
          pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
          pTokenVoip: '',
        );

        if (resGetCont == null) {}

        if (resGetTotaluriDashboardMedic != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                contMedicMobile: resGetCont!,
                totaluriMedic: resGetTotaluriDashboardMedic,
              ),
            ),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginMedicScreen(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initOneSignal();

    aa();
  }

  @override
  void dispose() {
    // callService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('./assets/images/Sos_Bebe_logo.png', height: 198, width: 158)),
    );
  }
}
