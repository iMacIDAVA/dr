import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

class SuccesScreen extends StatefulWidget {
  const SuccesScreen({super.key});

  @override
  State<SuccesScreen> createState() => _SuccesScreenState();
}

class _SuccesScreenState extends State<SuccesScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () async {
      if (mounted) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        prefs.setString(pref_keys.userId, '-1');
        prefs.setString(pref_keys.user, '');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginMedicScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 125),
                Center(
                  child: Text(
                    //'Felicitări!', //old IGV
                    l.succesFelicitari,
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(14, 190, 127, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                SizedBox(
                  width: 250,
                  child: AutoSizeText.rich(
                    TextSpan(
                      style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(103, 114, 148, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: 'Parola a fost schimbată cu succes',
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 250),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
