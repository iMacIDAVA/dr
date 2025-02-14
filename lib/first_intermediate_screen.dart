import 'dart:async';
import 'package:flutter/material.dart';

class FirstIntermediateScreen extends StatefulWidget {
  final VoidCallback onContinueToSecond;

  const FirstIntermediateScreen({
    Key? key,
    required this.onContinueToSecond,
  }) : super(key: key);

  @override
  _FirstIntermediateScreenState createState() => _FirstIntermediateScreenState();
}

class _FirstIntermediateScreenState extends State<FirstIntermediateScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Start the timer properly in initState
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onContinueToSecond();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
