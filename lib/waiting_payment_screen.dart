import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/payment_failed_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

class WaitingForPaymentScreen extends StatefulWidget {
  const WaitingForPaymentScreen({Key? key}) : super(key: key);

  @override
  State<WaitingForPaymentScreen> createState() => _WaitingForPaymentScreenState();
}

class _WaitingForPaymentScreenState extends State<WaitingForPaymentScreen> {
  bool isActive = false;
  bool isNavigating = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isActive = true;
    startTimer();
    initNotificationListener();
  }

  @override
  void dispose() {
    isActive = false;
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer(const Duration(seconds: 30), () {
      if (isActive && !isNavigating) {
        navigateToRejectScreen("Pacientul nu a plătit");
      }
    });
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

    timer?.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationReject(
          body: body ?? "Plata nu a reușit",
        ),
      ),
    );
  }

  void navigateToConfirmScreen(String? body) {
    if (isNavigating) return;
    isNavigating = true;

    timer?.cancel();

    // Uncomment and add your success screen here
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PaymentSuccessScreen(
    //       body: body ?? "Payment successful.",
    //     ),
    //   ),
    // );
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
