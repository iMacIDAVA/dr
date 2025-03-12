import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class FileViewerScreen extends StatelessWidget {
  final File file;
  final VoidCallback onSend;

  const FileViewerScreen({Key? key, required this.file, required this.onSend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = file.path.endsWith(".jpg") || file.path.endsWith(".jpeg") || file.path.endsWith(".png");
    final isPdf = file.path.endsWith(".pdf");

    return Scaffold(
      appBar: AppBar(
        // title: const Text("Preview"),
        actions: [
          TextButton(
            onPressed: onSend,
            child: const Text("Trimite", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: isImage
              ? Image.file(file)
              : isPdf
                  ? PdfViewer.openFile(file.path)
                  : const Text("Fișier invalid"),
        ),
      ),
    );
  }
}
