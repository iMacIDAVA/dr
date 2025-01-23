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

  const RaspundeIntrebareMedicScreen({
    super.key,
    required this.textNume,
    required this.idClient,
    required this.idMedic,
    required this.iconPathPacient,
    required this.numePacient,
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
      OneSignal.Notifications.preventDefault(event.notification.notificationId);
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
        final isDoctorMessage = message.idExpeditor == widget.idMedic;

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
                            onTap: () {},
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
