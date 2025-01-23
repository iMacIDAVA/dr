import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class MultumimInregistrareScreen extends StatelessWidget {
  const MultumimInregistrareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset(height: 640, width: 440, './assets/images/multumim_background.png'),
              Column(
                children: [
                  const SizedBox(height: 480),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(width: 67, height: 65, './assets/images/ok_multumim_icon.png'),
                        const SizedBox(height: 15),
                        Text(
                          //'Vă mulțumim!', //old IGV
                          l.multumimInregistrareVaMultumim,
                          style: GoogleFonts.rubik(
                              color: const Color.fromRGBO(103, 114, 148, 1), fontWeight: FontWeight.w400, fontSize: 18),
                          //color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24), old cu mesajul RIGHT OVERFLOW BY 3 PIXELS
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 53,
                              child: Center(
                                child: Text(
                                  //'Solicitarea dumneavoastră a fost înregistrată.',
                                  l.multumimInregistrareSolicitareaDumneavoastraAFostInregistrata,
                                  style: GoogleFonts.rubik(
                                      color: const Color.fromRGBO(103, 114, 148, 1),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
                                  //color: Colors.white, fontWeight: FontWeight.w500, fontSize: 24), old cu mesajul RIGHT OVERFLOW BY 3 PIXELS
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 53,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                            child: Center(
                              child: AutoSizeText.rich(
                                // old value RichText(
                                TextSpan(
                                  style: GoogleFonts.rubik(
                                    color: const Color.fromRGBO(103, 114, 148, 1),
                                    fontSize: 13,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        //text: 'Urmează sa fiți contactat de '), //old IGV
                                        text: l.multumimInregistrareUrmeazaSaFitiContactatDe),
                                    TextSpan(
                                      //text: 'către un reprezentant',), //old IGV
                                      text: l.multumimInregistrareCatreUnReprezentant,
                                    ),
                                    TextSpan(
                                      //text: ' SOS Bebe ',
                                      text: l.multumimInregistrareSosBebe,
                                      style: GoogleFonts.rubik(
                                        color: const Color.fromRGBO(14, 190, 127, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    TextSpan(
                                        //text: 'în cel mai scurt timp!'),
                                        text: l.multumimInregistrareInCelMaiScurtTimp),
                                  ],
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
