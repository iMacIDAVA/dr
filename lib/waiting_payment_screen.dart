import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/apel_video_medic_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/chestionar_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/first_intermediate_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/fouth_intermidate_screen.dart';
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
  Future<void> navigateToIntermediateScreen(String alertMessage,) async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    String? userPassMD5 = prefs.getString('userPassMD5');


    String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
    print('📡 Raw Notification Data: $rawData');

    // Parse the raw data
    Map<String, dynamic> additionalData = _parseAdditionalData(rawData);
    String bodyString = additionalData['body'] ?? '0';

    // Extract the name from the notification body
    String notificationBody = prefs.getString(pref_keys.notificationBody) ?? '';
    print('📩 Notification Body: $notificationBody');

    // Extract Patient Name
    final nameRegex = RegExp(r'Starea plății de la (.+):');
    final match = nameRegex.firstMatch(notificationBody);
    String patientName = match != null ? match.group(1) ?? 'Unknown' : 'Unknown';

    int pIdPacient = int.tryParse(bodyString.replaceAll('\$', '').trim()) ?? 0;
    int userId = int.tryParse(user!) ?? 0;

    if ( userPassMD5 == null) {
      print("❌ Error: Missing user credentials.");
      return;
    }

    print("📡 Fetching Chestionar with:");
    print("  - pUser: $user");
    print("  - pParola: $userPassMD5");
    print("  - pIdClient: $pIdPacient");

    ChestionarClientMobile? resGetUltimulChestionarCompletatByContMedic =
    await apiCallFunctions.getUltimulChestionarCompletatByContMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdClient: pIdPacient.toString(),
    );

    if (resGetUltimulChestionarCompletatByContMedic == null) {
      print("❌ API returned NULL for Chestionar! Continuing navigation...");
      resGetUltimulChestionarCompletatByContMedic = ChestionarClientMobile(
        numeCompletat: "",
        prenumeCompletat: "",
        dataNastereCompletata: DateTime.now(),
        greutateCompletata: "",
        listaRaspunsuri: [],
      );
    }

    try {
      print("✅ API Response Received: ${jsonEncode(resGetUltimulChestionarCompletatByContMedic)}");
    } catch (e) {
      print("❌ Error serializing ChestionarClientMobile: $e");
    }

    if (isNavigating) {
      print("⚠️ Already navigating, ignoring...");
      return;
    }
    isNavigating = true;

    print("🚀 Proceeding with Navigation...");

    // ✅ **Step 1: Navigate to FirstIntermediateScreen**
    print("🛑 Navigating to FirstIntermediateScreen...");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FirstIntermediateScreen(
          onContinueToSecond: () {
            print("✅ FirstIntermediateScreen Completed. Moving to SecondIntermediateScreen...");

            // ✅ **Step 2: Navigate to SecondIntermediateScreen**
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SecondIntermediateScreen(
                  onContinueToConfirm: () {
                    print("✅ SecondIntermediateScreen Completed. Checking if ThirdIntermediateScreen is needed...");

                    if (widget.page == "întrebare" || widget.page == "apel") {
                      print("🛑 Navigating to ThirdIntermediateScreen...");
                      // ✅ **Step 3: Navigate to ThirdIntermediateScreen**
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdIntermediateScreen(
                            done: () {
                              print("✅ ThirdIntermediateScreen Done. Navigating to ChestionarScreen...");
                              // ✅ **Final Step: Move to ChestionarScreen**
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChestionarScreen(
                                    chestionar: resGetUltimulChestionarCompletatByContMedic!,
                                    page: widget.page,
                                    onContinue: () async {
                                      print("✅ ChestionarScreen Completed. Moving to Confirm Screen...");
                                  if (widget.page == "apel"){
                                    CallService callService = CallService(idClient: pIdPacient);
                                    callService.startPolling();

                                    //     await Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => ApelVideoMedicScreen(
                                    //      remoteUid: 1,
                                    //     ),
                                    //   ),
                                    // );
                                  }
                                  else if (widget.page == "întrebare"){
                                    await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RaspundeIntrebareDoarChatScreen(
                                          idClient: pIdPacient,
                                          idMedic: userId,
                                          textNume: 'Patient Name',
                                          iconPathPacient: 'assets/images/default_patient_icon.png',
                                          numePacient: patientName,
                                        ),
                                      ),
                                    );
                                  }

                                    },
                                  ),
                                ),
                              );
                            },
                            failed: () {
                              print("❌ ThirdIntermediateScreen Failed. Navigating to Reject Screen...");
                              navigateToRejectScreen("Pacientul nu a reușit să termine întrebările");
                            },
                          ),
                        ),
                      );
                    } else if (widget.page == "recomandare") {
                      print("🛑 Skipping ThirdIntermediateScreen, Navigating to RecomandareScreen...");
                      // ✅ Skip ThirdIntermediateScreen, go directly to RecomandareScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RaspundeIntrebareMedicScreen(
                            idClient: pIdPacient,
                            idMedic: userId,
                            textNume: 'Patient Name',
                            iconPathPacient: 'assets/images/default_patient_icon.png',
                            numePacient: patientName,
                          ),
                        ),
                      );


                    } else {
                      print("🛑 Directly Navigating to Confirm Screen...");
                      navigateToConfirmScreen(alertMessage);
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





// Future<void> navigateToIntermediateScreen(String alertMessage) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? userEmail = prefs.getString('userEmail');
//   String? userPassMD5 = prefs.getString('userPassMD5');

//   if (userEmail == null || userPassMD5 == null) {
//     return;
//   }

//   if (isNavigating) return;
//   isNavigating = true;

//   // 🚀 Directly call navigateToConfirmScreen based on widget.page
//   if (widget.page == "apel") {
//     CallService callService = CallService();
//     callService.startPolling();
//   }

//   navigateToConfirmScreen(alertMessage);
// }




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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
    Map<String, dynamic> additionalData = _parseAdditionalData(rawData);

    String bodyString = additionalData['body']?.toString() ?? '0';
    int pIdPacient = int.tryParse(bodyString.replaceAll('\$', '').trim()) ?? 0;

    print("Extracted pIdPacient: $pIdPacient");

    if (alertMessage != null && alertMessage.toLowerCase().contains('plătit')) {
      if (pIdPacient > 0) {
        navigateToIntermediateScreen(alertMessage);
        // navigateToConfirmScreen(alertMessage);
      } else {
        print("Error: Invalid pIdPacient extracted.");
      }
    } else if (alertMessage!.toLowerCase().contains('a eșuat')) {
      navigateToRejectScreen(alertMessage);
    } else if (alertMessage.toLowerCase().contains('părăsit sesiunea')) {
      navigateToRejectScreen("Pacientul a părăsit sesiunea după 3 minute.");
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
    print("🚀 navigateToConfirmScreen CALLED with body: $body");

    if (isNavigating) {
      print("⚠️ Already navigating, resetting flag...");
      isNavigating = false; // Reset isNavigating so navigation can proceed
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('userId') ?? '';
    String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
    print('📡 Raw Notification Data: $rawData');

    // Parse the raw data
    Map<String, dynamic> additionalData = _parseAdditionalData(rawData);
    String bodyString = additionalData['body'] ?? '0';

    // Extract the name from the notification body
    String notificationBody = prefs.getString(pref_keys.notificationBody) ?? '';
    print('📩 Notification Body: $notificationBody');

    // Extract Patient Name
    final nameRegex = RegExp(r'Starea plății de la (.+):');
    final match = nameRegex.firstMatch(notificationBody);
    String patientName = match != null ? match.group(1) ?? 'Unknown' : 'Unknown';

    int pIdPacient = int.tryParse(bodyString.replaceAll('\$', '').trim()) ?? 0;
    int userId = int.tryParse(user) ?? 0;

    if (isNavigating) {
      print("⚠️ Still navigating, skipping...");
      return;
    }
    isNavigating = true;

    print("✅ Proceeding with navigation...");

    try {
      if (widget.page == "apel") {
        CallService callService = CallService(idClient: pIdPacient);
        callService.startPolling();
      } else if (widget.page == "întrebare") {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RaspundeIntrebareDoarChatScreen(
              idClient: pIdPacient,
              idMedic: userId,
              textNume: 'Patient Name',
              iconPathPacient: 'assets/images/default_patient_icon.png',
              numePacient: patientName,
            ),
          ),
        );
      } else if (widget.page == "recomandare") {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RaspundeIntrebareMedicScreen(
              idClient: pIdPacient,
              idMedic: userId,
              textNume: 'Patient Name',
              iconPathPacient: 'assets/images/default_patient_icon.png',
              numePacient: patientName,
            ),
          ),
        );
      }
    } catch (e) {
      print("❌ Error during navigation: $e");
    } finally {
      print("🔄 Resetting isNavigating...");
      isNavigating = false; // Ensure flag resets after navigation completes
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async => false,
      child: Scaffold(
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
      ),
    );
  }
}
