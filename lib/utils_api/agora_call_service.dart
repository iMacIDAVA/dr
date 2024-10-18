import 'dart:async';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:sos_bebe_profil_bebe_doctor/apel_video_medic_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/main.dart';

const appId = "da37c68ec4f64cd1af4093c758f20869";
const appCertificate = '69b34ac5d15044a7906063342cc15471';
const channelName = "TestChannelIGV_1";
const role = RtcRole.publisher;

class CallService {
  Timer? _pollingTimer;
  late RtcEngine _engine;
  int? _remoteUid;

  Future<void> startPolling() async {
    await _initAgora();

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_remoteUid != null) {
        _stopPolling();

        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
            builder: (context) => ApelVideoMedicScreen(
              remoteUid: _remoteUid!,
            ),
          ),
        );
      }
    });
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          _remoteUid = null;
        },
      ),
    );

    String token = RtcTokenBuilder.build(
      appId: appId,
      channelName: channelName,
      appCertificate: appCertificate,
      uid: '0',
      role: role,
      expireTimestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 86400,
    );

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> dispose() async {
    _stopPolling();
    await _engine.leaveChannel();
    await _engine.release();
  }
}
