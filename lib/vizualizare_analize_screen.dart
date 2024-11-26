//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:sos_bebe_profil_bebe_doctor/vizualizare_analize_pdf_document_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/vizualizare_analize_imagine_document_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_medic_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_doar_chat_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';


class VizualizareAnalizeScreen extends StatefulWidget {
  
  const VizualizareAnalizeScreen({Key? key}) : super(key: key);
  
  @override
  State<VizualizareAnalizeScreen> createState() => _VizualizareAnalizeScreen();

}

class _VizualizareAnalizeScreen extends State<VizualizareAnalizeScreen> {
  
  bool isPdf = true;
  static const int initialPage = 1;
  late PdfController pdfController;

  @override
  void initState() {
    super.initState();
    if (isPdf){
      pdfController = PdfController(
        document: PdfDocument.openAsset('assets/pdfs/raport_medical.pdf'),
        initialPage: initialPage,
      );
    }
  }
  
  @override
  void dispose() {
    if (isPdf){
      pdfController.dispose();
    }  
    super.dispose();
  }

  //final picker = ImagePicker();

  //final page = doc.getPage(1);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      isPdf?
      Column( 
        children: [
          const SizedBox(height: 100), 
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  //builder: (context) => const ServiceSelectScreen(),
                  builder: (context) => VizualizareAnalizePdfStatefulWidget(pdfController:pdfController),
                ) 
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: PdfView(
                builders: PdfViewBuilders<DefaultBuilderOptions>(
                  options: const DefaultBuilderOptions(),
                  documentLoaderBuilder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                  pageLoaderBuilder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                ),
                controller: pdfController,
                renderer: (PdfPage page) => page.render(
                  width: page.width,
                  height: page.height,
                  format: PdfPageImageFormat.jpeg,
                  backgroundColor: '#FFFFFF',
                  quality: 100,
                ),
              ),
            ),
          ),  
          const SizedBox(height: 100),
          const ButoaneVizualizareAnalizeScreen(),
        ],
      ) :
        Center( 
          child:
          Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) => const ServiceSelectScreen(),
                    builder: (context) => const VizualizareAnalizeImagineDocumentScreen(imaginePath: 'assets/images/raport_medical.png'),
                  ) 
                );
              },
              child: Image.asset('assets/images/raport_medical.png'),
            ),
            const SizedBox( height: 92),
            const ButoaneVizualizareAnalizeScreen(),
          ],
        ),  
      ),
    );
  }
}

class ButoaneVizualizareAnalizeScreen extends StatelessWidget {

  const ButoaneVizualizareAnalizeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Column( 
      children: [
        SizedBox( width: 330, height: 54, 
          child: 
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //
              //     builder: (context) => RaspundeIntrebareDoarChatScreen(textNume: '', textIntrebare: '', textRaspuns: '', idClient: 13, idMedic: 12, iconPathPacient: '',
              //     numePacient: '', onlineStatus: true,),
              //
              //   )
              // );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                minimumSize: const Size.fromHeight(50), // NEW
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                //Text('OFERĂ RECOMANDARE', //old IGV
                Text(l.vizualizareAnalizeOferaRecomandare,
                  style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),      
        ),  
        const SizedBox( 
          height: 10,
        ),
        SizedBox( 
          width: 330, height: 54,
          child: ElevatedButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (context) => const RaspundeIntrebareMedicScreen(textNume: '', textIntrebare: '', textRaspuns: '',),

                ) 
              );

            },
            style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                  minimumSize: const Size.fromHeight(50), // NEW
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Text('ÎNCARCĂ REȚETA', //old IGV
                Text(l.vizualizareAnalizeIncarcaReteta,
                  style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500)),
                const ImageIcon(AssetImage('assets/images/photo_camera_icon.png'), color: Color.fromRGBO(255, 255, 255, 1)),
              ],
            ),
          ),  
        ),
      ],
    );
  }
}