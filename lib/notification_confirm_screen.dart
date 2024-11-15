import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_config.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;
import 'package:sos_bebe_profil_bebe_doctor/waiting_payment_screen.dart';
import '../dashboard_screen.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;
  final TotaluriMedic totaluriMedic;

  const NotificationDetailsScreen({Key? key, required this.contMedicMobile, required this.totaluriMedic})
      : super(key: key);

  @override
  State<NotificationDetailsScreen> createState() => _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  bool isLoading = false;

  Future<Map<String, dynamic>> getNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'title': prefs.getString(pref_keys.notificationTitle) ?? 'Fără Titlu',
      'body': prefs.getString(pref_keys.notificationBody) ?? 'Fără corp',
      'data': prefs.getString(pref_keys.notificationData) ?? '{}',
    };
  }

  Future<void> navigateToDashboard(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    ApiCallFunctions apiCallFunctions = ApiCallFunctions();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceToken = prefs.getString('deviceToken') ?? '';

    try {
      if (user.isNotEmpty) {
        TotaluriMedic? resGetTotaluriDashboardMedic =
            await apiCallFunctions.getTotaluriDashboardMedic(pUser: user, pParola: userPassMD5);

        ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
          pUser: user,
          pParola: userPassMD5,
          pDeviceToken: deviceToken,
          pTipDispozitiv: Platform.isAndroid ? '1' : '2',
          pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
          pTokenVoip: '',
        );

        if (resGetCont != null && resGetTotaluriDashboardMedic != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                contMedicMobile: resGetCont,
                totaluriMedic: resGetTotaluriDashboardMedic,
              ),
            ),
          );
        } else {}
      } else {}
    } catch (e) {
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _getRequestIcon(dynamic tip) {
    IconData icon;
    if (tip is String) tip = int.tryParse(tip);
    switch (tip) {
      case 1:
        icon = Icons.phone;
        break;
      case 2:
        icon = Icons.analytics;
        break;
      case 3:
        icon = Icons.chat;
        break;
      default:
        icon = Icons.help;
    }
    return Icon(
      icon,
      size: 80,
      color: const Color.fromRGBO(30, 214, 158, 1),
    );
  }

  Map<String, dynamic> _parseAdditionalData(String rawData) {
    try {
      String validJson = rawData
          .replaceAllMapped(
            RegExp(r'(\w+):'),
            (match) => '"${match.group(1)}":',
          )
          .replaceAll("'", '"')
          .replaceAllMapped(
            RegExp(r':\s*([^,}]+)'),
            (match) => ': "${match.group(1)?.trim()}"',
          )
          .replaceAll('}"', '}');
      return json.decode(validJson) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    resetStateOnEnter();
  }

  Future<void> resetStateOnEnter() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 90,
            backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
            foregroundColor: Colors.white,
            title: Text(
              'Confirmare',
              style: GoogleFonts.rubik(
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: WillPopScope(
            onWillPop: () async => false,
            child: FutureBuilder<Map<String, dynamic>>(
              future: getNotificationData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Eroare la încărcarea datelor de notificare'));
                } else {
                  final notificationData = snapshot.data!;
                  final String body = notificationData['body'];
                  final String rawData = notificationData['data'];

                  final Map<String, dynamic> additionalData = _parseAdditionalData(rawData);

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(height: 50),
                            _getRequestIcon(additionalData['tip']),
                            const SizedBox(height: 20),
                            Text(
                              body,
                              style: GoogleFonts.rubik(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 130),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLoading = true;
                                });

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
                                Map<String, dynamic> additionalData = _parseAdditionalData(rawData);
                                String body = additionalData['body'] ?? '0';
                                String tip = additionalData['tip']?.toString() ?? 'unknown';

                                String patientId = prefs.getString(pref_keys.userId) ?? '';
                                String patientNume = prefs.getString(pref_keys.userNume) ?? '';
                                String patientPrenume = prefs.getString(pref_keys.userPrenume) ?? '';

                                int pIdPacient = int.tryParse(body.replaceAll('\$', '').trim()) ?? 0;
                                String pTip = tip;
                                String pObservatii = '$patientId\$#\$$patientPrenume $patientNume';

                                String pCheie = keyAppPacienti;
                                String pMesaj =
                                    'Răspunsul doctorului ${widget.contMedicMobile.titulatura} ${widget.contMedicMobile.numeComplet} : Confirmare';

                                ApiCallFunctions apiCallFunctions = ApiCallFunctions();
                                await apiCallFunctions.TrimitePushPrinOneSignalCatrePacient(
                                  pCheie: pCheie,
                                  pIdPacient: pIdPacient,
                                  pTip: pTip,
                                  pMesaj: pMesaj,
                                  pObservatii: pObservatii,
                                );

                                await Future.delayed(const Duration(seconds: 2));

                                setState(() {
                                  isLoading = false;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WaitingForPaymentScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(30, 214, 158, 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Confirmare",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 17),
                            GestureDetector(
                              onTap: () async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
                                Map<String, dynamic> additionalData = _parseAdditionalData(rawData);
                                String body = additionalData['body'] ?? '0';
                                String tip = additionalData['tip']?.toString() ?? 'unknown';

                                String patientId = prefs.getString(pref_keys.userId) ?? '';
                                String patientNume = prefs.getString(pref_keys.userNume) ?? '';
                                String patientPrenume = prefs.getString(pref_keys.userPrenume) ?? '';

                                int pIdPacient = int.tryParse(body.replaceAll('\$', '').trim()) ?? 0;
                                String pTip = tip;
                                String pObservatii = '$patientId\$#\$$patientPrenume $patientNume';

                                String pCheie = keyAppPacienti;
                                String pMesaj =
                                    'Răspunsul doctorului ${widget.contMedicMobile.titulatura} ${widget.contMedicMobile.numeComplet} : Respingere';

                                ApiCallFunctions apiCallFunctions = ApiCallFunctions();
                                await apiCallFunctions.TrimitePushPrinOneSignalCatrePacient(
                                  pCheie: pCheie,
                                  pIdPacient: pIdPacient,
                                  pTip: pTip,
                                  pMesaj: pMesaj,
                                  pObservatii: pObservatii,
                                );

                                await Future.delayed(const Duration(seconds: 2));

                                setState(() {
                                  isLoading = false;
                                });
                                // setState(() {
                                //   isLoading = true;
                                // });
                                navigateToDashboard(context);
                                // setState(() {
                                //   isLoading = false;
                                // });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(30, 214, 158, 1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Respingere",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
