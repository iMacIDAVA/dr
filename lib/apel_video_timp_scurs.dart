
import 'package:flutter/material.dart';
import 'dart:async';

class TimerController extends ChangeNotifier {
  Timer? _timer;

  late int _initialTimeInSeconds;
  late int currentTimeInSeconds;

  bool get isActive => _timer?.isActive ?? false;

  TimerController({int initialTimeInSeconds = 10}) {
    _initialTimeInSeconds = initialTimeInSeconds;
    currentTimeInSeconds = _initialTimeInSeconds;
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  initTimer() {
    currentTimeInSeconds = _initialTimeInSeconds;
    notifyListeners();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        currentTimeInSeconds = currentTimeInSeconds - 1;
        notifyListeners();
        if (currentTimeInSeconds == 0) {
          _timer?.cancel();
        }
      },
    );
  }
}