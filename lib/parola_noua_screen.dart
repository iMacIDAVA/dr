import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/succes_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/error_screen.dart';
//import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
//import 'package:pin_code_fields/pin_code_fields.dart';
//import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
//import 'package:auto_size_text/auto_size_text.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:http/http.dart' as http;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class ParolaNouaScreen extends StatefulWidget {
  final String user;

  const ParolaNouaScreen({super.key, required this.user});

  @override
  State<ParolaNouaScreen> createState() => _ParolaNouaScreenState();
}

class _ParolaNouaScreenState extends State<ParolaNouaScreen> {
  final parolaNouaKey = GlobalKey<FormState>();

  bool isHiddenParolaNoua = true;

  bool isHiddenParolaNouaRepetata = true;

  final controllerParolaNoua = TextEditingController();

  final controllerParolaNouaRepetata = TextEditingController();

  final FocusNode focusNodeParolaNoua = FocusNode();

  final FocusNode focusNodeParolaNouaRepetata = FocusNode();

  bool resetCorect = false;
  bool showSendCodeButton = true;

  void parolaNouaVisibiltyToggle() {
    setState(() {
      isHiddenParolaNoua = !isHiddenParolaNoua;
    });
  }

  void parolaNouaRepetataVisibiltyToggle() {
    setState(() {
      isHiddenParolaNouaRepetata = !isHiddenParolaNouaRepetata;
    });
  }

  Future<http.Response?> reseteazaParolaMedic() async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    //SharedPreferences prefs = await SharedPreferences.getInstance();

    /*
    http.Response? res = await apiCallFunctions.getContClient(
      pUser: controllerEmail.text,
      pParola: controllerPass.text,
    );
    */

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resReseteazaParola =
        await apiCallFunctions.reseteazaParolaMedic(
      pUser: widget.user,
      pNouaParola: controllerParolaNoua.text,
    );

    if (int.parse(resReseteazaParola!.body) == 200) {
      setState(() {
        resetCorect = true;
        showSendCodeButton = false;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      print('Parolă resetată cu succes!');

      //textMessage = 'Parolă resetată cu succes!'; //old IGV
      textMessage = l.parolaNouaParolaResetataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resReseteazaParola.body) == 400) {
      setState(() {
        resetCorect = false;
        showSendCodeButton = true;
      });

      print('Apel invalid');

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.parolaNouaApelInvalid;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resReseteazaParola.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));
      print('Eroare la resetare parolă');

      setState(() {
        resetCorect = false;
        showSendCodeButton = true;
      });

      //textMessage = 'Eroare la resetare parolă!'; //old IGV
      textMessage = l.parolaNouaEroareLaResetareParola;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resReseteazaParola!.body) == 405) {
      setState(() {
        resetCorect = false;
        showSendCodeButton = true;
      });

      print('Informații insuficiente');

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.parolaNouaInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resReseteazaParola!.body) == 500) {
      setState(() {
        resetCorect = false;
        showSendCodeButton = true;
      });

      print('A apărut o eroare la execuția metodei');

      //textMessage = 'A apărut o eroare la execuția metodei!';
      textMessage = l.parolaNouaAAparutOEroareLaExecutiaMetodei;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);
      return resReseteazaParola;
    }

    return null;
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
                    //'Parola nouă', //old IGV
                    l.parolaNouaTitlu,
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(14, 190, 127, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Form(
                  key: parolaNouaKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 290,
                        child: AutoSizeText.rich(
                          // old value RichText(
                          TextSpan(
                            style: GoogleFonts.rubik(
                              color: const Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                //text: 'Introduceți o nouă parolă'), //old IGV
                                text: 'Introdu noua parolă, de minim 6 caractere',
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 35),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          focusNodeParolaNouaRepetata.requestFocus();
                        },
                        focusNode: focusNodeParolaNoua,
                        controller: controllerParolaNoua,
                        obscureText: isHiddenParolaNoua,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                            prefixIcon: const ImageIcon(
                              AssetImage(
                                  'assets/images/parola_noua_prefix.png'),
                            ),
                            suffixIcon: IconButton(
                              onPressed: parolaNouaVisibiltyToggle,
                              icon: isHiddenParolaNoua
                                  ? const ImageIcon(
                                      AssetImage(
                                          'assets/images/password_right_visibility.png'),
                                    )
                                  : const ImageIcon(
                                      AssetImage(
                                          'assets/images/password_right_visibility_off.png'),
                                    ),
                            ),
                            //hintText: "Parola noua", old
                            //hintText: "Parolă", //old IGV
                            hintText: l.parolaNouaParolaHint,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(103, 114, 148, 1),
                                fontSize: 14,
                                fontWeight: FontWeight
                                    .w300), //added by George Valentin Iordache
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 14, 190, 127),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(103, 114, 148, 1),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            //return "Vă rugăm introduceți o parolă nouă"; //old IGV
                            return l.parolaNouaVaRugamIntroducetiOParolaNoua;
                          } else if (value.length < 6) {
                            //return "Parola trebuie să aibă cel puțin 6 caractere"; //old IGV
                            return l.parolaNouaParolaTrebuieSaAibaCelPutin;
                          } else if ((controllerParolaNoua.value.text)
                                  .compareTo(controllerParolaNouaRepetata
                                      .value.text) !=
                              0) {
                            //return "Parola trebuie să fie aceeași în ambele câmpuri"; //old IGV
                            return l.parolaNouaParolaTrebuieSaFieAceeasi;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          focusNodeParolaNoua.requestFocus();
                        },
                        focusNode: focusNodeParolaNouaRepetata,
                        controller: controllerParolaNouaRepetata,
                        obscureText: isHiddenParolaNouaRepetata,
                        obscuringCharacter: '*',
                        decoration: InputDecoration(
                            prefixIcon: const ImageIcon(
                              AssetImage(
                                  'assets/images/parola_noua_prefix.png'),
                            ),
                            suffixIcon: IconButton(
                              onPressed: parolaNouaRepetataVisibiltyToggle,
                              icon: isHiddenParolaNouaRepetata
                                  ? const ImageIcon(
                                      AssetImage(
                                          'assets/images/password_right_visibility.png'),
                                    )
                                  : const ImageIcon(
                                      AssetImage(
                                          'assets/images/password_right_visibility_off.png'),
                                    ),
                            ),
                            //hintText: "Parola noua", old
                            //hintText: 'Repetă noua parolă', //old IGV
                            hintText: l.parolaNouaRepetaNouaParolaHint,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(103, 114, 148, 1),
                                fontSize: 14,
                                fontWeight: FontWeight
                                    .w300), //added by George Valentin Iordache
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 14, 190, 127),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(103, 114, 148,
                                    1), //Color.fromARGB(255, 14, 190, 127),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            //return 'Vă rugăm introduceți o parolă nouă'; //old IGV
                            return l
                                .parolaNouaVaRugamIntroducetiOParolaNouaRepetaParola;
                          } else if (value.length < 6) {
                            //return 'Parola trebuie să aibă cel puțin 6 caractere'; //old IGV
                            return l
                                .parolaNouaParolaTrebuieSaAibaCelPutinRepetaParola;
                          } else if ((controllerParolaNoua.value.text)
                                  .compareTo(controllerParolaNouaRepetata
                                      .value.text) !=
                              0) {
                            //return 'Parola trebuie să fie aceeași în ambele câmpuri';
                            return l
                                .parolaNouaParolaTrebuieSaFieAceeasiRepetaParola;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: 160,
                  height: 44,
                  child: (!showSendCodeButton)
                      ? Text(
                          //'Se încearcă resetarea parolei', //old IGV
                          l.parolaNouaSeIncearcaResetareaParolei,
                          //style: GoogleFonts.rubik(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20)), old
                          style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18))
                      : ElevatedButton(
                          onPressed: () async {
                            final isValidForm =
                                parolaNouaKey.currentState!.validate();
                            if (isValidForm) {
                              setState(() {
                                resetCorect = false;
                                showSendCodeButton = false;
                              });

                              http.Response? resReseteazaParola;

                              resReseteazaParola = await reseteazaParolaMedic();

                              if (context.mounted &&
                                  int.parse(resReseteazaParola!.body) == 200) {
                                if (controllerParolaNoua.value.text.length >=
                                        8 &&
                                    ((controllerParolaNoua.value.text)
                                            .compareTo(
                                                controllerParolaNouaRepetata
                                                    .value.text) ==
                                        0)) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        //builder: (context) => const ServiceSelectScreen(),
                                        builder: (context) =>
                                            const SuccesScreen(),
                                      ));
                                } else if (controllerParolaNoua.value.text ==
                                    controllerParolaNouaRepetata.value.text) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        //builder: (context) => const ServiceSelectScreen(),
                                        builder: (context) =>
                                            const ErrorScreen(),
                                      ));
                                } else if (controllerParolaNoua.value.text ==
                                    controllerParolaNouaRepetata.value.text) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        //builder: (context) => const ServiceSelectScreen(),
                                        builder: (context) =>
                                            const SuccesScreen(),
                                      ));
                                }
                              }

                              setState(() {
                                resetCorect = false;
                                showSendCodeButton = true;
                              });
                            }
                            //Navigator.push(
                            //context,
                            //MaterialPageRoute(
                            //builder: (context) => const ServiceSelectScreen(),
                            //builder: (context) => const TestimonialScreen(),
                            //));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(14, 190, 127, 1),
                              minimumSize: const Size.fromHeight(50), // NEW
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Text(
                              //'Confirmă', //IGV
                              'CONFIRMĂ',
                              style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300)),
                        ),
                ),
                //const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
