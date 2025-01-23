import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'dashboard_screen.dart';
import 'localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

class PaymentConfirmationReject extends StatefulWidget {
  final String body;

  const PaymentConfirmationReject({Key? key, required this.body}) : super(key: key);

  @override
  State<PaymentConfirmationReject> createState() => _PaymentConfirmationRejectState();
}

class _PaymentConfirmationRejectState extends State<PaymentConfirmationReject> {
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
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text(
        //     'Plata nu a reușit',
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
        //   foregroundColor: Colors.white,
        // ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               Text(
                    'Ne pare rău',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),

                SizedBox(height: 40),

                Text(
                  'Pacientul nu a plătii',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),


                // ElevatedButton(
                //   onPressed: () {
                //     getUserData();
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                //     padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(12.0),
                //     ),
                //   ),
                //   child: const Text(
                //     'Acasă',
                //     style: TextStyle(
                //       fontSize: 16.0,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xFFF7F8FA), // Light background color
      ),
    );
  }
}
