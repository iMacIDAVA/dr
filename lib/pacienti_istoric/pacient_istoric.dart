import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
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

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class PacientIstoric extends StatefulWidget {
  final String idPacient;
  const PacientIstoric({super.key, required this.idPacient});

  @override
  State<PacientIstoric> createState() => _PacientIstoricState();
}

class _PacientIstoricState extends State<PacientIstoric> {
  static const consultVideo = EnumTipConsultatie.consultVideo;
  static const interpretareAnalize = EnumTipConsultatie.interpretareAnalize;
  static const intrebare = EnumTipConsultatie.intrebare;

  Future<List<ConsultatiiMobile>> getListaConsultatii() async {
    List<ConsultatiiMobile>? consultatiiMobile;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    consultatiiMobile =
        await apiCallFunctions.getListaIstoricConsultatiiPerPacient(
            idPacient: widget.idPacient, pParola: userPassMD5, pUser: user);
    return consultatiiMobile!;
  }

  @override
  void initState() {
    super.initState();
    getListaConsultatii();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: getListaConsultatii(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
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
                                shape: BoxShape.circle,
                                color: Colors.grey[400]),
                            child: snapshot.data![index].linkPozaProfil.isEmpty
                                ? Image.asset('/assets/user_fara_poza.png')
                                : Image.network(
                                    snapshot.data![index].linkPozaProfil),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index].numeCompletClient,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff677294),
                                  ),
                                ),
                                Text(
                                  snapshot.data![index].adresa,
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
                        '${DateFormat('hh:mm a').format(snapshot.data![index].dataInceput)} - ${DateFormat('hh:mm a').format(snapshot.data![index].dataSfarsit)} (${snapshot.data![index].etichetaDurata})',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff677294),
                        ),
                      ),
                      Text(
                        DateTime(
                                    snapshot.data![index].dataInceput.year,
                                    snapshot.data![index].dataInceput.month,
                                    snapshot.data![index].dataInceput.day) ==
                                DateTime(
                                    snapshot.data![index].dataSfarsit.year,
                                    snapshot.data![index].dataSfarsit.month,
                                    snapshot.data![index].dataSfarsit.day)
                            ? DateFormat('dd.MM.yyyy')
                                .format(snapshot.data![index].dataInceput)
                            : '${DateFormat('dd.MM.yyyy').format(snapshot.data![index].dataInceput)} - ${DateFormat('dd.MM.yyyy').format(snapshot.data![index].dataSfarsit)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff677294),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (snapshot.data![index].tipConsultatie ==
                              consultVideo.value ||
                          snapshot.data![index].tipConsultatie ==
                              interpretareAnalize.value ||
                          snapshot.data![index].tipConsultatie ==
                              intrebare.value)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // color: Color(0xff0EBE7F),
                            color: snapshot.data![index].tipConsultatie ==
                                    consultVideo.value
                                ? Color(0xff0EBE7F)
                                : snapshot.data![index].tipConsultatie ==
                                        interpretareAnalize.value
                                    ? Color.fromRGBO(241, 201, 0, 1)
                                    : snapshot.data![index].tipConsultatie ==
                                            intrebare.value
                                        ? Color.fromRGBO(30, 166, 219, 1)
                                        : Color(0xff0EBE7F),
                          ),
                          child: Text(
                            snapshot.data![index].tipConsultatie ==
                                    consultVideo.value
                                ? l.numarPacientiApelVideo
                                : snapshot.data![index].tipConsultatie ==
                                        interpretareAnalize.value
                                    ? l.numarPacientiRecomandare
                                    : snapshot.data![index].tipConsultatie ==
                                            intrebare.value
                                        ? l.numarPacientiIntrebare
                                        : "",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
