//import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:pdf_render/pdf_render.dart';
//import 'package:pdfx/pdfx.dart';
//import 'package:image_picker/image_picker.dart';


class VizualizareAnalizeImagineDocumentScreen extends StatelessWidget {

  final String imaginePath;

  const VizualizareAnalizeImagineDocumentScreen({super.key, required this.imaginePath});

  @override
  Widget build(BuildContext context) {
    return Column( 
      children: [
        Container(color: const Color.fromRGBO(30, 214, 158, 1),
        height: 700,
        child: 
          Column(
            children:
            [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Image.asset('./assets/images/inapoi_icon.png'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),  
                ],  
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 600,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(imaginePath),
                  ),
                ),
              ),
            ],  
          ),
        ),
        const SizedBox( width: 330, height: 54,), 
      ],
    );
  }
}
