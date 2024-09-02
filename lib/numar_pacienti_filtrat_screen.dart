import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
import 'package:sos_bebe_profil_bebe_doctor/initializare_numar_pacienti_screen.dart';
//import 'package:sos_bebe_profil_bebe_doctor/range_picker_styled.dart';
//import 'package:sos_bebe_profil_bebe_doctor/data_picker_widgets/event.dart';
import 'package:sos_bebe_profil_bebe_doctor/range_picker_numar_pacienti_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

import 'package:intl/intl.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class NumarPacientiFiltratScreen extends StatefulWidget {
  //final ContMedicMobile contMedicMobile;

  final List<ConsultatiiMobile> listaConsultatiiMobileNumarPacienti;

  const NumarPacientiFiltratScreen({
    super.key,
    required this.listaConsultatiiMobileNumarPacienti,
    //required this.contMedicMobile,
  });

  @override
  State<NumarPacientiFiltratScreen> createState() =>
      _NumarPacientiFiltratScreenState();
}

class _NumarPacientiFiltratScreenState
    extends State<NumarPacientiFiltratScreen> {
  //InitializareNumarPacientiWidget initWidget = InitializareNumarPacientiWidget();

  //List<NumarPacientiItem> listaNumarPacienti = [];

  void callback(bool newIsVisible) {
    setState(() {
      isVisible = newIsVisible;
    });
  }

  @override
  void initState() {
    // Do some other stuff
    super.initState();
    //listaNumarPacienti = InitializareNumarPacientiWidget().initList();
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('./assets/images/inapoi_icon.png'),
        ),
      ),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //const TopIconsTextWidget(topText: 'Selectează Perioada'),
            const SizedBox(height: 25),
            Center(
              //child: Text('Alege perioada', style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 28, fontWeight: FontWeight.w400)), // old IGV
              child: Text(l.numarPacientiFiltratAlegePerioada,
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(14, 190, 127, 1),
                      fontSize: 28,
                      fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 30),
            //const RangePickerPage(),
            SizedBox(
                child: RangePickerNumarPacientiFiltrat(
              listaConsultatiiMobileNumarPacienti:
                  widget.listaConsultatiiMobileNumarPacienti,
            )),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopIconsTextWidget extends StatelessWidget {
  final String topText;

  const TopIconsTextWidget({super.key, required this.topText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {},
              icon: Image.asset('./assets/images/left_top_icon.png'),
            ),
            const SizedBox(width: 160),
            Text(topText,
                style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
            IconButton(
              onPressed: () {},
              icon: Image.asset('./assets/images/right_top_icon.png'),
            ),
          ],
        ),
      ],
    );
  }
}
