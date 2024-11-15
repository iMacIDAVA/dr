import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/termeni_si_conditii_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:sos_bebe_profil_bebe_doctor/setari_profil_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class EditareProfilScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;

  const EditareProfilScreen({super.key, required this.contMedicMobile});

  @override
  State<EditareProfilScreen> createState() => _EditareProfilScreenState();
}

class _EditareProfilScreenState extends State<EditareProfilScreen> {
  bool isVisible = false;

  bool deconectareActivat = false;
  bool notificariActivat = false;

  void callbackDeconectare(bool newDeconectareActivat) {
    setState(() {
      deconectareActivat = newDeconectareActivat;
    });
  }

  void callbackNotificari(bool newNotificariActivat) {
    setState(() {
      notificariActivat = newNotificariActivat;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: Text(
          //'Profilul meu', //old IGV
          l.editareProfilulMeuTitlu,
          style: GoogleFonts.rubik(
              color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Center(
                child: IconButton(
                  onPressed: () {},
                  //icon: Image.asset('./assets/images/daniela_preoteasa_meniu_profil.png'), //old IGV
                  icon: widget.contMedicMobile.linkPozaProfil.isEmpty
                      ? Image.asset(
                          './assets/images/user_fara_poza.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.contMedicMobile.linkPozaProfil,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Center(
                child: Text(
                  //'Dr. Daniela Preoteasa', old IGV
                  '${widget.contMedicMobile.titulatura}. ${widget.contMedicMobile.numeComplet}',
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 21, fontWeight: FontWeight.w500),
                ),
              ),
              Center(
                child: Text(
                  //'AIS Clinics & Hospital București',//old IGV
                  '${widget.contMedicMobile.locDeMunca} ${widget.contMedicMobile.adresaLocDeMunca}',
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ),
              Center(
                child: Text(
                  //'Pediatrie, Medic Primar', //old IGV
                  '${widget.contMedicMobile.specializarea}, ${widget.contMedicMobile.functia}',
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 9, fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              customPaddingProfilulMeu(),
              //const TexteLinie(textStanga:'User',textDreapta:'@Dr Daniela Preoteasa'), //old IGV
              TexteLinie(
                  //textStanga:'User', //old IGV
                  textStanga: l.editareProfilUser,
                  textDreapta: widget.contMedicMobile.numeComplet),
              customPaddingProfilulMeu(),

              TexteLinie(
                  //textStanga:'Email', //old IGV
                  textStanga: l.editareProfilEmail,
                  textDreapta: widget.contMedicMobile.email),
              customPaddingProfilulMeu(),
              IconTextEditareProfil(
                //textLinie:'Editare Profil', //old IGV
                textLinie: l.editareProfilNavigareEditareProfil,
                iconCV: './assets/images/profil_navigare_icon.png',
                contMedicMobile: widget.contMedicMobile,
              ),
              customPaddingProfilulMeu(),
              //TextAndSwitchWidget(isToggled: deconectareActivat, text: "Deconectare", callback: callbackDeconectare), //old IGV
              //const IconTextLogOut(text:'Deconectare'), //old IGV
              IconTextLogOut(text: l.editareProfilDeconectare),
              customPaddingProfilulMeu(),
              IconTextAndSwitchWidget(
                  isToggled: notificariActivat,
                  //text: "Notificări", //old IGV
                  text: l.editareProfilNotificari,
                  callback: callbackNotificari,
                  icon: './assets/images/notificare_icon.png'),
              IconTextTermeniConditii(
                icon: './assets/images/termeniconditii_icon.png',
                //text:'Termeni și Condiții'), //old IGV
                text: l.editareProfilTermeniSiConditii,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}

class TexteLinie extends StatelessWidget {
  final String textStanga;
  final String textDreapta;

  const TexteLinie({super.key, required this.textStanga, required this.textDreapta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.012,
          ),
          child: Container(
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.035,
                right: MediaQuery.of(context).size.height * 0.035,
                top: MediaQuery.of(context).size.height * 0.004),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.14,
                  child: Text(
                    textStanga,
                    style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(112, 112, 112, 1), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                Text(
                  textDreapta,
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}

class IconTextEditareProfil extends StatefulWidget {
  final String textLinie;
  final String iconCV;

  final ContMedicMobile contMedicMobile;

  const IconTextEditareProfil(
      {super.key, required this.textLinie, required this.iconCV, required this.contMedicMobile});

  @override
  State<IconTextEditareProfil> createState() => _IconTextEditareProfilState();
}

class _IconTextEditareProfilState extends State<IconTextEditareProfil> {
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
    return Column(
      children: [
        Container(
          //const SizedBox(width:15)
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.035,
              right: MediaQuery.of(context).size.height * 0.035,
              top: MediaQuery.of(context).size.height * 0.004),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  String user = prefs.getString('user') ?? '';
                  String deviceToken = prefs.getString('deviceToken') ?? '';
                  String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
                  ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
                    pUser: user,
                    pParola: userPassMD5,
                    pDeviceToken: deviceToken,
                    pTipDispozitiv: Platform.isAndroid ? '1' : '2',
                    pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
                    pTokenVoip: '',
                  );

                  if (resGetCont!.id != 0) {
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            //builder: (context) => const ServiceSelectScreen(),
                            //builder: (context) => const EditareProfilScreen(),
                            builder: (context) => SetariProfilScreen(
                              contMedicMobile: resGetCont,
                            ),
                          ));
                    }
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.height * 0.15,
                  child: Text(
                    widget.textLinie,
                    style: const TextStyle(
                        color: Color.fromRGBO(112, 112, 112, 1), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        //builder: (context) => const ServiceSelectScreen(),
                        //builder: (context) => const EditareProfilScreen(),
                        builder: (context) => SetariProfilScreen(
                          contMedicMobile: widget.contMedicMobile,
                        ),
                      ));
                },
                icon: Image.asset(widget.iconCV),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class IconTextLogOut extends StatelessWidget {
  final String text;

  const IconTextLogOut({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //const SizedBox(width:15)
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.015,
              right: MediaQuery.of(context).size.height * 0.035,
              top: MediaQuery.of(context).size.height * 0.004,
              bottom: MediaQuery.of(context).size.height * 0.012),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const LoginMedicScreen();
                            }),
                          );
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Color.fromRGBO(30, 214, 158, 1),
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString(pref_keys.userId, '-1');
                            prefs.setString(pref_keys.user, '');

                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return const LoginMedicScreen();
                                }),
                              );
                            }
                          },
                          child: Text(text,
                              style: GoogleFonts.rubik(
                                  color: const Color.fromRGBO(112, 112, 112, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//old IGV
// ignore: must_be_immutable
/*
class TextAndSwitchWidget extends StatefulWidget {
  bool isToggled;
  final Function(bool)? callback;
  final String text;
  TextAndSwitchWidget({super.key, required this.isToggled, required this.text, this.callback});

  @override
  State<TextAndSwitchWidget> createState() => _TextAndSwitchWidgetState();
}

class _TextAndSwitchWidgetState extends State<TextAndSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: [
        Container(
          //const SizedBox(width:15)
          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height * 0.035,
            MediaQuery.of(context).size.height * 0.02, MediaQuery.of(context).size.height * 0.035, MediaQuery.of(context).size.height * 0.02),
          child:
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            //Text(widget.disease, style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w400)), old

            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.logout, color:Color.fromRGBO(14, 190, 127, 1),),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.15,
                child:
                  Text(widget.text, style: GoogleFonts.rubik(color: const Color.fromRGBO(112, 112, 112, 1), fontSize: 14, fontWeight: FontWeight.w400)),
              ),


              FlutterSwitch(
                value: widget.isToggled,
                height: 20,
                width: 40,

                //activeColor: const Color.fromARGB(255, 103, 197, 108),

                //added by George Valentin Iordache
                activeColor: const Color.fromRGBO(30, 214, 158, 1),

                inactiveColor: Colors.grey[200]!,
                onToggle: (value) {
                  if (widget.callback != null) {
                    setState(() {
                      widget.callback!(value);
                    });
                  } else {
                    setState(() {
                      widget.isToggled = value;
                      // ignore: avoid_print
                      print(widget.isToggled);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
*/

// ignore: must_be_immutable
class IconTextAndSwitchWidget extends StatefulWidget {
  bool isToggled;
  final String icon;
  final String text;
  final Function(bool)? callback;
  IconTextAndSwitchWidget({super.key, required this.isToggled, required this.text, required this.icon, this.callback});

  @override
  State<IconTextAndSwitchWidget> createState() => _IconTextAndSwitchWidgetState();
}

class _IconTextAndSwitchWidgetState extends State<IconTextAndSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //const SizedBox(width:15)
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.015,
              right: MediaQuery.of(context).size.height * 0.035,
              top: MediaQuery.of(context).size.height * 0.004),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            //Text(widget.disease, style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w400)), old

            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(widget.icon),
                  ),
                  Text(widget.text,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(112, 112, 112, 1), fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
              FlutterSwitch(
                value: widget.isToggled,
                height: 20,
                width: 40,

                //activeColor: const Color.fromARGB(255, 103, 197, 108),

                //added by George Valentin Iordache
                activeColor: const Color.fromRGBO(30, 214, 158, 1),

                inactiveColor: Colors.grey[200]!,
                onToggle: (value) {
                  if (widget.callback != null) {
                    setState(() {
                      widget.callback!(value);
                    });
                  } else {
                    setState(() {
                      widget.isToggled = value;
                      // ignore: avoid_print
                      print(widget.isToggled);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable

class IconTextTermeniConditii extends StatelessWidget {
  final String text;
  final String icon;

  const IconTextTermeniConditii({super.key, required this.text, required this.icon});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const TermeniSiConditiiScreen();
          }),
        );
      },
      child: Column(
        children: [
          Container(
            //const SizedBox(width:15)
            margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.015,
                right: MediaQuery.of(context).size.height * 0.035,
                top: MediaQuery.of(context).size.height * 0.12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const TermeniSiConditiiScreen();
                              }),
                            );
                          },
                          icon: Image.asset(icon),
                        ),
                        Text(text,
                            style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(112, 112, 112, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
