import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class TestVideoCallScreen extends StatefulWidget {
  final bool isDoctor;

  const TestVideoCallScreen({Key? key, required this.isDoctor}) : super(key: key);

  @override
  State<TestVideoCallScreen> createState() => _TestVideoCallScreenState();
}

class _TestVideoCallScreenState extends State<TestVideoCallScreen> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _localUserJoined = false;

  // Static values for testing
  static const appId = "da37c68ec4f64cd1af4093c758f20869";
  static const channelName = "test_room_123";
  static const appCertificate = '69b34ac5d15044a7906063342cc15471';

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine?.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("Local user joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("Remote user joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print("Remote user left");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine?.enableVideo();
    await _engine?.startPreview();
    await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    String token = RtcTokenBuilder.build(
      appId: appId,
      channelName: channelName,
      appCertificate: appCertificate,
      uid: widget.isDoctor ? '2' : '1',
      role: RtcRole.subscriber,
      expireTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
    );

    await _engine?.joinChannel(
      token: token,
      channelId: channelName,
      uid: widget.isDoctor ? 2 : 1,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDoctor ? 'Doctor View' : 'Patient View'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 100,
              height: 150,
              margin: const EdgeInsets.all(10),
              child: _localUserJoined
                  ? AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              )
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine!,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }
}