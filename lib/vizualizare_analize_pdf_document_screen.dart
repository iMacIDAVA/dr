import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:pdf_render/pdf_render.dart';
import 'package:pdfx/pdfx.dart';
//import 'package:image_picker/image_picker.dart';

class VizualizareAnalizePdfStatefulWidget extends StatefulWidget {
  
  final PdfController pdfController;

  const VizualizareAnalizePdfStatefulWidget({Key? key, required this.pdfController}) : super(key: key);

  @override
  State<VizualizareAnalizePdfStatefulWidget> createState() => _VizualizareAnalizePdfStatefulWidgetState();
}

class _VizualizareAnalizePdfStatefulWidgetState extends State<VizualizareAnalizePdfStatefulWidget> {

  static const int _initialPage = 1;

/*
  @override
  void initState() {
    
    super.initState();
    _pdfController = widget.pdfController;

  }
  

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }
*/  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              widget.pdfController.previousPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
          PdfPageNumber(
            controller: widget.pdfController,
            builder: (_, loadingState, page, pagesCount) => Container(
              alignment: Alignment.center,
              child: Text(
                '$page/${pagesCount ?? 0}',
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              widget.pdfController.nextPage(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 100),
              );
            },
          ),
        ],
      ),
      body: PdfView(
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
        ),
        controller: widget.pdfController,
      ),
    );
  }
}

