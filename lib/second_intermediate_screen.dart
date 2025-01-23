import 'dart:async';
import 'package:flutter/material.dart';

class SecondIntermediateScreen extends StatelessWidget {
  final VoidCallback onContinueToConfirm;
  final String page;

  const SecondIntermediateScreen({
    Key? key,
    required this.onContinueToConfirm,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 4), onContinueToConfirm);

    String displayText = '';
    IconData displayIcon = Icons.article;

    if (page == "întrebare") {
      displayText = "Citește chestionarul";
      displayIcon = Icons.sticky_note_2_outlined;
    } else if (page == "recomandare") {
      displayText = "Vezi analize";
      displayIcon = Icons.analytics_outlined;
    } else if (page == "apel") {
      displayText = "Citește chestionarul";
      displayIcon = Icons.videocam;
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 28),
                  Icon(
                    displayIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
