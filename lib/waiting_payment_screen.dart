import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/chestionar_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/first_intermediate_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/payment_failed_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_doar_chat_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_medic_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/second_intermediate_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/third_intermediate_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/agora_call_service.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

class WaitingForPaymentScreen extends StatefulWidget {
  final String page;

  const WaitingForPaymentScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<WaitingForPaymentScreen> createState() => _WaitingForPaymentScreenState();
}

class _WaitingForPaymentScreenState extends State<WaitingForPaymentScreen> {
  bool isActive = false;
  bool isNavigating = false;
  // Timer? _timeoutTimer;

  int remainingTime = 180;
  Timer? countdownTimer;

  ApiCallFunctions apiCallFunctions = ApiCallFunctions();


  ValueNotifier<int> remainingTimeNotifier = ValueNotifier(180);

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimeNotifier.value > 0) {
        remainingTimeNotifier.value--;
      } else {
        timer.cancel();
        navigateToRejectScreen('Pacientul nu a plătit în 3 minute');
      }
    });
  }// 3 minutes

  @override
  void initState() {
    super.initState();
    isActive = true;
    initNotificationListener();

    startTimer();

    // Start a 30-second timer
    // _timeoutTimer = Timer(const Duration(seconds: 150), () {
    //
    //     // Navigate to the dashboard or home screen
    //     navigateToRejectScreen("Timpul de așteptare a expirat"); // Pass a default message
    //
    // });
  }


  @override
  void dispose() {
    isActive = false;
    // _timeoutTimer?.cancel(); // Cancel the timer

    remainingTimeNotifier.dispose();

    super.dispose();
  }


  void initNotificationListener() {
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      saveNotificationData(event.notification);
    });

    OneSignal.Notifications.addClickListener((event) {
      saveNotificationData(event.notification);
    });
  }

  Future<void> navigateToIntermediateScreen(String alertMessage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    String? userPassMD5 = prefs.getString('userPassMD5');

    if (userEmail == null || userPassMD5 == null) {
      return;
    }

    ChestionarClientMobile? resGetUltimulChestionarCompletatByContMedic =
    await apiCallFunctions.getUltimulChestionarCompletatByContMedic(
      pUser: userEmail,
      pParola: userPassMD5,
      pIdClient: '1',
    );

    if (isNavigating) return;
    isNavigating = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstIntermediateScreen(
          onContinueToSecond: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SecondIntermediateScreen(
                  onContinueToConfirm: () {
                    if (widget.page == "întrebare" || widget.page == "apel") {
                      if (resGetUltimulChestionarCompletatByContMedic != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChestionarScreen(
                              chestionar: resGetUltimulChestionarCompletatByContMedic,
                              page: widget.page,
                              onContinue: () {
                                navigateToConfirmScreen(alertMessage);
                              },
                            ),
                          ),
                        );
                      } else {
                        debugPrint('Failed to fetch chestionar data.');
                      }
                    } else if (widget.page == "recomandare") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecomandareScreen(
                            onContinue: () {
                              navigateToConfirmScreen(alertMessage);
                            },
                          ),
                        ),
                      );
                    } else {
                      navigateToConfirmScreen(alertMessage); // Final step
                    }
                  },
                  page: widget.page,
                ),
              ),
            );
          },
        ),
      ),
    );
  }







  Future<void> saveNotificationData(OSNotification notification) async {
    if (!isActive || isNavigating) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(pref_keys.notificationTitle, notification.title ?? 'Fără Titlu');
    await prefs.setString(pref_keys.notificationBody, notification.body ?? 'Fără corp');
    await prefs.setString(pref_keys.notificationData, notification.additionalData?.toString() ?? 'Fără date');

    handleNotification(notification);
  }

  void handleNotification(OSNotification notification) async {
    String? alertMessage = notification.body;

    if (countdownTimer != null && countdownTimer!.isActive) {
      countdownTimer!.cancel();
    }

    if (alertMessage != null) {
      if (alertMessage.toLowerCase().contains('plătit')) {
        navigateToIntermediateScreen(alertMessage);
      } else if (alertMessage.toLowerCase().contains('a eșuat')) {
        navigateToRejectScreen(alertMessage);
      }
    }
  }


  void navigateToRejectScreen(String? body) {
    if (isNavigating) return;
    isNavigating = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationReject(
          body: body ?? "Plata nu a reușit",
        ),
      ),
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

  Future<void> navigateToConfirmScreen(String? body) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('userId') ?? '';
    String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
    print('rawwwwwww data : $rawData');

    // Parse the raw data
    Map<String, dynamic> additionalData = _parseAdditionalData(rawData);
    String body = additionalData['body'] ?? '0';

    // Extract the name from the notification body
    String notificationBody = prefs.getString(pref_keys.notificationBody) ?? '';
    print('Notification Body: $notificationBody');

    // Extract the name using a regular expression
    final nameRegex = RegExp(r'Starea plății de la (.+):');
    final match = nameRegex.firstMatch(notificationBody);
    String patientName = match != null ? match.group(1) ?? 'Unknown' : 'Unknown';

    int pIdPacient = int.tryParse(body.replaceAll('\$', '').trim()) ?? 0;
    int UserId = int.parse(user);

    if (isNavigating) return;
    isNavigating = true;

    if (widget.page == "apel") {
      CallService callService = CallService();
      callService.startPolling();
    }
    else if (widget.page == "întrebare") {


      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RaspundeIntrebareDoarChatScreen(
            idClient: pIdPacient, // Client ID from additional data
            idMedic: UserId, // User ID from preferences
            textNume: 'Patient Name', // Replace with the extracted name
            iconPathPacient: 'assets/images/default_patient_icon.png', // Default icon path
            numePacient: patientName, // Extracted patient's name
          ),
        ),
      );
    }
    else if (widget.page == "recomandare"){
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RaspundeIntrebareMedicScreen(
            idClient: pIdPacient, // Client ID from additional data
            idMedic: UserId, // User ID from preferences
            textNume: 'Patient Name', // Replace with the extracted name
            iconPathPacient: 'assets/images/default_patient_icon.png', // Default icon path
            numePacient: patientName, /// Extracted patient's name
          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: 90,
      //   backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
      //   foregroundColor: Colors.white,
      //   title: Text(
      //     'Plata in asteptare',
      //     style: GoogleFonts.rubik(
      //       color: const Color.fromRGBO(255, 255, 255, 1),
      //       fontSize: 16,
      //       fontWeight: FontWeight.w500,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Așteptați confirmarea plății',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  Text(
                    'Aceasta operațiune poate dura \n maxim 3 minute',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // CircularProgressIndicator(
                  //   strokeWidth: 4,
                  //   color: Colors.grey,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
