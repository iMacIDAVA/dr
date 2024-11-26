import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
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
          listaMesaje.map((e) {
            bool isDoctorMessage = e.idExpeditor == widget.idMedic;
            return {
              "text": e.comentariu,
              "isDoctorMessage": isDoctorMessage,
              "filePath": null, // Placeholder for files (if any)
            };
          }).toList(),
        );
      });

      _scrollToBottom();
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
      _messages.add({"text": message, "isDoctorMessage": true, "filePath": null});
      _messageController.clear();
    });

    _scrollToBottom();
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name;

      setState(() {
        _messages.add({
          "text": fileName,
          "isDoctorMessage": true,
          "filePath": filePath, // Add file path for later opening
        });
      });

      _scrollToBottom();
    }
  }

  void _handleFileOpen(String filePath) {
    OpenFilex.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                final filePath = message['filePath'];

                return Align(
                  alignment: isDoctorMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: filePath != null ? () => _handleFileOpen(filePath) : null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDoctorMessage
                            ? const Color.fromRGBO(14, 190, 127, 1)
                            : const Color.fromRGBO(240, 240, 240, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['text'] as String,
                        style: TextStyle(
                          color: isDoctorMessage ? Colors.white : Colors.black,
                          fontSize: 20,
                        ),
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
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: _handleFileSelection,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Scrie un mesaj...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
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
