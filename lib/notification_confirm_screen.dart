import 'dart:async';
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
  final String page;

  const NotificationDetailsScreen({Key? key, required this.contMedicMobile, required this.totaluriMedic, required this.page})
      : super(key: key);

  @override
  State<NotificationDetailsScreen> createState() => _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {

  int remainingTime = 180;
  Timer? countdownTimer;

  ValueNotifier<int> remainingTimeNotifier = ValueNotifier(180);


  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimeNotifier.value > 0) {
        remainingTimeNotifier.value--;
      } else {
        timer.cancel();
        handleTimeout();
      }
    });
  }



  void handleTimeout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
    Map<String, dynamic> additionalData = _parseAdditionalData(rawData);

    String body = additionalData['body'] ?? '0';
    String tip = additionalData['tip']?.toString() ?? 'unknown';

    String patientId = prefs.getString(pref_keys.userId) ?? '';
    String patientNume = prefs.getString(pref_keys.userNume) ?? '';
    String patientPrenume = prefs.getString(pref_keys.userPrenume) ?? '';

    String pCheie = keyAppPacienti;
    String pObservatii = '$patientId\$#\$$patientPrenume $patientNume';
    String pMesaj = 'Răspunsul doctorului Respingere';

    ApiCallFunctions apiCallFunctions = ApiCallFunctions();
    await apiCallFunctions.TrimitePushPrinOneSignalCatrePacient(
      pCheie: pCheie,
      pIdPacient: int.tryParse(body) ?? 0,
      pTip: tip,
      pMesaj: pMesaj,
      pObservatii: pObservatii,
    );

    navigateToDashboard(context);
  }



  bool isLoading = false;
  Timer? _autoCloseTimer;

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

  Widget _getRequestIcon() {
    IconData icon;
    switch (widget.page.toLowerCase()) {
      case 'întrebare':
        icon = Icons.chat_rounded;
        break;
      case 'recomandare':
        icon = Icons.analytics;
        break;
      case 'apel':
        icon = Icons.phone;
        break;
      default:
        icon = Icons.help;
    }
    return Icon(
      icon,
      size: 80,
      color: Colors.white,
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

    startTimer();

    // _autoCloseTimer = Timer(const Duration(seconds: 30), () {
    //   // Automatically navigate when timer expires
    //   navigateToDashboard(context);
    // });

  }

  @override
  void dispose() {
    // Cancel the timer if the user leaves the screen before it expires
    remainingTimeNotifier.dispose();
    super.dispose();
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
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   toolbarHeight: 90,
          //   backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          //   foregroundColor: Colors.white,
          //   title: Text(
          //     'Confirmare',
          //     style: GoogleFonts.rubik(
          //       color: const Color.fromRGBO(255, 255, 255, 1),
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          //   centerTitle: true,
          // ),
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

                  return Padding(
                    padding: const EdgeInsets.only(top: 88.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(30, 214, 158, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 50),
                              _getRequestIcon(),
                              const SizedBox(height: 20),
                              Text(
                                body,
                                style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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
                                      builder: (context) => WaitingForPaymentScreen(page: widget.page),
                                    ),
                                  );

                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color:  Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "ACCEPTĂ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color.fromRGBO(30, 214, 158, 1),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 27),
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
                                    color:  Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "REFUZĂ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:  Colors.red,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),

                              Padding(
                                padding: const EdgeInsets.only(left: 98.0, right: 98.0),
                                child: Container(
                                  color: Colors.white.withOpacity(0.3), // Faded white background
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ValueListenableBuilder<int>(
                                        valueListenable: remainingTimeNotifier,
                                        builder: (context, remainingTime, _) {
                                          return Text(
                                            "${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),


                              const SizedBox(height: 100),
                            ],
                          ),
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
