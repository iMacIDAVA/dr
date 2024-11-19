import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;
import 'package:intl/intl.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sos_bebe_profil_bebe_doctor/incasari/incasari_page.dart';

import 'package:sos_bebe_profil_bebe_doctor/numar_pacienti_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/rating_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/suma_de_incasat_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';

import 'package:sos_bebe_profil_bebe_doctor/meniu_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

List<ConsultatiiMobile> listaConsultatiiMobile = [];

List<RecenzieMobile> listaRecenzieMobile = [];

List<IncasareMedic> listaIncasariMedic = [];

const ron = EnumTipMoneda.lei;

TotaluriMedic? totaluriDashboardMedic;

List<TotaluriMedic>? listaInitialaTotaluriMedicZi = [];

class DashboardScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;
  final TotaluriMedic totaluriMedic;
  const DashboardScreen({super.key, required this.contMedicMobile, required this.totaluriMedic});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isToggledEstiOnline = false;
  bool isVisibleEstiOnline = false;

  bool isToggledPrimesteIntrebari = false;
  bool isVisiblePrimesteIntrebari = false;

  bool isToggledInterpretareAnalize = false;
  bool isVisibleInterpretareAnalize = false;

  bool isToggledConsultatieVideo = false;
  bool isVisibleConsultatieVideo = false;

  bool isDisponibleForNotifications = false;
  bool isVisible = false;

  @override
  initState() {
    super.initState();
    getKey();
    loadToggleState();
  }

  void loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isToggledEstiOnline = prefs.getBool('isOnline') ?? false;
      isToggledPrimesteIntrebari = prefs.getBool(pref_keys.primesteIntrebari) ?? false;
      isToggledInterpretareAnalize = prefs.getBool(pref_keys.interpreteazaAnalize) ?? false;
      isToggledConsultatieVideo = prefs.getBool(pref_keys.permiteConsultVideo) ?? false;

      if (!isToggledPrimesteIntrebari && !isToggledInterpretareAnalize && !isToggledConsultatieVideo) {
        isToggledEstiOnline = false;
        prefs.setBool('isOnline', false);
      }
    });
  }

  void callbackEstiOnline(bool newIsVisibleEstiOnline) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!newIsVisibleEstiOnline) {
      setState(() {
        isToggledEstiOnline = false;
        isToggledPrimesteIntrebari = false;
        isToggledInterpretareAnalize = false;
        isToggledConsultatieVideo = false;
      });

      prefs.setBool('isOnline', false);
      prefs.setBool(pref_keys.primesteIntrebari, false);
      prefs.setBool(pref_keys.interpreteazaAnalize, false);
      prefs.setBool(pref_keys.permiteConsultVideo, false);
    } else if (!isToggledPrimesteIntrebari && !isToggledInterpretareAnalize && !isToggledConsultatieVideo) {
      setState(() {
        isToggledEstiOnline = false;
      });
      prefs.setBool('isOnline', false);
      return;
    } else {
      setState(() {
        isToggledEstiOnline = newIsVisibleEstiOnline;
      });
      prefs.setBool('isOnline', newIsVisibleEstiOnline);
    }

    await seteazaStatusuriMedic();
  }

  void callbackPrimesteIntrebari(bool newIsVisiblePrimesteIntrebari) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isToggledPrimesteIntrebari = newIsVisiblePrimesteIntrebari;
    });

    prefs.setBool(pref_keys.primesteIntrebari, newIsVisiblePrimesteIntrebari);

    if (!isToggledPrimesteIntrebari && !isToggledInterpretareAnalize && !isToggledConsultatieVideo) {
      setState(() {
        isToggledEstiOnline = false;
      });
      prefs.setBool('isOnline', false);
    } else if (!isToggledEstiOnline) {
      setState(() {
        isToggledEstiOnline = true;
      });
      prefs.setBool('isOnline', true);
    }

    await seteazaStatusuriMedic();
  }

  void callbackInterpretareAnalize(bool newIsVisibleInterpretareAnalize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isToggledInterpretareAnalize = newIsVisibleInterpretareAnalize;
    });

    prefs.setBool(pref_keys.interpreteazaAnalize, newIsVisibleInterpretareAnalize);

    if (!isToggledPrimesteIntrebari && !isToggledInterpretareAnalize && !isToggledConsultatieVideo) {
      setState(() {
        isToggledEstiOnline = false;
      });
      prefs.setBool('isOnline', false);
    } else if (!isToggledEstiOnline) {
      setState(() {
        isToggledEstiOnline = true;
      });
      prefs.setBool('isOnline', true);
    }

    await seteazaStatusuriMedic();
  }

  void callbackConsultatieVideo(bool newIsVisibleConsultatieVideo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isToggledConsultatieVideo = newIsVisibleConsultatieVideo;
    });

    prefs.setBool(pref_keys.permiteConsultVideo, newIsVisibleConsultatieVideo);

    if (!isToggledPrimesteIntrebari && !isToggledInterpretareAnalize && !isToggledConsultatieVideo) {
      setState(() {
        isToggledEstiOnline = false;
      });
      prefs.setBool('isOnline', false);
    } else if (!isToggledEstiOnline) {
      setState(() {
        isToggledEstiOnline = true;
      });
      prefs.setBool('isOnline', true);
    }

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
      pInterpreteazaAnalize: isToggledInterpretareAnalize.toString(),
      pPermiteConsultVideo: isToggledConsultatieVideo.toString(),
      pPrimesteIntrebari: isToggledPrimesteIntrebari.toString(),
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

  String oneSignal = '';
  void getKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oneSignal = prefs.getString("oneSignalId")!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
                      onToggleStatusChanged: () async {
                        await seteazaStatusuriMedic();
                      },
                    ),
                  ));
            },
            icon: Image.asset('./assets/images/left_top_icon.png'),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(l.dashboardEstiON,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  const SizedBox(width: 5),
                  FlutterSwitch(
                    value: isToggledEstiOnline,
                    height: 25,
                    width: 60,
                    activeColor: const Color.fromRGBO(14, 190, 127, 1),
                    inactiveColor: Colors.grey[200]!,
                    onToggle: (value) async {
                      callbackEstiOnline(value);
                      setState(() {});
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 10, 17, 38),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 74,
                      ),
                      Text(
                        l.dashboardBunVenit,
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(103, 114, 148, 1),
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: widget.contMedicMobile.linkPozaProfil.isEmpty
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
                      const SizedBox(
                        width: 14,
                      ),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.contMedicMobile.titulatura}. ${widget.contMedicMobile.numeComplet}',
                            style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(14, 190, 127, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            widget.contMedicMobile.locDeMunca,
                            style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(103, 114, 148, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            widget.contMedicMobile.adresaLocDeMunca,
                            style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(103, 114, 148, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            '${widget.contMedicMobile.specializarea}, ${widget.contMedicMobile.functia}',
                            style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(103, 114, 148, 1),
                                fontSize: 9,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ))
                    ],
                  ),
                  customDivider(),
                  const SizedBox(height: 5),
                  TextAndSwitchWidget(
                    isToggled: isToggledPrimesteIntrebari,
                    optiuniText: l.dashboardPrimesteIntrebari,
                    callback: callbackPrimesteIntrebari,
                  ),
                  TextAndSwitchWidget(
                    isToggled: isToggledInterpretareAnalize,
                    optiuniText: l.dashboardInterpretareAnalize,
                    callback: callbackInterpretareAnalize,
                  ),
                  TextAndSwitchWidget(
                    isToggled: isToggledConsultatieVideo,
                    optiuniText: l.dashboardConsultatieVideo,
                    callback: callbackConsultatieVideo,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 11, 0),
                    padding: const EdgeInsets.all(30),
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: const BorderSide(width: 1, color: Color.fromRGBO(14, 190, 127, 1)))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              l.dashboardRaportTitlu,
                              style: const TextStyle(
                                  color: Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        RaportIconTextNumarDetaliiWidget(
                          defText: l.dashboardNumarPacienti,
                          numarText: widget.totaluriMedic.totalNrPacienti.toString(),
                          iconPath: "./assets/images/numar_pacienti.png",
                          tipSectiune: 1,
                          contMedicMobile: widget.contMedicMobile,
                          totaluriMedic: widget.totaluriMedic,
                        ),
                        customDivider(),
                        RaportIconTextNumarDetaliiWidget(
                          defText: l.dashboardRating,
                          numarText: widget.totaluriMedic.totalNrRatinguri.toString(),
                          iconPath: "./assets/images/rating_dashboard.png",
                          tipSectiune: 2,
                          totaluriMedic: widget.totaluriMedic,
                        ),
                        customDivider(),
                        RaportIconTextNumarLeiDetaliiWidget(
                          defSuma: l.dashboardSumaDeIncasat,
                          numarText: widget.totaluriMedic.totalDeIncasat.toString(),
                          iconPath: "./assets/images/suma_de_incasat.png",
                          moneda: widget.totaluriMedic.moneda,
                          tipSectiune: 3,
                        ),
                        customDivider(),
                        RaportIconTextNumarLeiDetaliiWidget(
                          defSuma: l.dashboardTotalIncasari,
                          numarText: widget.totaluriMedic.totalDeIncasat.toString(),
                          iconPath: "./assets/images/total_incasari.png",
                          moneda: widget.totaluriMedic.moneda,
                          tipSectiune: 4,
                        ),
                      ],
                    ),
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
      this.callback,
      required this.contMedicMobile,
      required this.totaluriMedic});

  @override
  State<TopIconTextAndSwitchWidget> createState() => _TopIconTextAndSwitchWidgetState();
}

class _TopIconTextAndSwitchWidgetState extends State<TopIconTextAndSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                        contMedicMobile: widget.contMedicMobile,
                        totaluriMedic: widget.totaluriMedic,
                      ),
                    ));
              },
              icon: Image.asset('./assets/images/left_top_icon.png'),
            ),
            const SizedBox(width: 185),
            Text(widget.topText,
                style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
            const SizedBox(width: 5),
            FlutterSwitch(
              value: widget.isToggled,
              height: 25,
              width: 60,
              activeColor: const Color.fromRGBO(14, 190, 127, 1),
              inactiveColor: Colors.grey[200]!,
              onToggle: (value) {
                if (widget.callback != null) {
                  setState(() {
                    widget.callback!(value);
                  });
                } else {
                  setState(() {
                    widget.isToggled = value;
                  });
                }
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TextAndSwitchWidget extends StatefulWidget {
  bool isToggled;
  final Function(bool)? callback;
  final String optiuniText;
  TextAndSwitchWidget({super.key, required this.isToggled, required this.optiuniText, this.callback});

  @override
  State<TextAndSwitchWidget> createState() => _TextAndSwitchWidgetState();
}

class _TextAndSwitchWidgetState extends State<TextAndSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.optiuniText,
                style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
            FlutterSwitch(
              value: widget.isToggled,
              height: 25,
              width: 60,
              activeColor: const Color.fromRGBO(14, 190, 127, 1),
              inactiveColor: Colors.grey[200]!,
              onToggle: (value) {
                if (widget.callback != null) {
                  setState(() {
                    widget.callback!(value);
                  });
                } else {
                  setState(() {
                    widget.isToggled = value;
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 5),
        customDivider(),
        const SizedBox(height: 5),
      ],
    );
  }
}

// ignore: must_be_immutable
class RaportIconTextNumarDetaliiWidget extends StatelessWidget {
  final int tipSectiune;
  final String iconPath;
  final String defText;
  final String numarText;
  final Function(bool)? callback;
  final ContMedicMobile? contMedicMobile;
  final TotaluriMedic totaluriMedic;

  const RaportIconTextNumarDetaliiWidget(
      {super.key,
      required this.iconPath,
      required this.tipSectiune,
      required this.defText,
      required this.numarText,
      this.callback,
      this.contMedicMobile,
      required this.totaluriMedic});

  getListaClientiPeMedicPePerioada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime dateTime = DateTime.now();

    listaConsultatiiMobile = await apiCallFunctions.getListaClientiPeMedicPePerioada(
          pUser: user,
          pParola: userPassMD5,
          pDataInceputDDMMYYYY: '01010001',
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

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return GestureDetector(
      onTap: () async {
        if (tipSectiune == 1) {
          await getListaClientiPeMedicPePerioada();
        } else if (tipSectiune == 2) {
          await getListaRecenziiByMedicPePerioada();
        }
        if (context.mounted) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            if (tipSectiune == 1) {
              return NumarPacientiScreen(
                listaConsultatiiMobileNumarPacienti: listaConsultatiiMobile,
                contMedicMobile: contMedicMobile!,
                totaluriMedic: totaluriMedic,
              );
            } else if (tipSectiune == 2) {
              return RatingScreen(listaRecenziiByMedicRating: listaRecenzieMobile);
            }

            return NumarPacientiScreen(
                listaConsultatiiMobileNumarPacienti: listaConsultatiiMobile,
                contMedicMobile: contMedicMobile!,
                totaluriMedic: totaluriMedic);
          }));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(14, 190, 127, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      iconPath,
                    ),
                    iconSize: 45,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 25),
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      defText,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    numarText,
                    style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ]),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                if (tipSectiune == 1) {
                  await getListaClientiPeMedicPePerioada();
                } else if (tipSectiune == 2) {
                  await getListaRecenziiByMedicPePerioada();
                }
                if (context.mounted) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    if (tipSectiune == 1) {
                      return NumarPacientiScreen(
                        listaConsultatiiMobileNumarPacienti: listaConsultatiiMobile,
                        contMedicMobile: contMedicMobile!,
                        totaluriMedic: totaluriMedic,
                      );
                    } else if (tipSectiune == 2) {
                      return RatingScreen(listaRecenziiByMedicRating: listaRecenzieMobile);
                    }

                    return NumarPacientiScreen(
                        listaConsultatiiMobileNumarPacienti: listaConsultatiiMobile,
                        contMedicMobile: contMedicMobile!,
                        totaluriMedic: totaluriMedic);
                  }));
                }
              },
              child: Text(l.dashboardDetaliiRatingNumarPacienti,
                  style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1),
                    fontSize: 9,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class RaportIconTextNumarLeiDetaliiWidget extends StatelessWidget {
  final String iconPath;
  final String defSuma;
  final String numarText;
  final int tipSectiune;
  final int moneda;

  static const ron = EnumTipMoneda.lei;
  static const euro = EnumTipMoneda.euro;

  const RaportIconTextNumarLeiDetaliiWidget(
      {super.key,
      required this.iconPath,
      required this.defSuma,
      required this.numarText,
      required this.moneda,
      required this.tipSectiune});

  getTotaluriDashboardMedicPePerioada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime dateTime = DateTime.now();

    totaluriDashboardMedic = await apiCallFunctions.getTotaluriDashboardMedicPePerioada(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY: '01010001',
      pDataSfarsitDDMMYYYY: inputFormat.format(dateTime).toString(),
    );

    return totaluriDashboardMedic;
  }

  getListaTranzactiiMedicPePerioada() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime dateTime = DateTime.now();

    listaIncasariMedic = await apiCallFunctions.getListaTranzactiiMedicPePerioada(
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
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return GestureDetector(
      onTap: () async {
        if (tipSectiune == 3) {
          await getPuncteTotaluriDashboardMedicZi();
        } else if (tipSectiune == 4) {
          await getTotaluriDashboardMedicPePerioada();
          await getListaTranzactiiMedicPePerioada();
        }

        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (tipSectiune == 3) {
                return IncasariPage(
                  totaluriMedic: listaInitialaTotaluriMedicZi!,
                );
              } else if (tipSectiune == 4) {
                return SumaIncasatScreen(
                  totaluriDashboardMedic: totaluriDashboardMedic!,
                  listaTranzactiiMedicPePerioada: listaIncasariMedic,
                );
              }
              return SumaIncasatScreen(
                totaluriDashboardMedic: totaluriDashboardMedic!,
                listaTranzactiiMedicPePerioada: listaIncasariMedic,
              );
            }),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(14, 190, 127, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      iconPath,
                    ),
                    iconSize: 45,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Text(
                  defSuma,
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    AutoSizeText(
                      numarText,
                      style:
                          GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontWeight: FontWeight.w500),
                      maxLines: 1,
                      minFontSize: 20.0,
                      maxFontSize: 37,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      moneda == ron.value ? l.dashboardLei : l.dashboardEuro,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                if (tipSectiune == 3) {
                  await getPuncteTotaluriDashboardMedicZi();
                } else if (tipSectiune == 4) {
                  await getTotaluriDashboardMedicPePerioada();
                  await getListaTranzactiiMedicPePerioada();
                }

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      if (tipSectiune == 3) {
                        return IncasariPage(
                          totaluriMedic: listaInitialaTotaluriMedicZi!,
                        );
                      } else if (tipSectiune == 4) {
                        return SumaIncasatScreen(
                          totaluriDashboardMedic: totaluriDashboardMedic!,
                          listaTranzactiiMedicPePerioada: listaIncasariMedic,
                        );
                      }
                      return SumaIncasatScreen(
                        totaluriDashboardMedic: totaluriDashboardMedic!,
                        listaTranzactiiMedicPePerioada: listaIncasariMedic,
                      );
                    }),
                  );
                }
              },
              child: Text(
                l.dashboardDetaliiIncasariSumaDeIncasat,
                style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 9, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
