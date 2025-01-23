import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

class ConsultFinishedScreen extends StatefulWidget {
  const ConsultFinishedScreen({Key? key}) : super(key: key);

  @override
  State<ConsultFinishedScreen> createState() => _ConsultFinishedScreenState();
}

class _ConsultFinishedScreenState extends State<ConsultFinishedScreen> {
  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  String oneSignalId = '';
  TotaluriMedic? totaluriMedic;

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

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        getUserData();
      }
    });
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceToken = prefs.getString('deviceToken') ?? '';

    TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();

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
          builder: (context) => DashboardScreen(
            contMedicMobile: resGetCont,
            totaluriMedic: resGetTotaluriDashboardMedic,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Consultație încheiată',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(14, 190, 127, 1),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
