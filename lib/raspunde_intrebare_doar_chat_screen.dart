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
  State<RaspundeIntrebareDoarChatScreen> createState() =>
      _RaspundeIntrebareDoarChatScreenState();
}

class _RaspundeIntrebareDoarChatScreenState extends State<RaspundeIntrebareDoarChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _messageUpdateTimer;

  ApiCallFunctions apiCallFunctions = ApiCallFunctions();

  @override
  void initState() {
    super.initState();
    _loadMessagesFromList();
    _startPeriodicFetching();

    // Suppress notifications while on this screen
    OneSignal.Notifications.addForegroundWillDisplayListener(_onNotificationDisplayed);
  }

  @override
  void dispose() {
    _messageUpdateTimer?.cancel();
    _scrollController.dispose();
    _messageController.dispose();

    // Remove the listener when leaving the screen
    OneSignal.Notifications.removeForegroundWillDisplayListener(_onNotificationDisplayed);

    super.dispose();
  }

  void _onNotificationDisplayed(OSNotificationWillDisplayEvent event) {
    final notification = event.notification;

    // Suppress notifications containing "Aveți un mesaj" in the alert text
    if (notification.body != null && notification.body!.contains('Aveți un mesaj')) {
      // Suppress the notification
      OneSignal.Notifications.preventDefault(notification.notificationId!);
      return;
    }

    // Allow other notifications to show
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
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    List<MesajConversatieMobile> listaMesaje = await apiCallFunctions.getListaMesajePeConversatie(
      pUser: user,
      pParola: userPassMD5,
      pIdConversatie: widget.idMedic.toString(),
    ) ?? [];

    if (mounted) {
      setState(() {
        _messages.clear();
        _messages.addAll(
          listaMesaje
              .where((e) {
            final text = e.comentariu.trim();
            final isUrl = text.startsWith('http://') || text.startsWith('https://');
            final hasFileAttachment = text.endsWith('.jpg') ||
                text.endsWith('.png') ||
                text.endsWith('.jpeg') ||
                text.endsWith('.gif') ||
                text.endsWith('.Pacientul a părăsit chatul') ||
                text.endsWith('.pdf') ||
                text.contains("File Attachment"
                );
            return !isUrl && !hasFileAttachment;
          })
              .map((e) {
            bool isDoctorMessage = e.idExpeditor == widget.idMedic;
            return {
              "text": e.comentariu,
              "isDoctorMessage": isDoctorMessage,
            };
          })
              .toList(),
        );
      });

      if (listaMesaje.isNotEmpty &&
          listaMesaje.last.comentariu.trim() == "Pacientul a părăsit chatul") {
        navigateToDashboard(context);
      }

      _scrollToBottom();
    }
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
    } finally {

    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _handleSendMessage() async {
    if (_messageController.text.isEmpty) return;

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

    setState(() {
      _messages.add({"text": message, "isDoctorMessage": true});
      _messageController.clear();
    });

    _scrollToBottom();
  }

  Future<void> _sendExitMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    try {
      await apiCallFunctions.adaugaMesajDinContMedic(
        pUser: user,
        pParola: userPassMD5,
        pIdClient: widget.idClient.toString(),
        pMesaj: "Doctorul a părăsit chatul",
      );
    } catch (e) {
      print("Error sending exit message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black),
          onPressed: () async {
            // Show confirmation dialog before sending the exit message
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirmați Ieșirea"),
                content: const Text("Chiar vrei să părăsești chat-ul?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Anula"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Da"),
                  ),
                ],
              ),
            );

            if (shouldExit == true) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                // Send the exit message explicitly when the user confirms
                await _sendExitMessage();

                // Navigate to the dashboard
                Navigator.pop(context); // Close the loading dialog
                navigateToDashboard(context);
              } catch (e) {
                // Close the loading dialog
                Navigator.pop(context);

                // Show an error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to send exit message")),
                );
              }
            }
          },
        ),
        title: Text(
          widget.numePacient,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
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
                      boxShadow: [
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
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Scrie un mesaj...",
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _handleSendMessage,
                  icon: const Icon(Icons.send, color: Color.fromRGBO(14, 190, 127, 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
