//import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/incasari/incasari_page.dart';
//import 'package:sos_bebe_profil_bebe_doctor/meniu_profil_screen_old_IGV_dart';
import 'package:sos_bebe_profil_bebe_doctor/numar_pacienti_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/rating_screen.dart';
//import 'package:sos_bebe_profil_bebe_doctor/profil_medic_screen_old_dart';
import 'package:sos_bebe_profil_bebe_doctor/editare_profil_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

import 'package:http/http.dart' as http;

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

List<ConsultatiiMobile> listaConsultatiiMobile = [];

List<RecenzieMobile> listaRecenzieMobile = [];

List<TotaluriMedic>? listaInitialaTotaluriMedicZi = [];

TotaluriMedic? totaluriDashboardMedic;

//import 'package:sos_bebe_app/login_screen.dart';

class MeniuScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;
  final TotaluriMedic totaluriMedic;
  final VoidCallback? onToggleStatusChanged;

  //final bool estiOnline;

  const MeniuScreen(
      {super.key, required this.contMedicMobile, required this.totaluriMedic, this.onToggleStatusChanged});

  @override
  State<MeniuScreen> createState() => _MeniuScreenState();
}

class _MeniuScreenState extends State<MeniuScreen> {
  bool isToggledEstiOnline = false;
  bool isVisibleEstiOnline = false;

  bool isDisponibleForNotifications = false;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    loadToggleState();
  }

  void loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isToggledEstiOnline = prefs.getBool('isOnline') ?? false;
    });
  }


  Future<void> updateToggleState(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isToggledEstiOnline = newValue;
      isVisibleEstiOnline = newValue;
    });
    prefs.setBool('isOnline', newValue);

    await seteazaStatusuriMedic();
  }

  void syncToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool latestState = prefs.getBool('isOnline') ?? false;

    if (mounted) {
      setState(() {
        isToggledEstiOnline = latestState;
      });
    }
  }


  void callbackEstiOnline(bool newIsVisibleEstiOnline) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isOnline', newIsVisibleEstiOnline);

    setState(() {
      isToggledEstiOnline = newIsVisibleEstiOnline;
    });

    if (newIsVisibleEstiOnline) {

      await prefs.setBool(pref_keys.primesteIntrebari, true);
      await prefs.setBool(pref_keys.interpreteazaAnalize, true);
      await prefs.setBool(pref_keys.permiteConsultVideo, true);
    } else {

      await prefs.setBool(pref_keys.primesteIntrebari, false);
      await prefs.setBool(pref_keys.interpreteazaAnalize, false);
      await prefs.setBool(pref_keys.permiteConsultVideo, false);
    }

    syncToggleState();

    await seteazaStatusuriMedic();
  }



  Future<http.Response?> seteazaStatusuriMedic() async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resSeteazaStatusuriMedic = await apiCallFunctions.seteazaStatusuriMedic(
      pUser: user,
      pParola: userPassMD5,
      pEsteActiv: isToggledEstiOnline.toString(),
      pInterpreteazaAnalize: '',
      pPermiteConsultVideo: '',
      pPrimesteIntrebari: '',
    );

    if (int.parse(resSeteazaStatusuriMedic!.body) == 200) {
      setState(() {});
      prefs.setString("isActive", isToggledEstiOnline.toString());

      textMessage = l.dashboardStatusuriSetateCuSucces;
      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resSeteazaStatusuriMedic.body) == 400) {
      setState(() {});
      textMessage = l.dashboardApelInvalid;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resSeteazaStatusuriMedic.body) == 401) {
      setState(() {});
      textMessage = l.dashboardStatusurileNuAuFostSetate;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resSeteazaStatusuriMedic.body) == 405) {
      setState(() {});
      textMessage = l.dashboardInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resSeteazaStatusuriMedic.body) == 500) {
      setState(() {});
      textMessage = l.dashboardAAparutOEroareLaExecutiaMetodei;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resSeteazaStatusuriMedic;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromRGBO(14, 190, 127, 1),
            child: Column(
              children: [
                const SizedBox(height: 25),
                TopIconTextAndSwitchWidget(
                  isToggled: isToggledEstiOnline,
                  topText: isToggledEstiOnline ? l.meniuEstiON : l.meniuEstiOFF,
                  callback: callbackEstiOnline,
                  contMedicMobile: widget.contMedicMobile,
                  totaluriMedic: widget.totaluriMedic,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    widget.contMedicMobile.linkPozaProfil.isEmpty
                        ? Image.asset(
                            './assets/images/user_fara_poza.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.contMedicMobile.linkPozaProfil,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),

                    // Text(
                    //   l.meniuBunVenit,
                    //   style: GoogleFonts.rubik(
                    //     color: const Color.fromRGBO(255, 255, 255, 1),
                    //     fontWeight: FontWeight.w300,
                    //     fontSize: 12,
                    //   ),
                    // ),
                    //const SizedBox(height: 10),
                    //Text('Dr. Daniela Preoteasa',
                    //    style: GoogleFonts.rubik(color:const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500)), //old IGV
                    Text('${widget.contMedicMobile.titulatura}. ${widget.contMedicMobile.numeComplet}',
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500)),

                    //Text('AIS Clinic & Hospital Bucharest',
                    //    style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 12, fontWeight: FontWeight.w300)), //old IGV
                    Text(widget.contMedicMobile.locDeMunca,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 12, fontWeight: FontWeight.w300)),
                    Text(widget.contMedicMobile.adresaLocDeMunca,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 12, fontWeight: FontWeight.w300)),

                    //Text('Pediatrie, doctor primar',
                    //  style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 9, fontWeight: FontWeight.w300)), //old IGV
                    Text('${widget.contMedicMobile.specializarea}, ${widget.contMedicMobile.functia}',
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 9, fontWeight: FontWeight.w300)),
                    const SizedBox(height: 5),
                  ],
                ),
                const SizedBox(width: 65),
                SizedBox(
                  //width: 360, //old IGV
                  //height: 420, // old IGV
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.76,
                  /*decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder (
                          borderRadius: BorderRadius.circular(6.0),
                          side: const BorderSide(
                              width: 1,
                              color: Color.fromRGBO(14, 190, 127, 1)
                          )
                      )
                  ),
                  */
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        //MeniuIconLink(linkText: "Număr pacienți", iconPath: "./assets/images/numar_pacienti_meniu.png",
                        //  tipSectiune: 1, contMedicMobile: widget.contMedicMobile,), //old IGV
                        MeniuIconLink(
                          totatluriMedicNoi: widget.totaluriMedic,
                          linkText: l.meniuNumarPacienti,
                          iconPath: "./assets/images/numar_pacienti_meniu.png",
                          tipSectiune: 1,
                          contMedicMobile: widget.contMedicMobile,
                        ),
                        const SizedBox(height: 5),
                        //customDivider(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        //const MeniuIconLink(linkText: "Rating", iconPath: "./assets/images/rating_meniu.png",
                        //  tipSectiune: 2,), //old IGV
                        MeniuIconLink(
                          linkText: l.meniuRating,
                          iconPath: "./assets/images/rating_meniu.png",
                          tipSectiune: 2,
                          totatluriMedicNoi: widget.totaluriMedic,
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        //const MeniuIconLink(linkText: "Vezi încasări", iconPath: "./assets/images/incasari_meniu.png",
                        //  tipSectiune: 3,), //old IGV
                        MeniuIconLink(
                          linkText: l.meniuVeziIncasari,
                          iconPath: "./assets/images/incasari_meniu.png",
                          tipSectiune: 3,
                          totatluriMedicNoi: widget.totaluriMedic,
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        //MeniuIconLink(linkText: "Profilul meu", iconPath: "./assets/images/profilul_meu_meniu.png",
                        //  tipSectiune: 4, contMedicMobile: widget.contMedicMobile,), //old IGV
                        MeniuIconLink(
                          totatluriMedicNoi: widget.totaluriMedic,
                          linkText: l.meniuProfilulMeu,
                          iconPath: "./assets/images/profilul_meu_meniu.png",
                          tipSectiune: 4,
                          contMedicMobile: widget.contMedicMobile,
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopIconTextAndSwitchWidget extends StatefulWidget {
  bool isToggled;
  final Function(bool)? callback;
  final String topText;
  final ContMedicMobile contMedicMobile;
  final TotaluriMedic totaluriMedic;

  TopIconTextAndSwitchWidget(
      {super.key,
      required this.isToggled,
      required this.topText,
      required this.contMedicMobile,
      required this.totaluriMedic,
      this.callback});

  @override
  State<TopIconTextAndSwitchWidget> createState() => _TopIconTextAndSwitchWidgetState();
}

class _TopIconTextAndSwitchWidgetState extends State<TopIconTextAndSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(14, 190, 127, 1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    // Navigator.push(Mater)
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return DashboardScreen(
                            contMedicMobile: widget.contMedicMobile, totaluriMedic: widget.totaluriMedic);
                      },
                    ));
                    // Navigator.pop(context);
                  },
                  icon: Image.asset('./assets/images/left_white_top_icon.png'),
                ),
                //const SizedBox(width: 190),

                Row(
                  children: [
                    Text(widget.topText,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                    const SizedBox(
                      width: 10,
                    ),
                    FlutterSwitch(
                      value: widget.isToggled,
                      height: 25,
                      width: 60,
                      //added by George Valentin Iordache
                      //activeColor: Colors.grey[200]!,
                      activeColor: Colors.white,
                      //inactiveColor: const Color.fromRGBO(14, 190, 127, 1),
                      inactiveColor: Colors.white,
                      activeToggleColor: const Color.fromRGBO(14, 190, 127, 1),
                      inactiveToggleColor: Colors.grey[400]!,
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
                //const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MeniuIconLink extends StatelessWidget {
  final int tipSectiune;
  final String iconPath;
  final String linkText;
  final Function(bool)? callback;
  final ContMedicMobile? contMedicMobile;
  final TotaluriMedic totatluriMedicNoi;

  const MeniuIconLink(
      {super.key,
      required this.iconPath,
      required this.tipSectiune,
      required this.linkText,
      this.callback,
      this.contMedicMobile,
      required this.totatluriMedicNoi});

  getListaClientiPeMedicPePerioada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime dateTime = DateTime.now();

    listaConsultatiiMobile = await apiCallFunctions.getListaClientiPeMedicPePerioada(
          pUser: user,
          pParola: userPassMD5,
          pDataInceputDDMMYYYY: '01011001',
          pDataSfarsitDDMMYYYY: inputFormat.format(dateTime).toString(),
        ) ??
        [];
  }

  getListaRecenziiByMedicPePerioada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime dateTime = DateTime.now();

    listaRecenzieMobile = await apiCallFunctions.getListaRecenziiByMedicPePerioada(
          pUser: user,
          pParola: userPassMD5,
          pDataInceputDDMMYYYY: '01010001',
          pDataSfarsitDDMMYYYY: inputFormat.format(dateTime).toString(),
        ) ??
        [];
  }

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPeZi(DateTime dataInceput) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    //DateTime dateTime = DateTime.now();

    listaInitialaTotaluriMedicZi!.clear();

    listaInitialaTotaluriMedicZi = await apiCallFunctions.getTotaluriDashboardMedicPeZi(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY: inputFormat.format(dataInceput).toString(),
    );

    return listaInitialaTotaluriMedicZi!;
  }

  getPuncteTotaluriDashboardMedicZi() async {
    DateTime astazi = DateTime.now();

    listaInitialaTotaluriMedicZi!.clear();

    listaInitialaTotaluriMedicZi = await getTotaluriDashboardMedicPeZi(astazi);
  }

  @override
  Widget build(BuildContext context) {
    //print('tipSectiune: $tipSectiune');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(14, 190, 127, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 45.0,
                    width: 45.0,
                    child: IconButton(
                      onPressed: () async {
                        if (tipSectiune == 1) {
                          await getListaClientiPeMedicPePerioada();
                        } else if (tipSectiune == 2) {
                          await getListaRecenziiByMedicPePerioada();
                        } else if (tipSectiune == 3) {
                          await getPuncteTotaluriDashboardMedicZi();
                        }
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              if (tipSectiune == 1) {
                                return NumarPacientiScreen(
                                  listaConsultatiiMobileNumarPacienti: listaConsultatiiMobile,
                                  contMedicMobile: contMedicMobile!,
                                  totaluriMedic: totatluriMedicNoi,
                                );
                              } else if (tipSectiune == 2) {
                                return RatingScreen(
                                  listaRecenziiByMedicRating: listaRecenzieMobile,
                                );
                              } else if (tipSectiune == 3) {
                                return IncasariPage(
                                  totaluriMedic: listaInitialaTotaluriMedicZi ?? [],
                                );
                              }
                              return EditareProfilScreen(
                                contMedicMobile: contMedicMobile!,
                              );
                            }),
                          );
                        }
                      },
                      icon: Image.asset(
                        iconPath, //./assets/images/numar_pacienti_meniu.png
                      ),
                      iconSize: 45,
                    ),
                  ),
                ],
              ),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (tipSectiune == 1) {
                            await getListaClientiPeMedicPePerioada();
                          } else if (tipSectiune == 2) {
                            await getListaRecenziiByMedicPePerioada();
                          } else if (tipSectiune == 3) {
                            await getPuncteTotaluriDashboardMedicZi();
                          }
                          if (context.mounted) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              if (tipSectiune == 1) {
                                return NumarPacientiScreen(
                                  listaConsultatiiMobileNumarPacienti: listaConsultatiiMobile,
                                  contMedicMobile: contMedicMobile!,
                                  totaluriMedic: totatluriMedicNoi,
                                );
                              } else if (tipSectiune == 2) {
                                return RatingScreen(
                                  listaRecenziiByMedicRating: listaRecenzieMobile,
                                );
                              } else if (tipSectiune == 3) {
                                return IncasariPage(
                                  totaluriMedic: listaInitialaTotaluriMedicZi ?? [],
                                );
                              }

                              return EditareProfilScreen(
                                contMedicMobile: contMedicMobile!,
                              );
                            }));
                          }
                        },
                        child: Text(
                          linkText,
                          style: GoogleFonts.rubik(
                              color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ]),
            //const SizedBox(width: 80),
            //const SizedBox(width: 25),
          ],
        ),
      ],
    );
  }
}
