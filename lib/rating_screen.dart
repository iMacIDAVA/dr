import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:auto_size_text/auto_size_text.dart';
import 'package:sos_bebe_profil_bebe_doctor/rating_filtrat_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:intl/intl.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class RatingScreen extends StatefulWidget {
  final List<RecenzieMobile> listaRecenziiByMedicRating;

  const RatingScreen({super.key, required this.listaRecenziiByMedicRating});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  void initState() {
    // Do some other stuff
    super.initState();
  }

  /*
  List<RatingItem> filterListByIndex()
  {
    List<RatingItem> listResult = [];
    for(int index = 0; index <listaRatings.length; index++){
      if (index < 2)
      {
        listResult.add(listaRatings[index]);
      }
    }
    return listResult;
  }
  */

/*
  List<RatingItem> filterListByLowerData(DateTime higherThresholdData)
  {
    List<RatingItem> listResult = [];
    for(int index = 0; index < listaRatings.length; index++){
      var dataStartItem = listaRatings[index].dataStart;

      if (dataStartItem.year < higherThresholdData.year)
      {
        listResult.add(listaRatings[index]);
      }
      else if ((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month < higherThresholdData.month))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month == higherThresholdData.month))
             && (dataStartItem.day < higherThresholdData.day))
      {
        listResult.add(listaRatings[index]);
      }

    }
    return listResult;
  }

  List<RatingItem> filterListByHigherData(DateTime lowerThresholdData)
  {
    List<RatingItem> listResult = [];
    for(int index = 0; index <listaRatings.length; index++){
      var dataStartItem = listaRatings[index].dataStart;
      if (dataStartItem.year > lowerThresholdData.year)
      {
        listResult.add(listaRatings[index]);
      }
      else if (dataStartItem.year == lowerThresholdData.year && dataStartItem.month > lowerThresholdData.month)
      {
        listResult.add(listaRatings[index]);
      }
      else if (dataStartItem.year == lowerThresholdData.year && dataStartItem.month == lowerThresholdData.month
             && dataStartItem.day > lowerThresholdData.day)
      {
        listResult.add(listaRatings[index]);
      }
    }
    return listResult;
  }

  List<RatingItem> filterListByIntervalData(DateTime lowerThresholdData, DateTime higherThresholdData)
  {
    List<RatingItem> listResult = [];
    if (lowerThresholdData.isAfter(higherThresholdData))
    {
      return listResult;
    }

    for(int index = 0; index <listaRatings.length; index++){

      var dataStartItem = listaRatings[index].dataStart;

      if ((dataStartItem.year > lowerThresholdData.year) && (dataStartItem.year < higherThresholdData.year))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month > lowerThresholdData.month))
                  || ((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month < higherThresholdData.month)))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month == lowerThresholdData.month) && (dataStartItem.day > lowerThresholdData.day))
      || ((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month == higherThresholdData.month) && (dataStartItem.day < higherThresholdData.day)))
      {
        listResult.add(listaRatings[index]);
      }
      else if (((dataStartItem.year == lowerThresholdData.year) && (dataStartItem.month == lowerThresholdData.month) && (dataStartItem.day == lowerThresholdData.day))
      || ((dataStartItem.year == higherThresholdData.year) && (dataStartItem.month == higherThresholdData.month) && (dataStartItem.day == higherThresholdData.day)))
      {
        listResult.add(listaRatings[index]);
      }
    }

    return listResult;
  }
*/

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    List<Widget> mywidgets = [];
    //List<NumarPacientiItem> listaFiltrata = filterListByLowerDurata(25);
    //List<NumarPacientiItem> listaFiltrata = filterListByLowerData(DateTime.utc(2023, 2, 1));
    //List<NumarPacientiItem> listaFiltrata = filterListByHigherData(DateTime.utc(2023, 1, 8));
    //List<RatingItem> listaFiltrata = filterListByIntervalData(DateTime.utc(2021, 11, 9), DateTime.utc(2023, 3, 14));

    List<RecenzieMobile> listaFiltrata = widget.listaRecenziiByMedicRating;

    if (listaFiltrata.isEmpty) {
      mywidgets.add(const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Nu există rating-uri pentru perioada selectată.",
          style: TextStyle(fontSize: 18),
        ),
      ));
    }

    listaFiltrata.asMap().forEach((index, value) {
      if (index < listaFiltrata.length - 1) {
        mywidgets.add(
          IconNumeRatingTextDataRaspunde(
            id: value.id.toString(), textNume: value.identitateClient,
            textComentariu: value.comentariu,
            //iconPath:value.linkPozaProfil, textData: DateFormat('dd MMMM yyyy', 'ro').format(value.dataRecenzie), textRating: value.rating.toString()),
            iconPath: value.linkPozaProfil,
            textData: DateFormat('dd MMMM yyyy', l.ratingLimba).format(value.dataRecenzie),
            textRating: value.rating.toString(),
            textRaspuns: value.raspuns,
          ),
        );
        mywidgets.add(
          const SizedBox(height: 15),
        );
      } else {
        mywidgets.add(
          IconNumeRatingTextDataRaspunde(
            id: value.id.toString(), textNume: value.identitateClient,
            textComentariu: value.comentariu,
            //iconPath:value.linkPozaProfil, textData: DateFormat('dd MMMM yyyy', 'ro').format(value.dataRecenzie), textRating: value.rating.toString()), //old IGV
            iconPath: value.linkPozaProfil,
            textData: DateFormat('dd MMMM yyyy', l.ratingLimba).format(value.dataRecenzie),
            textRating: value.rating.toString(),
            textRaspuns: value.raspuns,
          ),
        );
      }
    });
    //else
    /*
      else if (index == listaFiltrata.length-2)
      {
        mywidgets.add(
          IconNumeRatingTextDataRaspunde(textNume: item.textNume, textComentariu: item.textComentariu,
            iconPath:item.iconPath, textData: item.textData, textRating: ''),
        );
      }
      */
    /*
      else if (index == listaFiltrata.length-1){
        mywidgets.add(
          FadingListViewWidget(textNume: item.textNume, textComentariu: item.textComentariu,
            iconPath:item.iconPath,
            textData: item.textData, textRating: ''),
        );
      }
      */
    //var length = listaRatings.length;
    //print('Size lista: $length');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //TopIconsTextWidget(topText: 'Alege perioada', listaRecenziiByMedicRating: widget.listaRecenziiByMedicRating,), //old IGV
            TopIconsTextWidget(
              topText: l.ratingAlegePerioada,
              listaRecenziiByMedicRating: widget.listaRecenziiByMedicRating,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                //Text('Rating-uri', style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 28, fontWeight: FontWeight.w400)), //old IGV
                Text(l.ratingRatinguri,
                    style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 28, fontWeight: FontWeight.w400)),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: mywidgets.isEmpty
                  ? const Text("Nu aveti rating-uri")
                  : Column(
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
  final String iconPath;
  final String textNume;
  final String textComentariu;
  final String textData;
  final String textRating;
  final String textRaspuns;
  final String id;

  const FadingListViewWidget(
      {super.key,
      required this.id,
      required this.textNume,
      required this.textComentariu,
      required this.iconPath,
      required this.textData,
      required this.textRating,
      required this.textRaspuns});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            //colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
            colors: [Colors.transparent, Colors.white],
            //stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        /*
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return IconNumeRatingTextDataRaspunde(iconPath: iconPath, textNume: textNume, textComentariu: textComentariu, textData: textData, textRating: textRating);
            },
          ),
          */
        child: IconNumeRatingTextDataRaspunde(
          id: id,
          iconPath: iconPath,
          textNume: textNume,
          textComentariu: textComentariu,
          textData: textData,
          textRating: textRating,
          textRaspuns: textRaspuns,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopIconsTextWidget extends StatelessWidget {
  final String topText;

  final List<RecenzieMobile> listaRecenziiByMedicRating;

  const TopIconsTextWidget({super.key, required this.topText, required this.listaRecenziiByMedicRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_outlined),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RatingFiltratScreen(
                            listaRecenziiByMedicRating: listaRecenziiByMedicRating,
                          );
                        }),
                      );
                    },
                    icon: Image.asset('./assets/images/alege_perioada.png'),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return RatingFiltratScreen(
                            listaRecenziiByMedicRating: listaRecenziiByMedicRating,
                          );
                        }),
                      );
                    },
                    child: Text(topText,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 14, fontWeight: FontWeight.w400)),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class IconNumeRatingTextDataRaspunde extends StatefulWidget {
  final String iconPath;
  final String textNume;
  final String textRating;
  final String textComentariu;
  final String textData;
  final String textRaspuns;
  final String id;

  const IconNumeRatingTextDataRaspunde(
      {super.key,
      required this.iconPath,
      required this.textNume,
      required this.textRating,
      required this.textComentariu,
      required this.textData,
      required this.textRaspuns,
      required this.id});

  @override
  State<IconNumeRatingTextDataRaspunde> createState() => _IconNumeRatingTextDataRaspunde();
}

class _IconNumeRatingTextDataRaspunde extends State<IconNumeRatingTextDataRaspunde> {
  bool raspunsCorect = false;
  bool showButonRaspunde = false;

  bool modificareRaspuns = false;
  bool showButonModifica = false;

  bool stergereRaspuns = false;
  bool showButonSterge = false;

  final TextEditingController raspunsController = TextEditingController();
  final GlobalKey<FormState> _keyDialogForm = GlobalKey<FormState>();

  Future<http.Response?> raspundeLaFeedbackDinContMedic(String idFeedback, String comentariu) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    http.Response? resRaspundeLaFeedbackDinContMedic = await apiCallFunctions.raspundeLaFeedbackDinContMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdFeedback: idFeedback,
      pComentariu: comentariu,
    );

    if (int.parse(resRaspundeLaFeedbackDinContMedic!.body) == 200) {
      setState(() {
        raspunsCorect = true;
        showButonRaspunde = false;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Răspuns salvat cu succes!'; //old IGV
      textMessage = l.ratingRaspunsSalvatCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resRaspundeLaFeedbackDinContMedic.body) == 400) {
      setState(() {
        raspunsCorect = false;
        showButonRaspunde = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.ratingRaspundeLaFeedbackDinContMedicApelInvalid;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resRaspundeLaFeedbackDinContMedic.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      setState(() {
        raspunsCorect = false;
        showButonRaspunde = true;
      });

      //textMessage = 'Eroare la adăugare răspuns!'; //old IGV
      textMessage = l.ratingRaspundeLaFeedbackDinContMedicEroareLaAdaugareRaspuns;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resRaspundeLaFeedbackDinContMedic.body) == 405) {
      setState(() {
        raspunsCorect = false;
        showButonRaspunde = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.ratingRaspundeLaFeedbackDinContMedicInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resRaspundeLaFeedbackDinContMedic.body) == 500) {
      setState(() {
        raspunsCorect = false;
        showButonRaspunde = true;
      });

      //textMessage = 'A apărut o eroare la execuția metodei!';
      textMessage = l.ratingRaspundeLaFeedbackDinContMedicAAparutOEroare;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);
      return resRaspundeLaFeedbackDinContMedic;
    }

    return null;
  }

  Future<http.Response?> modificaRaspunsDeLaFeedbackDinContMedic(String idFeedback, String comentariu) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    http.Response? resModificaRaspunsDeLaFeedbackDinContMedic =
        await apiCallFunctions.modificaRaspunsDeLaFeedbackDinContMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdFeedback: idFeedback,
      pComentariu: comentariu,
    );

    if (resModificaRaspunsDeLaFeedbackDinContMedic!.statusCode == 200) {
      setState(() {
        modificareRaspuns = true;
        showButonModifica = false;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Răspuns modificat cu succes!'; //old IGV
      textMessage = l.ratingModificaRaspunsDeLaFeedbackRaspunsModificatCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (resModificaRaspunsDeLaFeedbackDinContMedic.statusCode == 400) {
      setState(() {
        modificareRaspuns = false;
        showButonModifica = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.ratingModificaRaspunsDeLaFeedbackApelInvalid;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (resModificaRaspunsDeLaFeedbackDinContMedic.statusCode == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      setState(() {
        modificareRaspuns = false;
        showButonModifica = true;
      });

      //textMessage = 'Eroare la modificare răspuns!'; //old IGV
      textMessage = l.ratingModificaRaspunsDeLaFeedbackEroareLaModificareRaspuns;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (resModificaRaspunsDeLaFeedbackDinContMedic.statusCode == 405) {
      setState(() {
        modificareRaspuns = false;
        showButonModifica = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l
          .ratingModificaRaspunsDeLaFeedbackInformatiiInsuficiente; //ratingRaspundeLaFeedbackDinContMedicInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (resModificaRaspunsDeLaFeedbackDinContMedic.statusCode == 500) {
      setState(() {
        modificareRaspuns = false;
        showButonModifica = true;
      });

      //textMessage = 'A apărut o eroare la execuția metodei!';
      textMessage = l.ratingModificaRaspunsDeLaFeedbackAAparutOEroare;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);
      return resModificaRaspunsDeLaFeedbackDinContMedic;
    }

    return null;
  }

  Future<http.Response?> stergeRaspunsDeLaFeedbackDinContMedic(String idFeedback) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resStergeRaspunsDeLaFeedbackDinContMedic =
        await apiCallFunctions.stergeRaspunsDeLaFeedbackDinContMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdFeedback: idFeedback,
    );

    if (resStergeRaspunsDeLaFeedbackDinContMedic!.statusCode == 200) {
      setState(() {
        //stergereEducatieMedicReusita = true;

        stergereRaspuns = true;
        showButonSterge = false;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Răspuns șters cu succes!'; //old IGV
      textMessage = l.ratingStergeRaspunsDeLaFeedbackRaspunsStersCuSucces; //setariProfilEducatieStearsaCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (resStergeRaspunsDeLaFeedbackDinContMedic.statusCode == 400) {
      setState(() {
        stergereRaspuns = false;
        showButonSterge = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.ratingStergeRaspunsDeLaFeedbackApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (resStergeRaspunsDeLaFeedbackDinContMedic.statusCode == 401) {
      setState(() {
        stergereRaspuns = false;
        showButonSterge = true;
      });

      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Eroare! Răspunsul nu a putut fi șters!'; //old IGV
      textMessage = l.ratingStergeRaspunsDeLaFeedbackEroareRaspunsulNuAPututFiSters;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (resStergeRaspunsDeLaFeedbackDinContMedic.statusCode == 405) {
      setState(() {
        stergereRaspuns = false;
        showButonSterge = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.ratingStergeRaspunsDeLaFeedbackInformatiiInsuficiente;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (resStergeRaspunsDeLaFeedbackDinContMedic.statusCode == 500) {
      setState(() {
        stergereRaspuns = false;
        showButonSterge = true;
      });

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
      textMessage = l.ratingStergeRaspunsDeLaFeedbackAAparutOEroare;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);
      return resStergeRaspunsDeLaFeedbackDinContMedic;
    }
    return null;
  }

  Future showRaspunsDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Form(
              key: _keyDialogForm,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    /*decoration: const InputDecoration(
                    icon: Icon(Icons.ac_unit),
                  ),
                  */
                    maxLines: 8,
                    textAlign: TextAlign.center,
                    onSaved: (val) {
                      raspunsController.text = val!;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Introduceți un răspuns';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  if (_keyDialogForm.currentState!.validate()) {
                    _keyDialogForm.currentState!.save();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Salvează',
                  style: TextStyle(color: Color.fromARGB(255, 14, 190, 127)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 14, 190, 127)),
                ),
              ),
            ],
          );
        });
  }

  String fieldRaspunsDat = '';
  final TextEditingController _textFieldRaspund = TextEditingController();

  final TextEditingController _textFieldModificaRaspuns = TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xff0EBE7F),
            width: 7,
          ),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
              child: widget.iconPath.isEmpty
                  ? Image.asset(
                      './assets/images/user_fara_poza.png',
                    )
                  : Image.network(
                      widget.iconPath,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.textNume,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff677294),
                    ),
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '4.9',
                        style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Text(
                    widget.textComentariu,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff677294),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.textData,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff677294),
                          ),
                        ),
                      ),
                      if (widget.textRaspuns.isNotEmpty || !raspunsCorect)
                        GestureDetector(
                          onTap: () {
                            _showRaspundDialog();
                          },
                          child: Row(
                            children: [
                              Text(
                                l.ratingRaspunde,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff0EBE7F),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Image.asset('./assets/images/raspunde_rating.png'),
                            ],
                          ),
                        )
                    ],
                  ),
                  if (widget.textRaspuns.isNotEmpty || raspunsCorect) const SizedBox(height: 10),
                  if (widget.textRaspuns.isNotEmpty || raspunsCorect)
                    Divider(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  if (widget.textRaspuns.isNotEmpty || raspunsCorect) const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.textRaspuns.isNotEmpty
                              ? widget.textRaspuns
                              : raspunsCorect
                                  ? fieldRaspunsDat
                                  : '',
                          style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (raspunsCorect)
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      GestureDetector(
                        onTap: () async {
                          widget.textRaspuns.isNotEmpty
                              ? _textFieldModificaRaspuns.text = widget.textRaspuns
                              : raspunsCorect
                                  ? _textFieldModificaRaspuns.text = fieldRaspunsDat
                                  : null;

                          _showEditareDialog();
                        },
                        child: SizedBox(
                          //child: Text('Modifică', //old IGV
                          child: Text(l.ratingModifica,
                              style: GoogleFonts.rubik(
                                  color: const Color.fromRGBO(14, 190, 127, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await stergeRaspunsDeLaFeedbackDinContMedic(widget.id);
                          setState(() {
                            raspunsCorect = false;
                          });
                        },
                        child: SizedBox(
                          //child: Text('Șterge', //old IGV
                          child: Text(l.ratingSterge,
                              style: GoogleFonts.rubik(
                                  color: const Color.fromRGBO(14, 190, 127, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showEditareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Răspunde'),
          content: TextFormField(
            controller: _textFieldModificaRaspuns,
            onChanged: (value) {
              _textFieldModificaRaspuns.text = value;
              fieldRaspunsDat = value;
            },
            decoration: const InputDecoration(
              hintText: "Mulțumesc..",
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anulează'),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                _textFieldModificaRaspuns.text.isNotEmpty
                    ? await modificaRaspunsDeLaFeedbackDinContMedic(widget.id, _textFieldModificaRaspuns.text)
                    : Fluttertoast.showToast(msg: "Introduceți un răspuns");

                _textFieldRaspund.clear();
                setState(() {});
              },
              child: const Text('Răspunde'),
            ),
          ],
        );
      },
    );
  }

  _showRaspundDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Răspunde'),
          content: TextFormField(
            controller: _textFieldRaspund,
            onChanged: (value) {
              _textFieldRaspund.text = value;
              fieldRaspunsDat = value;
            },
            decoration: const InputDecoration(
              hintText: "Mulțumesc..",
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anulează'),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                _textFieldRaspund.text.isNotEmpty
                    ? await raspundeLaFeedbackDinContMedic(widget.id, _textFieldRaspund.text)
                    : Fluttertoast.showToast(msg: "Introduceți un răspuns");

                _textFieldRaspund.clear();
                setState(() {});
              },
              child: const Text('Răspunde'),
            ),
          ],
        );
      },
    );
  }
}
