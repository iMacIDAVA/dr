import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_config.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class RaspundeIntrebareMedicScreen extends StatefulWidget {
  final String textNume;
  final int idClient;
  final int idMedic;
  final String iconPathPacient;
  final String numePacient;

  const RaspundeIntrebareMedicScreen({
    super.key,
    required this.textNume,
    required this.idClient,
    required this.idMedic,
    required this.iconPathPacient,
    required this.numePacient,
  });

  @override
  State<RaspundeIntrebareMedicScreen> createState() =>
      _RaspundeIntrebareMedicScreenState();
}

class _RaspundeIntrebareMedicScreenState extends State<RaspundeIntrebareMedicScreen> {
  final List<MesajConversatieMobile> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _messageUpdateTimer;



  @override
  void initState() {
    super.initState();
    _loadMessagesFromList();
    _startPeriodicFetching();

    OneSignal.Notifications.addForegroundWillDisplayListener(_onNotificationDisplayed);
  }

  @override
  void dispose() {
    _messageUpdateTimer?.cancel();
    _scrollController.dispose();
    _messageController.dispose();

    OneSignal.Notifications.removeForegroundWillDisplayListener(_onNotificationDisplayed);
    super.dispose();
  }

  void _onNotificationDisplayed(OSNotificationWillDisplayEvent event) {
    if (event.notification.body?.contains('Aveți un mesaj') ?? false) {
      OneSignal.Notifications.preventDefault(event.notification.notificationId!);
    }
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

    try {
      List<MesajConversatieMobile> listaMesaje = await apiCallFunctions.getListaMesajePeConversatie(
        pUser: user,
        pParola: userPassMD5,
        pIdConversatie: widget.idMedic.toString(),
      ) ??
          [];

      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(listaMesaje);
        });


        if (listaMesaje.isNotEmpty &&
            listaMesaje.last.comentariu.trim() == "Pacientul a părăsit chatul") {
          navigateToDashboard(context);
        }

        _scrollToBottom();
      }
    } catch (error) {
      print("Error fetching messages: $error");
    }
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _handleFileOpen(String fileUrl) async {
    try {
      // Download the file to a local path
      final localPath = await _downloadFile(fileUrl);

      // Open the file using OpenFilex
      OpenFilex.open(localPath);
    } catch (error) {
      print("Error opening file: $error");
    }
  }

  Future<String> _downloadFile(String fileUrl) async {
    try {
      // Get the directory for saving files
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(fileUrl);
      final filePath = path.join(directory.path, fileName);

      // Check if the file already exists locally
      if (await File(filePath).exists()) {
        return filePath;
      }

      // Download the file
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception("Error downloading file: $error");
    }
  }


  Future<void> _pickAndSendFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      File file = File(filePath);

      String fileName = path.basenameWithoutExtension(filePath);
      String extension = path.extension(filePath);
      List<int> fileBytes = await file.readAsBytes();
      String base64File = base64Encode(fileBytes);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
      String pCheie = keyAppPacienti; // Ensure `keyAppPacienti` is defined in your `api_config`.

      try {
        // Send the file using the provided method
        String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
          pCheie: pCheie,
          pUser: user,
          pParolaMD5: userPassMD5,
          IdClient: widget.idClient.toString(),
          pMesaj: "File Attachment: $fileName$extension",
          pDenumireFisier: fileName,
          pExtensie: extension,
          pSirBitiDocument: base64File,
        );

        if (fileUrl != null) {
          print("File uploaded successfully. Sending URL as a message: $fileUrl");

          // Send the file URL as a message
          await apiCallFunctions.adaugaMesajDinContMedic(
            pUser: user,
            pParola: userPassMD5,
            pIdClient: widget.idClient.toString(),
            pMesaj: fileUrl,
          );

          print("URL sent successfully as a message.");
          _loadMessagesFromList(); // Refresh the chat
        } else {
          print("Failed to upload file. URL is null.");
        }
      } catch (error) {
        print("Error sending file: $error");
      }
    } else {
      print("No file selected.");
    }
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isDoctorMessage = message.idExpeditor == widget.idMedic;

        // Filter out messages containing "File Attachment"
        if (message.comentariu.contains("File Attachment") || message.comentariu == "Doctorul a părăsit chatul") {
          return const SizedBox.shrink(); // Return an empty widget for such messages
        }

        // Extract the text or URL from the message
        final String text = message.comentariu.trim();
        final bool isImageUrl = text.endsWith('.jpg') ||
            text.endsWith('.png') ||
            text.endsWith('.jpeg') ||
            text.endsWith('.gif');
        final bool isPdf = text.endsWith('.pdf');
        final bool isUrl = text.startsWith('http://') || text.startsWith('https://');

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
            child: Column(
              crossAxisAlignment: isDoctorMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isUrl)
                  isImageUrl
                      ? GestureDetector(
                    onTap: () {
                      print('sss :$text');
                      _handleFileOpen(text);
                      }, // Open the image
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image.network(
                        text,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            "Failed to load image.",
                            style: TextStyle(color: Colors.red),
                          );
                        },
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () => _handleFileOpen(text), // Open the file
                    child: Row(
                      children: [
                        Icon(
                          isPdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
                          color: isPdf ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            path.basename(text),
                            style: TextStyle(
                              color: isDoctorMessage ? Colors.white : Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isUrl)
                  Text(
                    text,
                    style: TextStyle(
                      color: isDoctorMessage ? Colors.white : Colors.black,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: _pickAndSendFile, // Call the updated function
          ),
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
            icon: const Icon(Icons.send, color: Color.fromRGBO(14, 190, 127, 1)),
            onPressed: () async {
              if (_messageController.text.isNotEmpty) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String user = prefs.getString('user') ?? '';
                String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

                await apiCallFunctions.adaugaMesajDinContMedic(
                  pUser: user,
                  pParola: userPassMD5,
                  pIdClient: widget.idClient.toString(),
                  pMesaj: _messageController.text,
                );
                _messageController.clear();
                _loadMessagesFromList();
              }
            },
          ),
        ],
      ),
    );
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
        title: Text(
          widget.numePacient,
          style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w500),
        ),
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

      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }
}
