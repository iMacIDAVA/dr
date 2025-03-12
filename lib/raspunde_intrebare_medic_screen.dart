import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:sos_bebe_profil_bebe_doctor/chat_preview_file_screen.dart';
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
  // final List<File> receivedFiles;

  const RaspundeIntrebareMedicScreen({
    super.key,
    required this.textNume,
    required this.idClient,
    required this.idMedic,
    required this.iconPathPacient,
    required this.numePacient,
    // this.receivedFiles = const []
  });

  @override
  State<RaspundeIntrebareMedicScreen> createState() => _RaspundeIntrebareMedicScreenState();
}

class _RaspundeIntrebareMedicScreenState extends State<RaspundeIntrebareMedicScreen> {
  final List<MesajConversatieMobile> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _messageUpdateTimer;

  bool isTyping = false;

  String medicId = '';

@override
void initState() {  // ✅ Remove 'async' from initState()
    super.initState();

    _initializeData();  // ✅ No 'await' here, let it complete in the background
    _loadMessagesFromList();
    
    _startPeriodicFetching();
    
    // if (widget.receivedFiles.isNotEmpty) {
    //   _uploadReceivedFiles();
    // }

    _messageController.addListener(() {
      setState(() {
        isTyping = _messageController.text.isNotEmpty;
      });
    });

    OneSignal.Notifications.addForegroundWillDisplayListener(_onNotificationDisplayed);
}



Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    medicId = prefs.getString('userId') ?? '';  // ✅ Ensure `medicId` is set before fetching messages
}


  

  //   Future<void> _uploadReceivedFiles() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String user = prefs.getString('user') ?? '';
  //   String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
  //   String pCheie = keyAppPacienti;
  //
  //   for (File file in widget.receivedFiles) {
  //     try {
  //       String fileName = path.basenameWithoutExtension(file.path);
  //       String extension = path.extension(file.path);
  //       List<int> fileBytes = await file.readAsBytes();
  //       String base64File = base64Encode(fileBytes);
  //
  //       String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
  //         pCheie: pCheie,
  //         pUser: user,
  //         pParolaMD5: userPassMD5,
  //         IdClient: widget.idClient.toString(),
  //         pMesaj: "File Attachment: $fileName$extension",
  //         pDenumireFisier: fileName,
  //         pExtensie: extension,
  //         pSirBitiDocument: base64File,
  //       );
  //
  //       if (fileUrl != null) {
  //         await apiCallFunctions.adaugaMesajDinContMedic(
  //           pUser: user,
  //           pParola: userPassMD5,
  //           pIdClient: widget.idClient.toString(),
  //           pMesaj: fileUrl,
  //         );
  //
  //         print("✅ File uploaded: $fileUrl");
  //       } else {
  //         print("❌ Failed to upload file: $file.path");
  //       }
  //     } catch (error) {
  //       print("⚠️ Error sending file: $error");
  //     }
  //   }
  // }

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
    countdownTimer?.cancel(); // Stop the timer
    Navigator.pop(context); // Close dialog
    _disposeAndNavigate(); // Dispose resources and navigate
  }

void _disposeAndNavigate() {
  if (!mounted) return;

  countdownTimer?.cancel();
  _messageUpdateTimer?.cancel();

  if (!_isExiting) {
    _isExiting = true;

    // ✅ Clear and remove TextField controller before disposal
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

  try {
    List<MesajConversatieMobile> listaMesaje = await apiCallFunctions.getListaMesajePeConversatie(
          pUser: user,
          pParola: userPassMD5,
          pIdConversatie: medicId,
        ) ??
        [];

    if (mounted) {
      setState(() {
        _messages.clear();
        _messages.addAll(
          listaMesaje.where((e) => 
            e.comentariu.trim() != "Pacientul a părăsit consultația" &&
            e.comentariu.trim() != "Vă rugăm să așteptați plata pacientului" &&
            e.comentariu.trim() != "medicul a părăsit consultația"
          ).toList()
        );
      });

      if (listaMesaje.isNotEmpty && listaMesaje.last.comentariu.trim() == "Pacientul a părăsit consultația") {
        Future.delayed(Duration(seconds: 1), () {
          navigateToDashboard(context);
        });
      }

      if (listaMesaje.isNotEmpty && listaMesaje.last.comentariu.trim() == "Pacientul a părăsit chatul") {
        navigateToDashboard(context);
      }

      _scrollToBottom();
    }
  } catch (error) {}
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
      final localPath = await _downloadFile(fileUrl);

      OpenFilex.open(localPath);
    } catch (error) {}
  }

  Future<String> _downloadFile(String fileUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(fileUrl);
      final filePath = path.join(directory.path, fileName);

      if (await File(filePath).exists()) {
        return filePath;
      }

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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewFileScreen(
            filePath: filePath,
            onSend: () async {
              Navigator.pop(context);
              File file = File(filePath);

              String fileName = path.basenameWithoutExtension(filePath);
              String extension = path.extension(filePath);
              List<int> fileBytes = await file.readAsBytes();
              String base64File = base64Encode(fileBytes);

              SharedPreferences prefs = await SharedPreferences.getInstance();
              String user = prefs.getString('user') ?? '';
              String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
              String pCheie = keyAppPacienti;

              try {
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
                  await apiCallFunctions.adaugaMesajDinContMedic(
                    pUser: user,
                    pParola: userPassMD5,
                    pIdClient: widget.idClient.toString(),
                    pMesaj: fileUrl,
                  );

                  _loadMessagesFromList();
                } else {}
              } catch (error) {}
            },
          ),
        ),
      );
    } else {}
  }

  Future<void> _captureAndSendPhoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        String filePath = photo.path;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewFileScreen(
              filePath: filePath,
              onSend: () async {
                Navigator.pop(context);
                File file = File(filePath);

                String fileName = path.basenameWithoutExtension(filePath);
                String extension = path.extension(filePath);
                List<int> fileBytes = await file.readAsBytes();
                String base64File = base64Encode(fileBytes);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                String user = prefs.getString('user') ?? '';
                String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
                String pCheie = keyAppPacienti;

                try {
                  String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
                    pCheie: pCheie,
                    pUser: user,
                    pParolaMD5: userPassMD5,
                    IdClient: widget.idClient.toString(),
                    pMesaj: "Photo Attachment: $fileName$extension",
                    pDenumireFisier: fileName,
                    pExtensie: extension,
                    pSirBitiDocument: base64File,
                  );

                  if (fileUrl != null) {
                    await apiCallFunctions.adaugaMesajDinContMedic(
                      pUser: user,
                      pParola: userPassMD5,
                      pIdClient: widget.idClient.toString(),
                      pMesaj: fileUrl,
                    );

                    _loadMessagesFromList();
                  } else {}
                } catch (error) {}
              },
            ),
          ),
        );
      } else {}
    } catch (error) {}
  }



  Widget _buildMessageList() {

   
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {


        final message = _messages[index];
        final isDoctorMessage = message.idExpeditor.toString() == medicId;


        if (message.comentariu.contains("File Attachment") || message.comentariu == "Doctorul a părăsit chatul") {
          return const SizedBox.shrink();
        }

        final String text = message.comentariu.trim();
        final bool isImageUrl =
            text.endsWith('.jpg') || text.endsWith('.png') || text.endsWith('.jpeg') || text.endsWith('.gif');
        final bool isPdf = text.endsWith('.pdf');
        final bool isUrl = text.startsWith('http://') || text.startsWith('https://');

        return Align(
          alignment: isDoctorMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDoctorMessage ? const Color.fromRGBO(14, 190, 127, 1) : const Color.fromRGBO(240, 240, 240, 1),
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
            child: Column(
              crossAxisAlignment: isDoctorMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isUrl)
                  isImageUrl
                      ? GestureDetector(
                          onTap: () {
                            _handleFileOpen(text);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Image.network(
                              text,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text(
                                  "Failed to load image.",
                                  style: TextStyle(color: Colors.red),
                                );
                              },
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => _handleFileOpen(text),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0, bottom: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(14, 190, 127, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _captureAndSendPhoto,
                    iconSize: 32,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(14, 190, 127, 1), borderRadius: BorderRadius.all(Radius.circular(10.0))
                      // Rounded border
                      ),
                  child: IconButton(
                    icon: const Icon(Icons.attach_file_outlined, color: Colors.white),
                    onPressed: _pickAndSendFile,
                    iconSize: 32,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Stack(children: [
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                        hintText: "Scrie un mesaj...",
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none),
                  ),
                  Positioned(
                    right: 10,
                    top: 5,
                    bottom: 5,
                    child: isTyping
                        ? Container(
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(14, 190, 127, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            child: IconButton(
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
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : GestureDetector(
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
                ]),
              ),
              const SizedBox(width: 10),
            ],
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
    } finally {}
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
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          leading: const SizedBox(),
          title: Text(
            widget.numePacient,
            style: GoogleFonts.rubik(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }
}
