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

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  String oneSignalId = '';
  TotaluriMedic? totaluriMedic;
  CallService callService = CallService();

  Future<void> initOneSignal() async {
    await getPlayerId();
    await getUserData();
  }

  String oneSignal = '';
  void getKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oneSignal = prefs.getString("oneSignalId")!;

    setState(() {});
  }

  Future<void> getPlayerId() async {
    final String? id = OneSignal.User.pushSubscription.id;

    if (id != null) {
      oneSignalId = id;
    } else {
      oneSignalId = '';
      await getPlayerId();
    }
    if (id != null) {
      await SharedPreferences.getInstance().then((value) {
        value.setString('oneSignalId', id);
      });
    }
    setState(() {});
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
    String user = prefs.getString('user') ?? "";
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    try {
      if (user != '') {
        TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();
        ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
          pUser: user,
          pParola: userPassMD5,
          pDeviceToken: oneSignal,
          pTipDispozitiv: Platform.isAndroid ? '1' : '2',
          pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
          pTokenVoip: '',
        );
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

          Future.delayed(const Duration(seconds: 3), () {
            callService.startPolling();
          });
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginMedicScreen(),
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initOneSignal();
    getKey();
  }

  @override
  void dispose() {
    callService.dispose();
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
