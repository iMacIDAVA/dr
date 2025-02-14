import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ThirdIntermediateScreen extends StatefulWidget {
  final VoidCallback done;
  final VoidCallback failed;

  const ThirdIntermediateScreen({
    Key? key,
    required this.done,
    required this.failed,
  }) : super(key: key);

  @override
  State<ThirdIntermediateScreen> createState() => _ThirdIntermediateScreenState();
}

class _ThirdIntermediateScreenState extends State<ThirdIntermediateScreen> {
  bool isActive = false;

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
      handleNotification(event.notification);
    });

    OneSignal.Notifications.addClickListener((event) {
      handleNotification(event.notification);
    });
  }

  void handleNotification(OSNotification notification) {
    if (!isActive) return;

    String? alertMessage = notification.body;
    if (alertMessage == null) return;

    print("📩 Received notification: $alertMessage");

    if (alertMessage.contains("Pacientul a terminat întrebările")) {
      print("✅ Proceeding to next step...");
      widget.done();
    } else if (alertMessage.contains("Pacientul a părăsit sesiunea după 3 minute de inactivitate.")) {
      print("❌ Navigating to rejection...");
      widget.failed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
      body: WillPopScope(
        onWillPop: () async => false,
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
              child: Text(
                'Vă rugăm să așteptați până când pacientul termină',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
