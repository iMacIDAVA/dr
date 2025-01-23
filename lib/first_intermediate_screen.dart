import 'dart:async';

import 'package:flutter/material.dart';

class FirstIntermediateScreen extends StatelessWidget {
  final VoidCallback onContinueToSecond;

  const FirstIntermediateScreen({
    Key? key,
    required this.onContinueToSecond,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), onContinueToSecond);

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plată confirmată',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(14, 190, 127, 1),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
