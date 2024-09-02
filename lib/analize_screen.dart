import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/vizualizare_analize_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';


class AnalizeScreen extends StatelessWidget {

  const AnalizeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( 
        toolbarHeight: MediaQuery.of(context).size.height,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        centerTitle: false,
        //titleSpacing: 10.0,
        //leadingWidth: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[ 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                const SizedBox(
                  height: 140,
                ),
                Center(
                  child:IconButton(
                    onPressed: () {},
                    icon: Image.asset('./assets/images/analize_mare_icon.png'),
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  children: [
                    const SizedBox(
                      width: 85,
                    ),
                    SizedBox(
                      height: 80,
                      width: 200,
                      child: Center(
                        child: AutoSizeText.rich(
                          TextSpan(
                            //text:'Ați primit un set de analize pentru interpretare', //old IGV
                            text: l.analizeAtiPrimitUnSetDeAnalize,
                            style: GoogleFonts.rubik(
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 165),
                SizedBox( 
                  width: 320,
                  height: 55,
                  child: ElevatedButton (
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                      side: const BorderSide(width : 1, color:Colors.white),
                      shape: RoundedRectangleBorder( //to set border radius to button
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => const ServiceSelectScreen(),
                          builder: (context) => const VizualizareAnalizeScreen(),
                        ) 
                      );

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          //'VEZI ANALIZELE', //old IGV
                          l.analizeVeziAnalize,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const ImageIcon(color: Colors.white, AssetImage('assets/images/analize_mic_icon.png')),
                      ],
                    ),
                  ),
                ),  
              ],
            ),
          ],
        ),
      ),
    );
  }
}