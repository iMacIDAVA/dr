import 'package:flutter/material.dart';
import 'dart:async';
//import 'package:agora_uikit/agora_uikit.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_medic_screen.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:sos_bebe_profil_bebe_doctor/apel_video_timp_scurs.dart';

import 'package:agora_token_service/agora_token_service.dart';


import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';


//import 'package:device_info_plus/device_info_plus.dart';


const appId = "da37c68ec4f64cd1af4093c758f20869";
      //appId: 'a6810f83c0c549aab473207134b69489',
const appCertificate = '69b34ac5d15044a7906063342cc15471';
//const channelName =  "TestIGV_1";
const channelName =  "TestChannelIGV_1";

const role = RtcRole.publisher;

//const expirationInSeconds = 1000000;
const expirationInSeconds = 86400;

final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
final expireTimestamp = currentTimestamp + expirationInSeconds;

/*      username: "4",
      uid: 4,
*/
//const username = "medic1";
//const uid = 3;

//const token = '007eJxTYDi2f1+vAhsDV53PrI2FssuXScx8HqkslLBlxeYt5ZYbTmQoMKQkGpsnm1mkJpukmZkkpxgmppkYWBonm5tapBkZWJhZemRZpzYEMjKIpKkzMEIhiM/JEJJaXOLpHhZvyMAAAHnwHpU='; //old IGV


class ApelVideoMedicScreen extends StatefulWidget {
  const ApelVideoMedicScreen({Key? key}) : super(key: key);

  @override
  State<ApelVideoMedicScreen> createState() => _ApelVideoMedicScreenState();
}

class _ApelVideoMedicScreenState extends State<ApelVideoMedicScreen> {


  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  String token = '';

  final Stopwatch _stopwatch = Stopwatch();

  // Timer
  late Timer _timer;

  // The result which will be displayed on the screen
  String _result = '15:00';

  void _start() {
    // Timer.periodic() will call the callback function every 100 milliseconds
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
      // Update the UI
      setState(() {

        int secundeDeScazut = (_stopwatch.elapsed.inSeconds % 60 == 0)? 60 : _stopwatch.elapsed.inSeconds % 60;
        int secunde = 60 - secundeDeScazut;

        //int secunde = _stopwatch.elapsed.inSeconds == 0? 0 : 60 - _stopwatch.elapsed.inSeconds % 60;
        
        int minuteDeScazut = (_stopwatch.elapsed.inSeconds % 60 == 0)? 0 : 1;
        int minute = _stopwatch.elapsed.inSeconds == 0? 15: 15 - _stopwatch.elapsed.inMinutes - minuteDeScazut;

        _result = 
            '${minute.toString().padLeft(2, '0')}:${secunde.toString().padLeft(2, '0')}';
        
        // result in mm:ss format
        //_result =
        //    '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
            //'${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}'; old
      });
    });
    // Start the stopwatch
    _stopwatch.start();
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();
  }

  @override
  void initState() {
    super.initState();


    token = RtcTokenBuilder.build(
            appId: appId,
            channelName: channelName,
            appCertificate: appCertificate,
            uid: '0',
            role: role,
            expireTimestamp: expireTimestamp,

    );

    //print('token: $token');

    initAgora();
    //_start();
  }

  Future<void> initAgora() async {
    // retrieve permissions


    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    

    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    )
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) async {

          token = RtcTokenBuilder.build(
            appId: appId,
            channelName: channelName,
            appCertificate: appCertificate,
            uid: 'doctor1',
            role: role,
            expireTimestamp: expireTimestamp,

          );

          await _engine.renewToken(token);
          /*
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          */
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _stop();
    super.dispose();

    _dispose();

  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {

    /*if (_stopwatch.elapsed.inSeconds >= 15)
    {
       // ignore: avoid_print
      print('time expired: $_result');
      _stop();
      dispose();
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) 
      //  => const RaspundeIntrebareMedicScreen(textNume: '', textIntrebare: '', textRaspuns: '',)));
      return const RaspundeIntrebareMedicScreen(textNume: '', textIntrebare: '', textRaspuns: '',); 
    }
    */
    return Scaffold(
      appBar: AppBar(
        //title: const Text('Agora Video Call'),
      ),
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
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.start,
            children:[
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
                      _stopwatch.elapsed.inSeconds <= 60 ? _result : "14:00",
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ 
                  IconButton(
                    onPressed: () async {
                      dispose();
                      if (mounted){
                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) 
                          => const RaspundeIntrebareMedicScreen(textNume: '', textIntrebare: '', textRaspuns: '',)));
                      }
                    }, 
                    icon: Image.asset(
                      width: 80,
                      height: 80,
                      './assets/images/inchide_apel_icon.png'),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _engine.switchCamera();
                    },
                    icon: Image.asset(
                      width: 50,
                      height: 50,
                      './assets/images/switch_camera_icon.png'
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {

    LocalizationsApp l = LocalizationsApp.of(context)!;

    if (_remoteUid != null) {
      _start();
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return Text(
        //'Vă rugăm așteptați după pacient să intre!', //old IGV
        l.apelVideoMedicVaRugamAsteptati,
        textAlign: TextAlign.center,
      );
    }
  }
}