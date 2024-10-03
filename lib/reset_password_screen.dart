import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/verifica_codul_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final resetPasswordKey = GlobalKey<FormState>();
  bool isHidden = true;
  final controllerPhone = TextEditingController();
  //final controllerPass = TextEditingController();
  //final controllerNumeComplet = TextEditingController();

  final FocusNode focusNodePhone = FocusNode();
  //final FocusNode focusNodePassword = FocusNode();
  //final FocusNode focusNodeNumeComplet = FocusNode();

  void passVisibiltyToggle() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  String oneSignal = '';
  void getKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oneSignal = prefs.getString("oneSignalId")!;

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getKey();
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
                    //'Resetează parola', //old IGV
                    l.resetPasswordReseteazaParola,
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(14, 190, 127, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Form(
                  key: resetPasswordKey,
                  child: Column(
                    children: [
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
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    //'Introdu numărul de telefon pentru a-ți schimba parola contului' //old IGV
                                    l.resetPasswordReseteazaParolaTextMijloc,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 35),
                      TextFormField(
                        onFieldSubmitted: (String s) {
                          //focusNodePassword.requestFocus();
                        },
                        controller: controllerPhone,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(103, 114, 148, 1),
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
                          fillColor: Colors.white,
                          //hintText: "Telefon", //old IGV
                          hintText: l.resetPasswordTelefonHint,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w300), //added by George Valentin Iordache
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(0.0),
                            child: ImageIcon(
                              AssetImage('assets/images/icon_telefon_reseteaza_parola.png'),
                            ), // icon is 48px widget.
                          ),
                        ),
                        validator: (value) {
                          //String pattern = r'(^(?:[+0]4)?[0-9]{10,12}$)';
                          String phonePattern = r'(^(?:[+0]4)?[0-9]{10}$)';
                          RegExp phoneRegExp = RegExp(phonePattern);
                          if (value!.isEmpty || (!(value.length != 10) && !(value.length != 12))) {
                            //return 'Introduceti un număr de telefon corect'; //old IGV
                            return l.resetPasswordIntroducetiUnNumarDeTelefonCorect;
                          } else if (!phoneRegExp.hasMatch(value)) {
                            //return 'Introduceți un număr de mobil corect'; //old IGV
                            return l.resetPasswordIntroducetiUnNumarDeMobilCorect;
                          }
                          /*
                          if (value!.isEmpty || ((value.length != 10) && !regExp1.hasMatch(value))) {
                            return '"Introduceti un număr de telefon corect"';
                          }else if (!regExp.hasMatch(value)) {
                            return 'Introduceți un număr de mobil corect';
                          }
                          */
                          return null;
                          /*
                          if (value!.isEmpty || !(value.length != 10)) {
                            return "Introduceti un numar de telefon corect";
                          } else {
                            return null;
                          }*/
                        },
                      ),
                      //const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 175),
                SizedBox(
                  width: 160,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValidForm = resetPasswordKey.currentState!.validate();
                      if (isValidForm) {
                        //Navigator.push(
                        //context,
                        //MaterialPageRoute(
                        //builder: (context) => const ServiceSelectScreen(),
                        //builder: (context) => const TestimonialScreen(),
                        //));

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

                        prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5('123456'));

                        //String? userPassMD5 = prefs.getString(pref_keys.userPassMD5);

                        String? userPassMD5 = apiCallFunctions.generateMd5('123456');

                        ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
                          pUser: controllerPhone.text,
                          pParola: userPassMD5,
                          pDeviceToken: oneSignal,
                          pTipDispozitiv: Platform.isAndroid ? '1' : '2',
                          pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
                          pTokenVoip: '',
                        );

                        //print('reset_password_screen getContMedic id : ${resGetCont!.id} numeComplet : ${resGetCont.numeComplet} email: ${resGetCont.email} telefon: ${resGetCont.telefon}  cnp: ${resGetCont.cnp} stareCont: ${resGetCont.stareCont}');

                        if (resGetCont!.id == 0) {
                          //print('reset_password_screen getContClient id : ${resGetCont!.id} nume : ${resGetCont.nume} prenume : ${resGetCont.prenume} email: ${resGetCont.email} telefon: ${resGetCont.telefon}  user: ${resGetCont.user}');

                          //if (resGetCont.telefon.isEmpty && resGetCont.email.isEmpty)
                          {
                            if (context.mounted) {
                              //showSnackbar(context, "Contul dumneavoastră nu conține informațiile de contact pentru a reseta parola, vă rugăm să contactați un reprezentant SOS Bebe", Colors.red, Colors.black); //old IGV
                              showSnackbar(context, l.resetPasswordContulDumneavoastra, Colors.red, Colors.black);
                            }
                            //return;
                          }
                        } else {
                          http.Response? resTrimitePinMedic;

                          resTrimitePinMedic = await trimitePinPentruResetareParolaMedic();

                          if (context.mounted) {
                            if (int.parse(resTrimitePinMedic!.body) == 200) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerificaCodulScreen(user: controllerPhone.text),
                                  //builder: (context) => const ServiceSelectScreen(),
                                  //builder: (context) => const TestimonialScreen(),
                                ),
                              );
                            }
                          }
                          //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                          //builder: (context) => const ServiceSelectScreen(),
                          //builder: (context) => const TestimonialScreen(),
                          //));
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //builder: (context) => const ServiceSelectScreen(),
                              builder: (context) => const VerificaCodulScreen(),
                            ),
                          );
                          */
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                        minimumSize: const Size.fromHeight(50), // NEW
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    child: Text(
                        //'Send code', //old IGV
                        l.resetPasswordSendCode,
                        style: GoogleFonts.rubik(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300)),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<http.Response?> trimitePinPentruResetareParolaMedic() async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resTrimitePinPentruResetareParolaMedic = await apiCallFunctions.trimitePinPentruResetareParolaMedic(
      pUser: controllerPhone.text,
    );

    if (int.parse(resTrimitePinPentruResetareParolaMedic!.body) == 200) {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Cod trimis cu succes!'; //old IGV
      textMessage = l.resetPasswordCodTrimisCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 400) {
      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.resetPasswordApelInvalid;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Cont inexistent!'; //old IGV

      textMessage = l.resetPasswordContInexistent;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 405) {
      //textMessage = 'Cont existent dar clientul nu are date de contact!'; //old IGV

      textMessage = l.resetPasswordContExistentDarClientulNuAreDateDeContact; //old IGV

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 500) {
      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV

      textMessage = l.resetPasswordAAparutOEroareLaExecutiaMetodei;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resTrimitePinPentruResetareParolaMedic;
    }

    return null;
  }
}
