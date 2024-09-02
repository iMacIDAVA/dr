import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/chestionar_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class IntrebareScreen extends StatelessWidget {
  const IntrebareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 790,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        centerTitle: false,
        //titleSpacing: 10.0,
        //leadingWidth: 0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 140,
                ),
                SizedBox(
                  height: 56,
                  width: 160,
                  child: Center(
                    child: AutoSizeText.rich(
                      TextSpan(
                        //text:'Vi s-a adresat o întrebare', //old IGV
                        text: l.intrebareViSAAdresatOIntrebare,
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset('./assets/images/chat_icon.png'),
                  ),
                ),
                const SizedBox(height: 165),
                SizedBox(
                  width: 320,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                      side: const BorderSide(width: 1, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      String? userEmail = prefs.getString('userEmail');
                      String? userPassMD5 = prefs.getString('userPassMD5');

                      if (userEmail == null || userPassMD5 == null) {
                        return;
                      }

                      ChestionarClientMobile? resGetUltimulChestionarCompletatByContMedic =
                          await apiCallFunctions.getUltimulChestionarCompletatByContMedic(
                        pUser: userEmail,
                        pParola: userPassMD5,
                        pIdClient: '13',
                      );

                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              //builder: (context) => const ServiceSelectScreen(),
                              builder: (context) =>
                                  ChestionarScreen(chestionar: resGetUltimulChestionarCompletatByContMedic!),
                            ));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          //'Citește chestionarul', //IGV
                          l.intrebareCitesteChestionarul,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const ImageIcon(color: Colors.white, AssetImage('assets/images/chestionar_icon.png')),
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
