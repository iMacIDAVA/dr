import 'dart:io';

import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
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
  String _result = '14:00';

  @override
  void initState() {
    super.initState();

    isVideoEnabled = true;
    isMicEnabled = true;

    _initializeAgora();
    _startTimer();
  }

  Future<void> _initializeAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine?.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {});
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {});
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() {});

          if (mounted) {
            getUserData();
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

    await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine?.enableVideo();
    await _engine?.startPreview();

    await _engine?.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        int remainingSeconds = (15 * 60) - _stopwatch.elapsed.inSeconds;

        if (remainingSeconds > 0) {
          int minutes = remainingSeconds ~/ 60;
          int seconds = remainingSeconds % 60;
          _result = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        } else {
          _result = "00:00";

          _stopTimer();
          getUserData();
        }
      });
    });

    _stopwatch.start();
  }

  void _stopTimer() {
    _timer.cancel();
    _stopwatch.stop();
  }

  @override
  void dispose() {
    _stopTimer();

    if (_engine != null) {
      _engine!.leaveChannel();
      _engine!.release();
    }

    getUserData();
    super.dispose();
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
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                    child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 480),
                Container(
                  width: 130,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        width: 25,
                        height: 17,
                        "./assets/images/cerc_apel_video.png",
                      ),
                      Text(
                        _result,
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(255, 86, 86, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
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
                        getUserData();
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
                      onTap: () {},
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
    if (_engine != null) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: widget.remoteUid),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
