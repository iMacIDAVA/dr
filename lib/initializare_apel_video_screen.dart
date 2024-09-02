import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

//import 'package:device_info_plus/device_info_plus.dart';


class InitializareApelVideoScreen extends StatefulWidget {
  const InitializareApelVideoScreen({Key? key}) : super(key: key);

  @override
  State<InitializareApelVideoScreen> createState() => _InitializareApelVideoScreenState();
}

class _InitializareApelVideoScreenState extends State<InitializareApelVideoScreen> {

  @override
  void initState() {

    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    LocalizationsApp l = LocalizationsApp.of(context)!;

    return MaterialApp(
      home: Scaffold(
        /*appBar: AppBar(
          title: const Text('Agora VideoUIKit apel video'),
          centerTitle: true,
        ),
        */
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                "./assets/images/imagine_apel_video.png",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              SizedBox.expand(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    // Swiping in up direction.
                    if (details.delta.dy > 0) 
                    {
                      
                      //print('Aici 1: ');
                      
                    }

                    // Swiping in down direction.
                    if (details.delta.dy < 0) 
                    {
                        
                      Navigator.pushReplacement(context, 
                              MaterialPageRoute(builder: (BuildContext context) 
                              => const RaspundeIntrebareScreen(textNume: '', textIntrebare: '', textRaspuns: '',)));
                      /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => const ServiceSelectScreen(),
                          //builder: (context) => VizualizareAnalizePdfStatefulWidget(pdfController:pdfController),
                          builder: (context) => const RaspundeIntrebareScreen(textNume: '', textIntrebare: '', textRaspuns: '',)
                          
                        ) 
                      );
                      */

                    }
                  },
                  child: Image.asset(
                    "./assets/images/imagine_ecran_apel_video.png",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              SizedBox(
                height:100, width: 390,
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 35),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                      [
                        const SizedBox(height: 20),
                        Image.asset(
                        "./assets/images/inapoi_icon.png",
                        ),
                      ],
                    ),  
                    const SizedBox(height:50, width: 230),
                    Image.asset(
                      "./assets/images/apel_video_irina_user_icon.png",
                    ),
                  ],
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const SizedBox(height: 480, width:210),
                  Container(
                    width: 65,
                    height: 24,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "./assets/images/cerc_apel_video.png",
                        ),
                        Text(
                          '14:59',
                          style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 86, 86, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText.rich(// old value RichText(
                        TextSpan(
                          style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          children: <TextSpan>[
                            //TextSpan(text: 'Glisați în sus pentru a afișa chatul'), //old IGV
                            TextSpan(text: l.initializareApelVideoGlisatiInSus),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],  
              ),  
            ],
          ),    
        ),
      ),
    );
  }
}
