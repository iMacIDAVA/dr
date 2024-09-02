import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/pacienti_istoric/pacient_istoric.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
import 'package:sos_bebe_profil_bebe_doctor/initializare_numar_pacienti_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/numar_pacienti_filtrat_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/meniu_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:intl/intl.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class NumarPacientiScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;
  final TotaluriMedic totaluriMedic;
  final List<ConsultatiiMobile> listaConsultatiiMobileNumarPacienti;

  const NumarPacientiScreen(
      {super.key,
      required this.listaConsultatiiMobileNumarPacienti,
      required this.contMedicMobile,
      required this.totaluriMedic});

  @override
  State<NumarPacientiScreen> createState() => _NumarPacientiScreenState();
}

class _NumarPacientiScreenState extends State<NumarPacientiScreen> {
  //InitializareNumarPacientiWidget initWidget = InitializareNumarPacientiWidget();

  //List<NumarPacientiItem> listaNumarPacienti = [];

  void callback(bool newIsVisible) {
    setState(() {
      isVisible = newIsVisible;
    });
  }

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    List<Widget> mywidgets = [];

    List<ConsultatiiMobile> listaFiltrata =
        widget.listaConsultatiiMobileNumarPacienti;

    for (var item in listaFiltrata) {
      mywidgets.add(
        GestureDetector(
          onTap: () async {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return PacientIstoric(idPacient: item.id.toString());
              },
            ));
          },
          child: IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget(
              textNume: item.numeCompletClient,
              textOras: item.adresa,
              iconPath: item.linkPozaProfil,
              textDurata:
                  '${DateFormat('hh:mm a').format(item.dataInceput)} - ${DateFormat('hh:mm a').format(item.dataSfarsit)} (${item.etichetaDurata})',
              textData: DateTime(item.dataInceput.year, item.dataInceput.month,
                          item.dataInceput.day) ==
                      DateTime(item.dataSfarsit.year, item.dataSfarsit.month,
                          item.dataSfarsit.day)
                  ? DateFormat('dd.MM.yyyy').format(item.dataInceput)
                  : '${DateFormat('dd.MM.yyyy').format(item.dataInceput)} - ${DateFormat('dd.MM.yyyy').format(item.dataSfarsit)}',
              tipCerere: item.tipConsultatie),
        ),
        //textDurata: '10:00 AM - 10:30 AM (30 min)'),
      );
    }
    var length = listaFiltrata.length;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeniuScreen(
                    contMedicMobile: widget.contMedicMobile,
                    totaluriMedic: widget.totaluriMedic,
                  ),
                ));
          },
          icon: Image.asset('./assets/images/left_top_icon.png'),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NumarPacientiFiltratScreen(
                  listaConsultatiiMobileNumarPacienti:
                      widget.listaConsultatiiMobileNumarPacienti,
                );
              }));
            },
            child: Text(l.numarPacientiSelecteazaPerioada,
                style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NumarPacientiFiltratScreen(
                  listaConsultatiiMobileNumarPacienti:
                      widget.listaConsultatiiMobileNumarPacienti,
                );
              }));
            },
            icon: Image.asset('./assets/images/filtrare_right_top_icon.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 56),
            Center(
              child: Column(
                children: mywidgets,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FadingListViewWidget extends StatelessWidget {
  final String textNume;
  final String textOras;
  final String iconPath;
  final String textDurata;
  final String textData;
  final int tipCerere;

  const FadingListViewWidget(
      {super.key,
      required this.textNume,
      required this.textOras,
      required this.iconPath,
      required this.textDurata,
      required this.textData,
      required this.tipCerere});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 137,
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white,
              ], //, Colors.transparent, Colors.white],
              //stops: [1.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget(
              textNume: textNume,
              textOras: textOras,
              iconPath: iconPath,
              textDurata: textDurata,
              textData: textData,
              tipCerere: tipCerere),
          //ListView.builder(
          //  itemCount: 1,
          //  itemBuilder: (BuildContext context, int index) {
          //return IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget(textNume: textNume, textOras: textOras, iconPath: iconPath, textDurata: textDurata);
          //},
          //),
          //SingleChildScrollView(
          //  child: IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget(textNume: textNume, textOras: textOras, iconPath: iconPath, textDurata: textDurata),
          //)
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopIconsTextWidget extends StatelessWidget {
  final String topText;

  final ContMedicMobile contMedicMobile;

  final List<ConsultatiiMobile> listaConsultatiiMobileNumarPacienti;

  const TopIconsTextWidget(
      {super.key,
      required this.topText,
      required this.contMedicMobile,
      required this.listaConsultatiiMobileNumarPacienti});

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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeniuScreen(
                        contMedicMobile: contMedicMobile,
                        totaluriMedic: totaluriMedic!,
                      ),
                    ));
              },
              icon: Image.asset('./assets/images/left_top_icon.png'),
            ),
            const SizedBox(width: 160),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NumarPacientiFiltratScreen(
                    listaConsultatiiMobileNumarPacienti:
                        listaConsultatiiMobileNumarPacienti,
                  );
                }));
              },
              child: Text(topText,
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(103, 114, 148, 1),
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NumarPacientiFiltratScreen(
                    listaConsultatiiMobileNumarPacienti:
                        listaConsultatiiMobileNumarPacienti,
                  );
                }));
              },
              icon: Image.asset('./assets/images/filtrare_right_top_icon.png'),
            ),
          ],
        ),
      ],
    );
  }
}

class IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget
    extends StatelessWidget {
  final String textNume;
  final String textOras;
  final String iconPath;
  final String textDurata;
  final String textData;
  final int tipCerere;

  static const consultVideo = EnumTipConsultatie.consultVideo;
  static const interpretareAnalize = EnumTipConsultatie.interpretareAnalize;
  static const intrebare = EnumTipConsultatie.intrebare;

  const IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget(
      {super.key,
      required this.textNume,
      required this.textOras,
      required this.iconPath,
      required this.textDurata,
      required this.textData,
      required this.tipCerere});

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey[400]),
                  child: iconPath.isEmpty
                      ? Image.asset('/assets/user_fara_poza.png')
                      : Image.network(iconPath),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textNume,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff677294),
                        ),
                      ),
                      Text(
                        textOras,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff677294),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 1,
              color: Color.fromARGB(255, 217, 217, 217),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              textDurata,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff677294),
              ),
            ),
            Text(
              textData,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff677294),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (tipCerere == consultVideo.value ||
                tipCerere == interpretareAnalize.value ||
                tipCerere == intrebare.value)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: Color(0xff0EBE7F),
                  color: tipCerere == consultVideo.value
                      ? Color(0xff0EBE7F)
                      : tipCerere == interpretareAnalize.value
                          ? Color.fromRGBO(241, 201, 0, 1)
                          : tipCerere == intrebare.value
                              ? Color.fromRGBO(30, 166, 219, 1)
                              : Color(0xff0EBE7F),
                ),
                child: Text(
                  tipCerere == consultVideo.value
                      ? l.numarPacientiApelVideo
                      : tipCerere == interpretareAnalize.value
                          ? l.numarPacientiRecomandare
                          : tipCerere == intrebare.value
                              ? l.numarPacientiIntrebare
                              : "",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
    // child: Column(

    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               //GestureDetector(
    //               tipCerere == consultVideo.value
    //                   ? InkWell(
    //                       child: Container(
    //                         width: 74.0,
    //                         height: 24.0,
    //                         decoration: const BoxDecoration(
    //                           color: Color.fromRGBO(14, 190, 127, 1),
    //                           borderRadius:
    //                               BorderRadius.all(Radius.circular(3)),
    //                         ),
    //                         alignment: Alignment.center,
    //                         //child: Text("Apel video", style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 11, fontWeight: FontWeight.w400)), //old IGV
    //                         child: Text(l.numarPacientiApelVideo,
    //                             style: GoogleFonts.rubik(
    //                                 color:
    //                                     const Color.fromRGBO(255, 255, 255, 1),
    //                                 fontSize: 13,
    //                                 fontWeight: FontWeight.w400)),
    //                       ),
    //                       onTap: () {},
    //                     )
    //                   : tipCerere == interpretareAnalize.value
    //                       ? InkWell(
    //                           child: Container(
    //                             width: 84.0,
    //                             height: 16.0,
    //                             decoration: const BoxDecoration(
    //                               color: Color.fromRGBO(241, 201, 0, 1),
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(3)),
    //                             ),
    //                             alignment: Alignment.center,
    //                             //child: Text("Recomandare", style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 11, fontWeight: FontWeight.w400)), //old IGV
    //                             child: Text(l.numarPacientiRecomandare,
    //                                 style: GoogleFonts.rubik(
    //                                     color: const Color.fromRGBO(
    //                                         255, 255, 255, 1),
    //                                     fontSize: 11,
    //                                     fontWeight: FontWeight.w400)),
    //                           ),
    //                           onTap: () {
    //                             //print("Click event on Recomandare");
    //                           },
    //                         )
    //                       : tipCerere == intrebare.value
    //                           ? InkWell(
    //                               child: Container(
    //                                 width: 84.0,
    //                                 height: 16.0,
    //                                 decoration: const BoxDecoration(
    //                                   color: Color.fromRGBO(30, 166, 219, 1),
    //                                   borderRadius:
    //                                       BorderRadius.all(Radius.circular(3)),
    //                                 ),
    //                                 alignment: Alignment.center,
    //                                 //child: Text('Întrebare', style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 11, fontWeight: FontWeight.w400)), //old IGV
    //                                 child: Text(l.numarPacientiIntrebare,
    //                                     style: GoogleFonts.rubik(
    //                                         color: const Color.fromRGBO(
    //                                             255, 255, 255, 1),
    //                                         fontSize: 11,
    //                                         fontWeight: FontWeight.w400)),
    //                               ),
    //                               onTap: () {
    //                                 //print("Click event on Recomandare");
    //                               },
    //                             )
    //                           : const SizedBox(),
    //               //const SizedBox(width: 10), //old IGV
    //               //GestureDetector(
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
