import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

class RecomandareScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const RecomandareScreen({Key? key, required this.onContinue}) : super(key: key);

  @override
  State<RecomandareScreen> createState() => _RecomandareScreenState();
}

class _RecomandareScreenState extends State<RecomandareScreen> {
  final List<File> _selectedFiles = [];
  final int _maxFiles = 10;

  final ImagePicker _imagePicker = ImagePicker();

  void _openCamera() async {
    if (_selectedFiles.length >= _maxFiles) return;

    final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _selectedFiles.add(File(photo.path));
      });
    }
  }

  void _chooseFromPhone() async {
    if (_selectedFiles.length >= _maxFiles) return;

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  Future<Uint8List> _generatePdfThumbnail(File file) async {
    final document = await PdfDocument.openFile(file.path);
    final page = await document.getPage(1);
    final pageImage = await page.render(
      width: page.width.toInt(),
      height: page.height.toInt(),
    );
    return Uint8List.fromList(pageImage.pixels);
  }

  void _saveFiles() {}

  void _viewFile(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileViewerScreen(file: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 20.0, top: 100.0),
        child: Column(
          children: [
            if (_selectedFiles.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("Fără date", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ),
              )
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    final isImage =
                        file.path.endsWith(".jpg") || file.path.endsWith(".jpeg") || file.path.endsWith(".png");
                    final isPdf = file.path.endsWith(".pdf");

                    return GestureDetector(
                      onTap: () => _viewFile(file),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Center(
                          child: isImage
                              ? Image.file(file, fit: BoxFit.cover)
                              : isPdf
                                  ? FutureBuilder<Uint8List>(
                                      future: _generatePdfThumbnail(file),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                          return Image.memory(snapshot.data!, fit: BoxFit.cover);
                                        }
                                        return const Icon(Icons.picture_as_pdf, size: 40, color: Colors.red);
                                      },
                                    )
                                  : const Icon(Icons.file_present, size: 40, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _selectedFiles.length >= _maxFiles ? null : _openCamera,
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    label: const Text("Camera", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0EBE7F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _selectedFiles.length >= _maxFiles ? null : _chooseFromPhone,
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text("Fișiere", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0EBE7F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _saveFiles,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(30, 214, 158, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'OFERĂ RECOMANDARE',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileViewerScreen extends StatelessWidget {
  final File file;

  const FileViewerScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isImage = file.path.endsWith(".jpg") || file.path.endsWith(".jpeg") || file.path.endsWith(".png");
    final isPdf = file.path.endsWith(".pdf");

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(38.0),
          child: Center(
            child: isImage
                ? Image.file(file)
                : isPdf
                    ? PdfViewer.openFile(file.path)
                    : const Text(
                        "Eroare",
                        style: TextStyle(fontSize: 16),
                      ),
          ),
        ),
      ),
    );
  }
}
