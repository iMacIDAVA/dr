import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/line_chart_incasari_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class IncasariFiltratScreen extends StatelessWidget {
  final List<TotaluriMedic> listaInitialaTotaluriMedicZi;

  const IncasariFiltratScreen(
      {super.key, required this.listaInitialaTotaluriMedicZi});

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset('./assets/images/sageata_stanga_icon.png'),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color.fromRGBO(30, 214, 158, 1),
                  child: SizedBox(
                    width: 130,
                    child: Text(
                      //'Încasări', //old IGV
                      l.incasariFiltratIncasari,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 28,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  // width: 440,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, -40),
                    child: LineChartLuna(
                      listaInitialaTotaluriMedicZi:
                          listaInitialaTotaluriMedicZi,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*
          const Positioned(
            top: 60.0,
            left: 20.0,
            child: 
              LineChartLuna()
          ),
          */
        ],
      ),
    );
  }
}
