import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
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
                    //'Oops!', //old IGV
                    l.errorOops,
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(242, 63, 87, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                SizedBox(
                  width: 250,
                  child: AutoSizeText.rich(
                    // old value RichText(
                    TextSpan(
                      style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(103, 114, 148, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          //text: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod..'), //old IGV
                          text: 'Ceva nu a funcționat, vă rugăm reîncercați !',
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 250),
                // SizedBox(
                //   width: 160,
                //   height: 44,
                //   child: ElevatedButton(
                //     onPressed: () {
                //
                //       Navigator.of(context).popUntil((route) => route.isFirst);
                //       //Navigator.push(
                //           //context,
                //           //MaterialPageRoute(
                //             //builder: (context) => const ServiceSelectScreen(),
                //             //builder: (context) => const TestimonialScreen(),
                //           //));
                //
                //     },
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                //         minimumSize: const Size.fromHeight(50), // NEW
                //         side: const BorderSide(
                //           width: 1.0,
                //           color: Color.fromRGBO(14, 190, 127, 1),
                //         ),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(5),
                //         )),
                //     child: Text(
                //         //'Go home', //old IGV
                //         l.errorResetareParola,
                //         style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 14, fontWeight: FontWeight.w300)),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
