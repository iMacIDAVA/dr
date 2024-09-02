import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/multumim_inregistrare_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

//import 'package:sos_bebe_app/testimonial_screen.dart';

class RegisterMedicScreen extends StatefulWidget {
  const RegisterMedicScreen({super.key});

  @override
  State<RegisterMedicScreen> createState() => _RegisterMedicScreenState();
}

class _RegisterMedicScreenState extends State<RegisterMedicScreen> {
  final registerKey = GlobalKey<FormState>();

  bool isHidden = true;

  final controllerNumeComplet = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerTelefon = TextEditingController();
  final controllerCNP = TextEditingController();
  final controllerPass = TextEditingController();

  final FocusNode focusNodeNumeComplet = FocusNode();
  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodeTelefon = FocusNode();
  final FocusNode focusNodeCNP = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool registerCorect = false;
  bool showTrimiteDateleButton = true;

  void passVisibiltyToggle() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  Future<http.Response?> adaugaContMedic() async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    /*
    http.Response? res = await apiCallFunctions.getContClient(
      pUser: controllerEmail.text,
      pParola: controllerPass.text,
    );
    */

    http.Response? resAdaugaContMedic = await apiCallFunctions.adaugaContMedic(
      pNumeComplet: controllerNumeComplet.text,
      pEmail: controllerEmail.text,
      pTelefon: controllerTelefon.text,
      pCNP: controllerCNP.text,
      pParola: controllerPass.text,
      pDeviceToken: '',
      pTipDispozitiv: Platform.isAndroid ? '1' : '2',
    );

    print(
        'adaugaContMedic resAdaugaContMedic.body ${resAdaugaContMedic!.body}');

    if (int.parse(resAdaugaContMedic!.body) == 200) {
      setState(() {
        registerCorect = true;
        showTrimiteDateleButton = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      prefs.setString(pref_keys.userPassMD5,
          apiCallFunctions.generateMd5(controllerPass.text));

      print('Înregistrare finalizată cu succes!');

      //textMessage = 'Înregistrare finalizată cu succes!'; //old IGV
      textMessage = l.registerInregistrareCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resAdaugaContMedic.body) == 400) {
      setState(() {
        registerCorect = false;
        showTrimiteDateleButton = true;
      });

      print('Apel invalid');

      /*
      if (context.mounted)
      {

        showSnackbar(context, "Apel invalid!", Colors.red, Colors.black);

      }

      return resAdaugaCont;
      */

      //textMessage = 'Apel invalid!'; //old IGV

      textMessage = l.registerApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaContMedic!.body) == 401) {
      prefs.setString(pref_keys.userEmail, controllerEmail.text);
      prefs.setString(pref_keys.userPassMD5,
          apiCallFunctions.generateMd5(controllerPass.text));
      print('Cont deja existent');

      setState(() {
        registerCorect = false;
        showTrimiteDateleButton = true;
      });

      /*
      if (context.mounted)
      {

        showSnackbar(context, "Cont deja existent!", Colors.red, Colors.black);

      }

      return resAdaugaCont;
      */

      //textMessage = 'Cont deja existent!'; //old IGV

      textMessage = l.registerContDejaExistent;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaContMedic!.body) == 405) {
      setState(() {
        registerCorect = false;
        showTrimiteDateleButton = true;
      });

      print('Informații insuficiente');

      /*
      if (context.mounted)
      {

        showSnackbar(context, "Informații insuficiente!", Colors.red, Colors.black);

      }
      
      return resAdaugaCont;
      */

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.registerInformatiiInsuficiente;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaContMedic!.body) == 500) {
      setState(() {
        registerCorect = false;
        showTrimiteDateleButton = true;
      });

      print('A apărut o eroare la execuția metodei');

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV

      textMessage = l.registerAAparutEroare; //old IGV

      backgroundColor = Colors.red;
      textColor = Colors.black;
      /*
      if (context.mounted)
      {

        showSnackbar(context, "A apărut o eroare la execuția metodei!", Colors.red, Colors.black);

      }

      return resAdaugaCont;
      */
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resAdaugaContMedic;
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
                const SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    './assets/images/SOS_bebe_register_icon.png',
                    height: 198,
                    width: 156,
                  ),
                ),
                const SizedBox(height: 70),
                Form(
                  key: registerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //"Înregistrare", //old IGV
                        l.registerInregistrare,
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(103, 114, 148, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          focusNodeTelefon.requestFocus();
                        },
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: focusNodeNumeComplet,
                        controller: controllerNumeComplet,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //hintText: "Nume complet", //old IGV
                          hintText: l.registerNumeCompletHint,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 14,
                              fontWeight: FontWeight
                                  .w300), //added by George Valentin Iordache
                        ),
                        validator: (value) {
                          String namePattern =
                              r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                          RegExp nameRegExp = RegExp(namePattern);
                          if (value!.isEmpty || !nameRegExp.hasMatch(value)) {
                            //return "Introduceți numele complet"; //old IGV
                            return l.registerIntroducetiNumeleComplet;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          focusNodeTelefon.requestFocus();
                        },
                        focusNode: focusNodeEmail,
                        controller: controllerEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //hintText: "Email", //old IGV
                          hintText: l.registerEmailHint,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 14,
                              fontWeight: FontWeight
                                  .w300), //added by George Valentin Iordache
                        ),
                        validator: (value) {
                          String emailPattern = r'.+@.+\.+';
                          RegExp emailRegExp = RegExp(emailPattern);
                          if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
                            //return "Introduceți o adresă de Email corectă"; //old IGV
                            return l.registerIntroducetiOAdresaDeEmailCorecta;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          focusNodeCNP.requestFocus();
                        },
                        focusNode: focusNodeTelefon,
                        controller: controllerTelefon,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //hintText: "Telefon", //old IGV
                          hintText: l.registerTelefonHint,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 14,
                              fontWeight: FontWeight
                                  .w300), //added by George Valentin Iordache
                        ),
                        validator: (value) {
                          String phonePattern = r'(^(?:[+0]4)?[0-9]{10}$)';
                          RegExp phoneRegExp = RegExp(phonePattern);
                          if (value!.isEmpty ||
                              (!(value.length != 10) &&
                                  !(value.length != 12))) {
                            //return 'Introduceti un număr de telefon corect'; //old IGV
                            return l.registerIntroducetiUnNumarDeTelefonCorect;
                          } else if (!phoneRegExp.hasMatch(value)) {
                            //return 'Introduceți un număr de mobil corect'; //old IGV
                            return l.registerIntroducetiUnNumarDeMobilCorect;
                          }
                          return null;
                          /*
                          if (value!.isEmpty || !(value.length != 10)) {
                            return "Introduceti un numar de telefon corect";
                          } else {
                            return null;
                          }*/
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          focusNodePassword.requestFocus();
                        },
                        focusNode: focusNodeCNP,
                        controller: controllerCNP,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(205, 211, 223, 1),
                              width: 1.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //hintText: "CNP", //old IGV
                          hintText: l.registerCNPHint,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 14,
                              fontWeight: FontWeight
                                  .w300), //added by George Valentin Iordache
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length != 13) {
                            //return "Introduceți un CNP valid"; //old IGV
                            return l.registerIntroducetiUnCNPValid;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        focusNode: focusNodePassword,
                        controller: controllerPass,
                        obscureText: isHidden,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: passVisibiltyToggle,
                                icon: isHidden
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                            //hintText: "Parolă", //old IGV
                            hintText: l.registerParolaHint,
                            //hintText: l.loginParola,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(103, 114, 148, 1),
                                fontSize: 14,
                                fontWeight: FontWeight
                                    .w300), //added by George Valentin Iordache

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                //color: Color.fromARGB(255, 14, 190, 127), old
                                color: Color.fromRGBO(205, 211, 223, 1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                //color: Color.fromARGB(255, 14, 190, 127), old
                                color: Color.fromRGBO(205, 211, 223, 1),
                                width: 1.0,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return l
                                .registerVaRugamIntroducetiOParolaNoua; //old IGV
                            //return l.loginMesajIntroducetiParolaNoua;
                          } else if (value.length < 6) {
                            //return "Password must be at least 6 characters long"; old

                            //return "Parola trebuie să aibă cel puțin 6 caractere"; //old IGV
                            return l.registerParolaTrebuieSaAibaCelPutin;

                            //return l.loginMesajParolaCelPutin;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                (!showTrimiteDateleButton)
                    ? Text(
                        //'Se încearcă înregistrarea',//old IGV
                        l.registerSeIncearcaInregistrarea,
                        //style: GoogleFonts.rubik(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20)), old
                        style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18))
                    : ElevatedButton(
                        onPressed: () async {
                          final isValidForm =
                              registerKey.currentState!.validate();
                          if (isValidForm) {
                            print(
                                'register_screen showTrimiteDateleButton = $showTrimiteDateleButton registerCorect = $registerCorect');

                            setState(() {
                              registerCorect = false;
                              showTrimiteDateleButton = false;
                            });

                            http.Response? resAdaugaContMedic;

                            resAdaugaContMedic = await adaugaContMedic();

                            if (context.mounted) {
                              if (int.parse(resAdaugaContMedic!.body) == 200) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MultumimInregistrareScreen(),
                                    //builder: (context) => const TestimonialScreen(),
                                  ),
                                );
                                /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                              //builder: (context) => const ServiceSelectScreen(),
                              //builder: (context) => const TestimonialScreen(),
                            ),
                          );
                          */
                              } else {
                                setState(() {
                                  registerCorect = false;
                                  showTrimiteDateleButton = true;
                                });
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(14, 190, 127, 1),
                            minimumSize: const Size.fromHeight(50), // NEW
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        child: Text(
                            //'TRIMITE DATELE', //old IGV
                            l.registerTrimiteDatele,
                            //style: GoogleFonts.rubik(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20)), old
                            style: GoogleFonts.rubik(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 18)),
                      ),
                const SizedBox(height: 60), //old IGV
              ],
            ),
          ),
        ),
      ),
    );
  }
}
