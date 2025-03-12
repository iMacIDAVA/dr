import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class RaspundeIntrebareDoarChatScreen extends StatefulWidget {
  final String textNume;
  final int idClient;
  final int idMedic;
  final String iconPathPacient;
  final String numePacient;

  const RaspundeIntrebareDoarChatScreen({
    super.key,
    required this.textNume,
    required this.idClient,
    required this.idMedic,
    required this.iconPathPacient,
    required this.numePacient,
  });

  @override
  State<RaspundeIntrebareDoarChatScreen> createState() => _RaspundeIntrebareDoarChatScreenState();
}

class _RaspundeIntrebareDoarChatScreenState extends State<RaspundeIntrebareDoarChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _messageUpdateTimer;

  ApiCallFunctions apiCallFunctions = ApiCallFunctions();

  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessagesFromList();
    _startPeriodicFetching();



    _messageController.addListener(() {
      setState(() {
        isTyping = _messageController.text.isNotEmpty;
      });
    });

    OneSignal.Notifications.addForegroundWillDisplayListener(_onNotificationDisplayed);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

@override
void dispose() {
  _messageUpdateTimer?.cancel();

  if (mounted) {
    _messageController.removeListener(() {});
  }

  _messageController.dispose(); // ✅ Dispose safely
  _scrollController.dispose();

  OneSignal.Notifications.removeForegroundWillDisplayListener(_onNotificationDisplayed);

  super.dispose();
}



  int remainingTime = 180;
  Timer? countdownTimer;

  ValueNotifier<int> remainingTimeNotifier = ValueNotifier(180);

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTimeNotifier.value > 0) {
        remainingTimeNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _showWaitingForPaymentDialog() {
    if (ModalRoute.of(context)?.isCurrent != true) return;
    remainingTimeNotifier.value = 180;
    countdownTimer?.cancel(); // Prevent multiple timers
    if (countdownTimer == null || !countdownTimer!.isActive) {
  startTimer();
}

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              titlePadding: const EdgeInsets.all(16),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.white,
              title: Column(
                children: [
                  // Timer Icon
                  const Icon(
                    Icons.timer,
                    size: 50,
                    color: Color.fromRGBO(30, 214, 158, 1), // Same Green as Buttons
                  ),
                  const SizedBox(height: 10),
                  // Countdown Timer with Animated Dot
                  ValueListenableBuilder<int>(
                    valueListenable: remainingTimeNotifier,
                    builder: (context, remainingTime, _) {
                      if (remainingTime == 0) {
                        _closeDialogAndNavigate();
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: remainingTime % 2 == 0
                                  ? Colors.red
                                  : Colors.transparent, // Blinking effect
                              border: Border.all(color: Colors.red, width: 1.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(30, 214, 158, 1),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // Title Text
                  Text(
                    "Așteptați plata pacientului",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(103, 114, 148, 1),
                    ),
                  ),
                ],
              ),
              content: const Text(
                "Vă rugăm să așteptați până când pacientul efectuează plata.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
                   actions: [
              TextButton(
                onPressed: () {
                  _closeDialogAndNavigate(); // ✅ Close dialog when button is pressed
                },
                child: const Text(
                  "Închide", // "Close" in Romanian
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            );
          },
        );
      },
    );
  }

// Method to close the dialog and navigate to Dashboard
  void _closeDialogAndNavigate() {
   if (countdownTimer != null && countdownTimer!.isActive) {
  countdownTimer?.cancel();
}
Navigator.pop(context);

  }

// Method to Dispose Resources and Navigate
void _disposeAndNavigate() {
  if (!mounted) return;

  countdownTimer?.cancel();
  _messageUpdateTimer?.cancel();

  if (!_isExiting) {
    _isExiting = true;

    // ✅ Remove controller from TextField before disposing
    setState(() {
      _messageController.text = ""; // Clear text
    });

    _messageController.removeListener(() {});
    _messageController.dispose();

    if (_scrollController.hasClients) {
      _scrollController.dispose();
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        navigateToDashboard(context);
      }
    });
  }
}



  void _onNotificationDisplayed(OSNotificationWillDisplayEvent event) {
    final notification = event.notification;
    final String? notificationBody = notification.body?.trim();

    if (notificationBody != null) {
      if (notificationBody.contains("Pacientul a părăsit consultația")) {
        print("📢 Notification: Patient left the consultation!");

        Future.delayed(Duration(seconds: 1), () {
          navigateToDashboard(context); // 🚀 Auto-navigate to the dashboard
        });
      } else if (notificationBody.contains("Vă rugăm să așteptați plata pacientului")) {
        print("📢 Notification: Waiting for payment!");

        // 🚀 Show a confirmation dialog or perform an action
        _showWaitingForPaymentDialog();
      }
    }

    OneSignal.Notifications.displayNotification(notification.notificationId!);
  }



  void _startPeriodicFetching() {
    _messageUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadMessagesFromList();
    });
  }

Future<void> _loadMessagesFromList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') ?? '';
    String medicId = prefs.getString('userId') ?? '';
  String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

  List<MesajConversatieMobile> listaMesaje = await apiCallFunctions.getListaMesajePeConversatie(
        pUser: user,
        pParola: userPassMD5,
        pIdConversatie: medicId, // ✅ Use correct conversation ID
      ) ?? [];

  if (!mounted) return;


  for (var msg in listaMesaje) {
  
  }

  setState(() {
    _messages.clear(); // ✅ Clear messages to avoid duplication

_messages.addAll(
  listaMesaje
      .where((e) {
        String text = e.comentariu.trim().toLowerCase(); // Normalize text
        RegExp pattern = RegExp(r"^https?:\/\/sosbebe|^(file|photo)\s*attachment", caseSensitive: false);

        // ✅ Exclude both attachment links AND the "medicul a părăsit consultația" message
        return !pattern.hasMatch(text) && !text.contains("medicul a părăsit consultația");
      })
      .map((e) {
        bool isDoctorMessage = e.idExpeditor.toString() == medicId; // ✅ Identify doctor messages
        return {
          "text": e.comentariu,
          "isDoctorMessage": isDoctorMessage,
        };
      })
      .toList(),
);


  });

  Future.delayed(const Duration(milliseconds: 100), () {
    if (mounted) _scrollToBottom();
  });

}

  Future<void> navigateToDashboard(BuildContext context) async {
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
    } finally {}
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }


void _handleSendMessage() async {
  if (!mounted || _messageController.text.isEmpty) return;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') ?? '';
  String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

  String message = _messageController.text;

  await apiCallFunctions.adaugaMesajDinContMedic(
    pUser: user,
    pParola: userPassMD5,
    pIdClient: widget.idClient.toString(),
    pMesaj: message,
  );

  if (mounted) {
    setState(() {
      _messages.add({"text": message, "isDoctorMessage": true});
      _messageController.clear();
    });

    _scrollToBottom();
  }
}


  bool _isExiting = false;
  Future<void> _sendExitMessage() async {
    if (_isExiting) return;
    _isExiting = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    try {
      await apiCallFunctions.adaugaMesajDinContMedic(
        pUser: user,
        pParola: userPassMD5,
        pIdClient: widget.idClient.toString(),
        pMesaj: "medicul a părăsit consultația",
      );
      _disposeAndNavigate();
    } catch (e) {
      print("⚠️ Error sending exit message: $e");
    }
    navigateToDashboard(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          toolbarHeight: 75,
          // leading: IconButton(
          //   icon: const Icon(Icons.exit_to_app, color: Colors.black),
          //   onPressed: () async {
          //     // Show confirmation dialog before sending the exit message
          //     final shouldExit = await showDialog<bool>(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //         title: const Text("Confirmați Ieșirea"),
          //         content: const Text("Chiar vrei să părăsești chat-ul?"),
          //         actions: [
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, false),
          //             child: const Text("Anula"),
          //           ),
          //           TextButton(
          //             onPressed: () => Navigator.pop(context, true),
          //             child: const Text("Da"),
          //           ),
          //         ],
          //       ),
          //     );
          //
          //     if (shouldExit == true) {
          //       showDialog(
          //         context: context,
          //         barrierDismissible: false,
          //         builder: (context) => const Center(
          //           child: CircularProgressIndicator(),
          //         ),
          //       );
          //
          //       try {
          //         // Send the exit message explicitly when the user confirms
          //         await _sendExitMessage();
          //
          //         // Navigate to the dashboard
          //         Navigator.pop(context); // Close the loading dialog
          //         navigateToDashboard(context);
          //       } catch (e) {
          //         // Close the loading dialog
          //         Navigator.pop(context);
          //
          //         // Show an error message
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text("Failed to send exit message")),
          //         );
          //       }
          //     }
          //   },
          // ),
          leading: const SizedBox(),
          title: Text(
            widget.numePacient,
            style: GoogleFonts.rubik(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isDoctorMessage = message['isDoctorMessage'] as bool;
    
                  return Align(
                    alignment: isDoctorMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDoctorMessage
                            ? const Color.fromRGBO(14, 190, 127, 1)
                            : const Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                          bottomLeft: Radius.circular(isDoctorMessage ? 10 : 0),
                          bottomRight: Radius.circular(isDoctorMessage ? 0 : 10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        message['text'] as String,
                        style: TextStyle(
                          color: isDoctorMessage ? Colors.white : Colors.black,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: "Scrie text...",
                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 5,
                          bottom: 5,
                          child: Visibility(
                            visible: isTyping, // ✅ Hide when not typing
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(14, 190, 127, 1), // ✅ Green background (only when typing)
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: IconButton(
                                onPressed: _handleSendMessage,
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 5,
                          bottom: 5,
                          child: Visibility(
                            visible: !isTyping, // ✅ Hide "GATA" when typing
                            child: GestureDetector(
                              onTap: () async {
                                await _sendExitMessage();
                                _disposeAndNavigate();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                    child: Text(
                                      'GATA',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
