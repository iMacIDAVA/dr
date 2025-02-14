import 'dart:convert';
import 'dart:io';

import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_config.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:path/path.dart' as path;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

const appId = "da37c68ec4f64cd1af4093c758f20869";
const appCertificate = '69b34ac5d15044a7906063342cc15471';
const channelName = "TestChannelIGV_1";
const role = RtcRole.publisher;
const expirationInSeconds = 86400;
final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
final expireTimestamp = currentTimestamp + expirationInSeconds;

class ApelVideoMedicScreen extends StatefulWidget {
  final int remoteUid;

  const ApelVideoMedicScreen({Key? key, required this.remoteUid}) : super(key: key);

  @override
  State<ApelVideoMedicScreen> createState() => _ApelVideoMedicScreenState();
}

class _ApelVideoMedicScreenState extends State<ApelVideoMedicScreen> {
  RtcEngine? _engine;

    int remainingTime = 180;
  Timer? countdownTimer;

  ValueNotifier<int> remainingTimeNotifier = ValueNotifier(900);

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTimeNotifier.value > 0) {
        remainingTimeNotifier.value--;
      } else {
        timer.cancel();
            _stopTimer();
                        if (_engine != null) {
                          await _engine!.leaveChannel();
                          await _engine!.release();
                        }
                        // getUserData();
      }
    });
  }


  bool isVideoEnabled = true;
  bool isMicEnabled = true;

  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  String oneSignalId = '';
  TotaluriMedic? totaluriMedic;

  Future<TotaluriMedic?> getTotaluriDashboardMedic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedic(
      pUser: user,
      pParola: userPassMD5,
    );

    return totaluriMedic;
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceToken = prefs.getString('deviceToken') ?? '';

    TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();

    ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
      pUser: user,
      pParola: userPassMD5,
      pDeviceToken: deviceToken,
      pTipDispozitiv: Platform.isAndroid ? '1' : '2',
      pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
      pTokenVoip: '',
    );

    if (resGetCont != null && resGetTotaluriDashboardMedic != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(
            contMedicMobile: resGetCont,
            totaluriMedic: resGetTotaluriDashboardMedic,
          ),
        ),
        (route) => false,
      );
    }
  }

  String token = '';

  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
 

  @override
  void initState() {
    super.initState();

    

    isVideoEnabled = true;
    isMicEnabled = true;

     startTimer();

    _initializeAgora();
    // _startTimer();
  }

  bool _localUserJoined = false;


Future<void> sendDoctorNotification(String message) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  String rawData = prefs.getString(pref_keys.notificationData) ?? '{}';
  Map<String, dynamic> additionalData = _parseAdditionalData(rawData);
  String body = additionalData['body'] ?? '0';
  String tip = additionalData['tip']?.toString() ?? 'unknown';

  String patientId = prefs.getString(pref_keys.userId) ?? '';
  String patientNume = prefs.getString(pref_keys.userNume) ?? '';
  String patientPrenume = prefs.getString(pref_keys.userPrenume) ?? '';

  int pIdPacient = int.tryParse(body.replaceAll('\$', '').trim()) ?? 0;
  String pTip = tip;
  String pObservatii = '$patientId\$#\$$patientPrenume $patientNume';

  String pCheie = keyAppPacienti;

  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  
  await apiCallFunctions.TrimitePushPrinOneSignalCatrePacient(
    pCheie: pCheie,
    pIdPacient: pIdPacient,
    pTip: pTip,
    pMesaj: message,  // ✅ Message to send
    pObservatii: pObservatii,
  );
}

Map<String, dynamic> _parseAdditionalData(String rawData) {
  try {
    return jsonDecode(rawData) as Map<String, dynamic>;
  } catch (e) {
    print("Error parsing notification data: $e");
    return {};
  }
}

 Future<void> _initializeAgora() async {
  await [Permission.microphone, Permission.camera].request();

  _engine = createAgoraRtcEngine();
  if (_engine == null) return;

  await _engine!.initialize(
    const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ),
  );

  await _engine!.enableVideo();
  await _engine!.startPreview();  // ✅ Start preview before joining channel

  await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

  _engine?.registerEventHandler(
    RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("Doctor joined the channel");
      setState(() {
        _localUserJoined = true;  // ✅ Mark local user as joined
      });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        setState(() {});  // ✅ Ensure UI updates when remote user joins
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        setState(() {});
        if (mounted) {
          // getUserData();
        }
      },
    ),
  );

  token = RtcTokenBuilder.build(
    appId: appId,
    channelName: channelName,
    appCertificate: appCertificate,
    uid: '0',
    role: role,
    expireTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 86400,
  );

  await _engine!.joinChannel(
    token: token,
    channelId: channelName,
    uid: 0,
    options: const ChannelMediaOptions(),
  );
}


Future<void> _sendFile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('user') ?? '';
  String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

  List<int> fileBytes = await _selectedImage.readAsBytes();
  String base64File = base64Encode(fileBytes);
  String fileName = path.basename(_selectedImage.path);
  String extension = path.extension(_selectedImage.path);

  try {
 String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
  pCheie: keyAppPacienti, // ✅ Add this
  pUser: user,
  pParolaMD5: userPassMD5,
  IdClient: widget.remoteUid.toString(),  // ✅ Correct key
  pMesaj: "File Attachment: $fileName$extension",
  pDenumireFisier: fileName,
  pExtensie: extension,
  pSirBitiDocument: base64File,
);

print("Sending file message: FileName=$fileName$extension, User=$user, ClientId=${widget.remoteUid}");

    if (fileUrl != null) {

 print("File uploaded successfully. File URL: $fileUrl");
 _selectedImage = File('');
Navigator.pop(context);

 await apiCallFunctions.adaugaMesajDinContMedic(
  pUser: user,
  pParola: userPassMD5,
  pIdClient: widget.remoteUid.toString(),  // ✅ Correct method for doctor
  pMesaj: fileUrl,
);

    }
    else {
       print("Error: File upload failed. No URL returned.");
    }
  } catch (e) {
    print("❌ Error sending file: $e");
  }
}


File _selectedImage = File('');
final ImagePicker _picker = ImagePicker();

Future<void> _chooseFromGallery() async {
  final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
  if (photo != null) {
    setState(() {
      _selectedImage = File(photo.path);
    });
    Navigator.pop(context); // Close the bottom sheet
    _showChatOptionsBottomSheet(); // Reopen bottom sheet with preview
  }
}

Future<void> _takePhoto() async {
  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  if (photo != null) {
    setState(() {
      _selectedImage = File(photo.path);
    });
    Navigator.pop(context); // Close the bottom sheet
    _showChatOptionsBottomSheet(); // Reopen bottom sheet with preview
  }
}





 void _stopTimer() {
  _timer?.cancel(); // Use null-aware operator to prevent crash
  _stopwatch.stop();
}
  @override
  void dispose() {
    _stopTimer();

    if (_engine != null) {
      _engine?.leaveChannel();
      _engine?.release();
      _engine = null; // Prevents potential memory leaks
    }
    
    remainingTimeNotifier.dispose();
    // getUserData();
    super.dispose();
  }


void _showChatOptionsBottomSheet() {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 800,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Trimite o imagine", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, size: 40, color: Colors.blue),
                  onPressed: _chooseFromGallery,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, size: 40, color: Colors.green),
                  onPressed: _takePhoto,
                ),
              ],
            ),
           if (_selectedImage.path.isNotEmpty) ...[
  const SizedBox(height: 10),
  Center(child: Image.file(_selectedImage, width: 100, height: 100)),
  ElevatedButton(
    onPressed: () {
      if (_selectedImage.path.isNotEmpty) {
        _sendFile();
      }
    },
    child: const Text("Trimite"),
  ),
],

          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            //  Center(
            //   child: Text('ss'),
            // ),
     Align(
  alignment: Alignment.topRight,
  child: SizedBox(
    width: 100,
    height: 150,
    child: Center(
      child: (_engine != null && _localUserJoined)
          ? AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine!,
                canvas: const VideoCanvas(uid: 0, sourceType: VideoSourceType.videoSourceCameraPrimary),
              ),
            )
          : const CircularProgressIndicator(),  // ✅ Show preview only after joined
    ),
  ),
),

        Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 480),
                Container(
                  // width: 130,
                  // height: 45,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   color: Colors.white,
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        width: 25,
                        height: 17,
                        "./assets/images/cerc_apel_video.png",
                      ),
                      // Text(
                      //   _result,
                      //   style: GoogleFonts.rubik(
                      //     color: const Color.fromRGBO(255, 86, 86, 1),
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                                Padding(
                padding: const EdgeInsets.only(left: 128.0, right: 128.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ValueListenableBuilder<int>(
                        valueListenable: remainingTimeNotifier,
                        builder: (context, remainingTime, _) {
                          return Text(
                            "${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}", // Format as MM:SS
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.timer,
                        color: Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              
                    ],
                  ),
                ),
                 const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Video On/Off Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isVideoEnabled = !isVideoEnabled;
                          if (_engine != null) {
                            if (isVideoEnabled) {
                              _engine!.enableVideo();
                            } else {
                              _engine!.disableVideo();
                            }
                          }
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: Icon(
                          isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    // Microphone On/Off Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isMicEnabled = !isMicEnabled;
                          if (_engine != null) {
                            if (isMicEnabled) {
                              _engine!.enableLocalAudio(true);
                            } else {
                              _engine!.enableLocalAudio(false);
                            }
                          }
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: Icon(
                          isMicEnabled ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    // End Call Button
                    GestureDetector(
                      onTap: () async {
                        _stopTimer();
                        if (_engine != null) {
                          await _engine!.leaveChannel();
                          await _engine!.release();
                        }
                        // getUserData();
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Image.asset(
                            './assets/images/inchide_apel_icon.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    ),
                    // Switch Camera Button
                    GestureDetector(
                      onTap: () async {
                        await _engine?.switchCamera();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    // Chat Button
                    GestureDetector(
                      onTap: () {
                        _showChatOptionsBottomSheet();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: const Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Glisați în sus pentru a afișa chatul',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _remoteVideo() {
  if (_engine == null) {
    return Container(height: 20 , width: 20,
      child: const Center(child: CircularProgressIndicator()));
  }

  return AgoraVideoView(
    controller: VideoViewController(
      rtcEngine: _engine!,
      canvas: VideoCanvas(uid: widget.remoteUid),
    ),
  );
}



}
