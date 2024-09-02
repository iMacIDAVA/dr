import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/initializare_numar_pacienti_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/pacienti_istoric/pacient_istoric.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:auto_size_text/auto_size_text.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

import 'package:intl/intl.dart';

class NumarPacientiWidgets extends StatelessWidget {
  //final List<NumarPacientiItem> listaNumarPacienti;

  final List<ConsultatiiMobile> listaConsultatiiMobileNumarPacienti;

  final DateTime startPerioada;
  final DateTime sfarsitPerioada;

  const NumarPacientiWidgets(
      {super.key,
      required this.listaConsultatiiMobileNumarPacienti,
      required this.startPerioada,
      required this.sfarsitPerioada});

  @override
  Widget build(BuildContext context) {
    //InitializareNumarPacientiWidget initPacienti = InitializareNumarPacientiWidget();

    List<Widget> mywidgets = [];
    //const widgetRangePickerPage = RangePickerPage();

    //List<NumarPacientiItem> listaFiltrata = filterListByLowerDurata(25);
    //List<NumarPacientiItem> listaFiltrata = filterListByLowerData(DateTime.utc(2023, 2, 1));
    //List<NumarPacientiItem> listaFiltrata = filterListByHigherData(DateTime.utc(2023, 1, 8));
    //List<NumarPacientiItem> listaFiltrata = filterListByIntervalData(DateTime.utc(2021, 11, 9), DateTime.utc(2023, 10, 14));

    //print('Start perioada: $startPerioada ' + DateTime.utc(startPerioada.year, startPerioada.month, startPerioada.day).toString());

    //print('Sfarsit perioada: $sfarsitPerioada ' + DateTime.utc(sfarsitPerioada.year, sfarsitPerioada.month, sfarsitPerioada.day).toString());

    List<ConsultatiiMobile> listaFiltrata =
        filterListConsultatiiMobileByIntervalData(startPerioada,
            sfarsitPerioada, listaConsultatiiMobileNumarPacienti);

    //List<NumarPacientiItem> listaFiltrata = [];   //listaNumarPacienti;

    var length = listaFiltrata.length;
    print(
        'Size lista: $length startPerioada ${startPerioada.day} sfarsitPerioada ${sfarsitPerioada.day}');

    //for(int index = 0; index <listaFiltrata.length; index++){
    for (var item in listaFiltrata)
    //if (index < listaFiltrata.length-1)
    {
      mywidgets.add(
        //IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget(textNume: listaFiltrata[index].textNume, textOras: "București", iconPath:'./assets/images/pacient_cristina_mihalache.png', textDurata: '10:00 AM - 10:30 AM (30 min)'), //old IGV
        GestureDetector(
          onTap: () {
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
      );
      mywidgets.add(
        const SizedBox(height: 10),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: mywidgets,
      ),
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

  const IconNumeOrasProgramApelareRecomandareTextAndSwitchWidget({
    super.key,
    required this.textNume,
    required this.textOras,
    required this.iconPath,
    required this.textDurata,
    required this.textData,
    required this.tipCerere,
  });
  static const consultVideo = EnumTipConsultatie.consultVideo;
  static const interpretareAnalize = EnumTipConsultatie.interpretareAnalize;
  static const intrebare = EnumTipConsultatie.intrebare;

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
  }
}
