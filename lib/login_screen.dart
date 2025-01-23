import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
//import 'package:sos_bebe_app/register.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/reset_password_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/register_medic_screen.dart';
//import 'package:sos_bebe_profil_bebe_doctor/profil_medic_screen_old_dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

TotaluriMedic? totaluriMedic;

class LoginMedicScreen extends StatefulWidget {
  const LoginMedicScreen({super.key});

  @override
  State<LoginMedicScreen> createState() => _LoginMedicScreenState();
}

class _LoginMedicScreenState extends State<LoginMedicScreen> {
  final loginKey = GlobalKey<FormState>();
  bool isHidden = true;

  final controllerEmail = TextEditingController();
  final controllerPass = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  void passVisibiltyToggle() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  Future<void> initOneSignal() async {
    await getPlayerId();
  }

  String oneSignal = '';
  void getKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oneSignal = prefs.getString("deviceToken")!;

    setState(() {});
  }

  Future<void> getPlayerId() async {
    final String? id = OneSignal.User.pushSubscription.id;

    if (id != null) {
      oneSignalId = id;
    } else {
      oneSignalId = '';
      await initOneSignal();
    }
    if (id != null) {
      await SharedPreferences.getInstance().then((value) {
        value.setString('oneSignalId', id);
      });
    }
    setState(() {});
  }

  String oneSignalId = '';

  login(BuildContext context) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    String textMesaj = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    String email = controllerEmail.text;
    String pass = controllerPass.text;

    String userPassMD5 = apiCallFunctions.generateMd5(pass);

    ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
      pUser: email,
      pParola: userPassMD5,
      pDeviceToken: oneSignal,
      // pDeviceToken: OneSignal.User.pushSubscription.id ?? "",
      pTipDispozitiv: Platform.isAndroid ? '1' : '2',
      pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
      pTokenVoip: '',
    );
    // print(OneSignal.User.pushSubscription.id);
    // print(prefs.getString("oneSignalId"));

    print('login: resGetCont.id ${resGetCont!.id}');

    if (resGetCont.id != 0) {
      //textMesaj = 'Login realizat cu succes!'; //old IGV
      textMesaj = l.loginLoginCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pref_keys.userId, resGetCont.id.toString());
      prefs.setString(pref_keys.user, resGetCont.email);
      prefs.setString(pref_keys.userEmail, resGetCont.email);
      prefs.setString(pref_keys.userTelefon, resGetCont.telefon);
      prefs.setString(pref_keys.userCNP, resGetCont.cnp);
      prefs.setString(pref_keys.stareCont, resGetCont.stareCont.toString());

      prefs.setString(pref_keys.linkPozaProfil, resGetCont.linkPozaProfil);
      prefs.setString(pref_keys.titulatura, resGetCont.titulatura);
      prefs.setString(pref_keys.locDeMunca, resGetCont.locDeMunca);
      prefs.setString(pref_keys.functia, resGetCont.functia);
      prefs.setString(pref_keys.specializarea, resGetCont.specializarea);
      prefs.setString(pref_keys.adresaLocDeMunca, resGetCont.adresaLocDeMunca);
      prefs.setBool(pref_keys.esteActiv, resGetCont.esteActiv);
      prefs.setBool(pref_keys.primesteIntrebari, resGetCont.primesteIntrebari);
      prefs.setBool(pref_keys.interpreteazaAnalize, resGetCont.interpreteazaAnalize);
      prefs.setBool(pref_keys.permiteConsultVideo, resGetCont.permiteConsultVideo);

      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      prefs.setString(pref_keys.userPassMD5, userPassMD5);
      prefs.setString(pref_keys.userNumeComplet, resGetCont.numeComplet);

      //prefs.setString(pref_keys.userPrenume, resGetCont.prenume);
    } else {
      //textMesaj = 'Eroare! Reintroduceți user-ul și parola!'; //old IGV
      textMesaj = l.loginEroareReintroducetiUserParola;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }
    if (context.mounted) {
      showSnackbar(
        context,
        textMesaj,
        backgroundColor,
        textColor,
      );
    }

    return resGetCont;
  }

  Future<TotaluriMedic?> getTotaluriDashboardMedic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedic(
      pUser: user,
      pParola: userPassMD5,
    );

    return totaluriMedic;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initOneSignal();
    getKey();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        //begin added by George Valentin Iordache
        //end added by George Valentin Iordache
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //added by George Iordache
                      /*Row(
                          children:[
                            IconButton(
                              onPressed: (){
                              Navigator.pop(context);
                              //sau Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                              icon: const Icon(Icons.arrow_back),
                              //replace with our own icon data.
                            ),
                            const Text("Back"),
                          ]
                      ),
                      */
                      // end added by George Valentin Iordache
                      const SizedBox(height: 10),
                      Center(child: Image.asset('./assets/images/Sos_Bebe_logo.png', height: 198, width: 158)),
                      const SizedBox(height: 40),
                      Form(
                        key: loginKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onFieldSubmitted: (String s) {
                                focusNodePassword.requestFocus();
                              },
                              controller: controllerEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(205, 211, 223, 1),
                                    //color: Color.fromARGB(255, 14, 190, 127), old
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Color.fromRGBO(205, 211, 223, 1),
                                    //color: Color.fromARGB(255, 14, 190, 127), old
                                    width: 1.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                //hintText: "Email / Telefon", //old IGV
                                hintText: l.loginEmailTelefonHint,
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(103, 114, 148, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300), //added by George Valentin Iordache
                              ),
                              validator: (value) {
                                //String pattern = r'(^(?:[+0]4)?[0-9]{10,12}$)';
                                String pattern1 = r'(^(?:[+0]4)?[0-9]{10}$)';
                                RegExp regExp1 = RegExp(pattern1);
                                if (value!.isEmpty ||
                                    !(RegExp(r'.+@.+\.+').hasMatch(value) || regExp1.hasMatch(value))) {
                                  //return 'Introduceți un email/numar telefon valid!'; //old IGV
                                  return l.loginIntroducetiUnEmailNumarTelefonValid;
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
                                      icon: isHidden ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
                                  //hintText: "Parola noua", old
                                  //hintText: "Parolă", //old IGV
                                  hintText: l.loginParolaHint,
                                  hintStyle: const TextStyle(
                                      color: Color.fromRGBO(103, 114, 148, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300), //added by George Valentin Iordache

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
                                  //return "Please Enter New Password"; old
                                  //return 'Vă rugăm introduceți o parolă nouă'; //old IGV
                                  return l.loginVaRugamIntroducetiOParolaNoua;
                                } else if (value.length < 6) {
                                  //return "Password must be at least 6 characters long"; old
                                  //return 'Parola trebuie să aibă cel puțin 6 caractere'; //old IGV
                                  return l.loginParolaTrebuieSaAibaCelPutin;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Text(oneSignalId),
                      ElevatedButton(
                        onPressed: () async {
                          final isValidForm = loginKey.currentState!.validate();
                          if (isValidForm) {
                            ContMedicMobile? resGetCont = await login(context);

                            if (resGetCont!.id != 0) {
                              if (context.mounted) {
                                TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();
                                //print("tapped on container medic");

                                if (resGetTotaluriDashboardMedic != null) {
                                  if (context.mounted) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DashboardScreen(
                                            contMedicMobile: resGetCont,
                                            totaluriMedic: resGetTotaluriDashboardMedic,
                                          ),
                                        ));
                                  }
                                }
                                /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilMedicScreen(isDisponibleForNotifications: true,),
                                  )
                                );
                                */
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                            //const Color.fromARGB(255, 14, 190, 127), old
                            minimumSize: const Size.fromHeight(50), // NEW
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: Text(
                            //'CONECTARE', //old IGV
                            l.loginConectare,
                            //style: GoogleFonts.rubik(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20)), old
                            style: GoogleFonts.rubik(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 18)),
                      ),
                      // Text("OR", style: GoogleFonts.rubik(color: Colors.black45, fontWeight: FontWeight.w500)), old
                    ],
                  ),
                  const SizedBox(height: 150),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 380,
                        height: 20,
                        child: Row(
                          children: [
                            Text(
                                //'Ai uitat parola?', //old IGV
                                l.loginAiUitatParola,
                                style: GoogleFonts.rubik(
                                  color: const Color.fromRGBO(103, 114, 148, 1),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                )),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      //builder: (context) => const ServiceSelectScreen(),
                                      builder: (context) => const ResetPasswordScreen(),
                                    ));
                              },
                              child: Text(
                                  //'Click aici', //old IGV
                                  l.loginClickAiciParola,
                                  style: GoogleFonts.rubik(
                                    color: const Color.fromRGBO(14, 190, 127, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 380,
                        height: 20,
                        child: Row(
                          children: [
                            Text(
                                //'Nu ai cont?', //old IGV
                                l.loginNuAiCont,
                                style: GoogleFonts.rubik(
                                  color: const Color.fromRGBO(103, 114, 148, 1),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                )),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      //builder: (context) => const ServiceSelectScreen(),
                                      builder: (context) => const RegisterMedicScreen(),
                                    ));
                              },
                              child: Text(
                                  //'Click aici', //old IGV
                                  l.loginClickAiciCont,
                                  style: GoogleFonts.rubik(
                                    color: const Color.fromRGBO(14, 190, 127, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
