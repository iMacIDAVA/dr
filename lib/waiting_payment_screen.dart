import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/payment_failed_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_doar_chat_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_medic_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/agora_call_service.dart';

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

  @override
  void initState() {
    super.initState();
    isActive = true;
    initNotificationListener();
  }

  @override
  void dispose() {
    isActive = false;
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
    if (alertMessage != null) {
      if (alertMessage.toLowerCase().contains('plătit')) {
        navigateToConfirmScreen(alertMessage);
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        title: Text(
          'Plata in asteptare',
          style: GoogleFonts.rubik(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
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
                    'Astept ca pacientul sa plateasca',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  CircularProgressIndicator(
                    strokeWidth: 4,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
