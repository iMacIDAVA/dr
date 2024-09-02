import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sos_bebe_profil_bebe_doctor/reset_password_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;
import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class CVServices {
  Future<ContMedicMobile> getContMedicUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceType = await apiCallFunctions.getDeviceInfo();
    String oneSingleToken = prefs.getString("oneSignalId") ?? "";
    ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
      pUser: user,
      pParola: userPassMD5,
      pDeviceToken: oneSingleToken,
      pTipDispozitiv: Platform.isAndroid ? '1' : '2',
      pModelDispozitiv: deviceType,
      pTokenVoip: '',
    );

    return resGetCont!;
  }

  Future<http.Response?> actualizeazaCVContMedic(
      BuildContext context,
      String locDeMunca,
      String adresaLocDeMunca,
      String specializare,
      String titluProfesional,
      String experienta) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userLogin = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resActualizeazaCVContMedic =
        await apiCallFunctions.actualizeazaCVContMedic(
      pUser: userLogin,
      pParola: userPassMD5,
      pLocDeMunca: locDeMunca,
      pAdresaLocDeMunca: adresaLocDeMunca,
      pSpecializare: specializare,
      pFunctie: titluProfesional,
      pExperienta: experienta, //de modificat IGV
    );

    print(
        'actualizeazaCVContMedic resActualizeazaCVContMedic.body ${resActualizeazaCVContMedic!.body}');

    if (int.parse(resActualizeazaCVContMedic.body) == 200) {
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pref_keys.locDeMunca, locDeMunca);
      prefs.setString(pref_keys.adresaLocDeMunca, adresaLocDeMunca);
      prefs.setString(pref_keys.specializarea, specializare);
      prefs.setString(pref_keys.titulatura, titluProfesional);
      prefs.setString(pref_keys.experienta, experienta);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      print('Actualizare CV finalizată cu succes!');

      //textMessage = 'Actualizare CV finalizată cu succes!';  //old IGV
      textMessage = l.setariProfilActualizareCVFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 400) {
      print('Apel invalid');

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilActualizareCVApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 401) {
      print('CV-ul nu a putut fi actualizat!');

      //textMessage = 'CV-ul nu a putut fi actualizat!'; //old IGV
      textMessage = l.setariProfilCVulNuAFostActualizat;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 405) {
      print('Informații insuficiente!');

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilActualizareCVInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 500) {
      print('A apărut o eroare la execuția metodei!');

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
      textMessage = l.setariProfilActualizareCVAAparutOEroare;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resActualizeazaCVContMedic;
    }

    return null;
  }

  Future<http.Response?> adaugaEducatieMedic(
      BuildContext context,
      String pTipEducatie,
      String pInformatiiSuplimentare,
      int numarCamp) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;
    http.Response? resAdaugaEducatieMedic =
        await apiCallFunctions.adaugaEducatieMedic(
      pUser: user,
      pParola: userPassMD5,
      pTipEducatie: pTipEducatie,
      pInformatiiSuplimentare: pInformatiiSuplimentare,
    );

    print(
        'adaugaEducatieMedic resAdaugaEducatieMedic.body ${resAdaugaEducatieMedic!.body}');

    if (int.parse(resAdaugaEducatieMedic.body) == 200) {
      if (numarCamp == 1) {
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(pref_keys.tipEducatie1, pTipEducatie);
        prefs.setString(
            pref_keys.informatiiSuplimentare1, pInformatiiSuplimentare);
        //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));
      } else if (numarCamp == 2) {
        prefs.setString(pref_keys.tipEducatie2, pTipEducatie);
        prefs.setString(
            pref_keys.informatiiSuplimentare2, pInformatiiSuplimentare);
      } else if (numarCamp == 3) {
        prefs.setString(pref_keys.tipEducatie3, pTipEducatie);
        prefs.setString(
            pref_keys.informatiiSuplimentare3, pInformatiiSuplimentare);
      } else if (numarCamp == 4) {
        prefs.setString(pref_keys.tipEducatie4, pTipEducatie);
        prefs.setString(
            pref_keys.informatiiSuplimentare4, pInformatiiSuplimentare);
      } else if (numarCamp == 5) {
        prefs.setString(pref_keys.tipEducatie5, pTipEducatie);
        prefs.setString(
            pref_keys.informatiiSuplimentare5, pInformatiiSuplimentare);
      }

      print('Adăugare educație finalizată cu succes!');

      //textMessage = 'Adăugare educație finalizată cu succes!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resAdaugaEducatieMedic.body) == 400) {
      print('Apel invalid!');

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaEducatieMedic!.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEditareEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      print('Educația nu a fost actualizată!');

      //textMessage = 'Educația nu a fost adăugată!'; //old IGV
      textMessage = l.setariProfilEducatiaNuAFostAdaugata;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaEducatieMedic!.body) == 405) {
      print('Informații insuficiente!');

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaEducatieMedic!.body) == 500) {
      print('A apărut o eroare la execuția metodei!');

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieAAparutOEroare;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resAdaugaEducatieMedic;
    }

    return null;
  }

  Future<http.Response?> actualizeazaEducatieMedic(
    BuildContext context,
    String pIdEducatie,
    String pTipEducatie,
    String pInformatiiSuplimentare,
  ) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    /*
    http.Response? res = await apiCallFunctions.getContClient(
      pUser: controllerEmail.text,
      pParola: controllerPass.text,
    );
    */

    http.Response? resActualizeazaEducatieMedic =
        await apiCallFunctions.actualizeazaEducatieMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdEducatie: pIdEducatie,
      pTipEducatie: pTipEducatie,
      pInformatiiSuplimentare: pInformatiiSuplimentare,
    );

    print(
        'actualizeazaEducatieMedic resActualizeazaEducatieMedic.body ${resActualizeazaEducatieMedic!.body}');

    if (int.parse(resActualizeazaEducatieMedic!.body) == 200) {
      print('Actualizare educație finalizată cu succes!');

      //textMessage = 'Actualizare educație finalizată cu succes!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resActualizeazaEducatieMedic.body) == 400) {
      print('Apel invalid!');

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaEducatieMedic!.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEditareEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      print('Educația nu a fost actualizată!');

      //textMessage = 'Educația nu a fost actualizată!'; //old IGV
      textMessage = l.setariProfilEducatiaNuAFostActualizata;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaEducatieMedic!.body) == 405) {
      print('Informații insuficiente!');

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaEducatieMedic!.body) == 500) {
      print('A apărut o eroare la execuția metodei!');

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieAAparutOEroare;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resActualizeazaEducatieMedic;
    }

    return null;
  }

  Future<http.Response?> stergeEducatieMedic(
      BuildContext context, String idEducatie) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resStergeEducatieMedic =
        await apiCallFunctions.stergeEducatieMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdEducatie: idEducatie,
    );

    if (int.parse(resStergeEducatieMedic!.body) == 200) {
      print('Educație ștearsă cu succes!');

      //textMessage = 'Educație ștearsă cu succes!'; //old IGV
      textMessage = l.setariProfilEducatieStearsaCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resStergeEducatieMedic.body) == 400) {
      print('Apel invalid');

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilStergereEducatieApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resStergeEducatieMedic!.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));
      print('Eroare! Educația nu a putut fi ștearsă!');

      //textMessage = 'Eroare! Educația nu a putut fi ștearsă!'; //old IGV
      textMessage = l.setariProfilEducatiaNuAPututFiStearsa;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resStergeEducatieMedic!.body) == 405) {
      print('Informații insuficiente!');

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilStergereEducatieInformatiiInsuficiente;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resStergeEducatieMedic!.body) == 500) {
      print('A apărut o eroare la execuția metodei!');

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
      textMessage = l.setariProfilStergereEducatieAAparutOEroare;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);
      return resStergeEducatieMedic;
    }
    return null;
  }
}
