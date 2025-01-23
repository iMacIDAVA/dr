import 'dart:io';
import 'package:flutter/material.dart';

class PreviewFileScreen extends StatelessWidget {
  final String filePath;
  final VoidCallback onSend;

  const PreviewFileScreen({
    super.key,
    required this.filePath,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bool isImage = filePath.endsWith('.jpg') ||
        filePath.endsWith('.jpeg') ||
        filePath.endsWith('.png') ||
        filePath.endsWith('.gif');

    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isImage
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.contain,
                    )
                  : const Icon(
                      Icons.insert_drive_file,
                      size: 100,
                      color: Colors.grey,
                    ),
            ),
          ),
          // Close button
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onSend,
        backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
        child: const Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}
