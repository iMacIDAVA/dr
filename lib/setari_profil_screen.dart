import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_bebe_profil_bebe_doctor/curriculum_vitae_edit/cv_edit_page.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
import 'package:sos_bebe_profil_bebe_doctor/reset_password_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;
import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

List<EducatieMedic> listaEducatieMedic = [];
List<int> listaIndexEducatieMedic = [];

List<WidgetIndexIdEducatie> widgetsEducatie = [];

int numarEntitatiEducatie = 0;

class SetariProfilScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;

  const SetariProfilScreen({super.key, required this.contMedicMobile});

  @override
  State<SetariProfilScreen> createState() => _SetariProfilScreenState();
}

class _SetariProfilScreenState extends State<SetariProfilScreen> {
  bool isVisible = false;

  bool showCV = false;

  bool deconectareActivat = false;
  bool notificariActivat = false;

  final setariProfilKey = GlobalKey<FormState>();

  final setariProfilCvKey = GlobalKey<FormState>();

  String titluProfesional = '';
  String specializare = '';
  String experienta = '';
  String locDeMuncaNume = '';
  String locDeMuncaAdresa = '';
  ContMedicMobile? contMedicMobile;

  //List<WidgetIndexIdEducatie> widgetsEducatie = [];

  List<Function(EducatieMedic, int)> listaFunctiiCallback = [];

  @override
  void initState() {
    super.initState();

    getKey();
    contMedicMobile = widget.contMedicMobile;

    listaEducatieMedic.addAll(contMedicMobile!.listaEducatie);
    listaIndexEducatieMedic = [for (var i = 0; i < listaEducatieMedic.length; i++) i];

    listaFunctiiCallback.add(callbackEducatie1);
    listaFunctiiCallback.add(callbackEducatie2);
    listaFunctiiCallback.add(callbackEducatie3);
    listaFunctiiCallback.add(callbackEducatie4);
    listaFunctiiCallback.add(callbackEducatie5);

    showCV = false;
    widgetsEducatie = [];
    // setupInteractedMessage();
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    controllerEditareEmail.text = contMedicMobile!.email;
    controllerEditareTelefon.text = contMedicMobile!.telefon;
    controllerEditareUser.text = contMedicMobile!.numeComplet;
  }

  void callbackDeconectare(bool newDeconectareActivat) {
    setState(() {
      deconectareActivat = newDeconectareActivat;
    });
  }

  void callbackNotificari(bool newNotificariActivat) {
    //print('Aici callbackNotificari');
    setState(() {
      notificariActivat = newNotificariActivat;
    });
  }

  void callbackTitluProfesional(String newTitluProfesional) {
    //print('Aici callbackTitluProfesional');
    setState(() {
      titluProfesional = newTitluProfesional;
    });
  }

  void callbackSpecializare(String newSpecializare) {
    //print('Aici callbackSpecializare');
    setState(() {
      specializare = newSpecializare;
    });
  }

  void callbackExperienta(String newExperienta) {
    setState(() {
      experienta = newExperienta;
    });
  }

  void callbackLocDeMuncaNume(String newLocDeMuncaNume) {
    //print('Aici callbackLocDeMuncaNume');

    setState(() {
      locDeMuncaNume = newLocDeMuncaNume;
    });
  }

  void callbackLocDeMuncaAdresa(String newLocDeMuncaAdresa) {
    //print('Aici callbackLocDeMuncaAdresa');

    setState(() {
      locDeMuncaAdresa = newLocDeMuncaAdresa;
    });
  }

  void callbackEducatie1(EducatieMedic newEducatie1, int index) {
    setState(() {
      if (listaEducatieMedic.isNotEmpty) {
        int containsIndex = listaIndexEducatieMedic.indexWhere((item) {
          return (item == index);
        });

        if (containsIndex != -1) {
          //print('listaEducatieMedic containsIndex $containsIndex $index');
          listaEducatieMedic[containsIndex] = newEducatie1;
          listaIndexEducatieMedic[containsIndex] = index;
        }
      } else {
        listaEducatieMedic.add(newEducatie1);
        listaIndexEducatieMedic.add(index);
      }

      //listaEducatieMedic[0].tipEducatie = newEducatie1.tipEducatie;
      //listaEducatieMedic[0].informatiiSuplimentare = newEducatie1.informatiiSuplimentare;
    });
  }

  void callbackEducatie2(EducatieMedic newEducatie2, int index) {
    setState(() {
      if (listaEducatieMedic.isNotEmpty) {
        int containsIndex = listaIndexEducatieMedic.indexWhere((item) {
          return (item == index);
        });

        if (containsIndex != -1) {
          //print('listaEducatieMedic containsIndex $containsIndex $index');
          listaEducatieMedic[containsIndex] = newEducatie2;
          listaIndexEducatieMedic[containsIndex] = index;
        }
      } else {
        listaEducatieMedic.add(newEducatie2);
        listaIndexEducatieMedic.add(index);
      }
    });
  }

  void callbackEducatie3(EducatieMedic newEducatie3, int index) {
    setState(() {
      if (listaEducatieMedic.isNotEmpty) {
        int containsIndex = listaIndexEducatieMedic.indexWhere((item) {
          return (item == index);
        });

        if (containsIndex != -1) {
          //print('listaEducatieMedic containsIndex $containsIndex $index');
          listaEducatieMedic[containsIndex] = newEducatie3;
          listaIndexEducatieMedic[containsIndex] = index;
        }
      } else {
        listaEducatieMedic.add(newEducatie3);
        listaIndexEducatieMedic.add(index);
      }
    });
  }

  void callbackEducatie4(EducatieMedic newEducatie4, int index) {
    setState(() {
      if (listaEducatieMedic.isNotEmpty) {
        int containsIndex = listaIndexEducatieMedic.indexWhere((item) {
          return (item == index);
        });

        if (containsIndex != -1) {
          //print('listaEducatieMedic containsIndex $containsIndex $index');
          listaEducatieMedic[containsIndex] = newEducatie4;
          listaIndexEducatieMedic[containsIndex] = index;
        }
      } else {
        listaEducatieMedic.add(newEducatie4);
        listaIndexEducatieMedic.add(index);
      }
    });
  }

  void callbackEducatie5(EducatieMedic newEducatie5, int index) {
    setState(() {
      if (listaEducatieMedic.isNotEmpty) {
        int containsIndex = listaIndexEducatieMedic.indexWhere((item) {
          return (item == index);
        });

        if (containsIndex != -1) {
          //print('listaEducatieMedic containsIndex $containsIndex $index');
          listaEducatieMedic[containsIndex] = newEducatie5;
          listaIndexEducatieMedic[containsIndex] = index;
        }
      } else {
        listaEducatieMedic.add(newEducatie5);
        listaIndexEducatieMedic.add(index);
      }

      //listaEducatieMedic[4].tipEducatie = newEducatie5.tipEducatie;
      //listaEducatieMedic[4].informatiiSuplimentare = newEducatie5.informatiiSuplimentare;
    });
  }

  void callbackDeleteSubList(int indx, int idEducatie) async {
    if (idEducatie != -1) {
      await stergeEducatieMedic(idEducatie.toString());
      listaEducatieMedic.removeWhere((elem) {
        return (elem.id == idEducatie);
      });
      listaIndexEducatieMedic.removeWhere((elem) {
        return (elem == indx);
      });
    }

    setState(() {
      widgetsEducatie.removeWhere((elem) {
        return (elem.index == indx);
      });

      numarEntitatiEducatie = numarEntitatiEducatie - 1;
    });
  }

  //final controllerReseteazaParola = TextEditingController();
  final controllerEditareUser = TextEditingController();
  final controllerEditareEmail = TextEditingController();
  final controllerEditareTelefon = TextEditingController();
  //final controllerEditareCNP = TextEditingController();
  //final controllerEditareCV = TextEditingController();

  //final FocusNode focusReseteazaParola = FocusNode();
  final FocusNode focusNodeEditareUser = FocusNode();
  final FocusNode focusNodeEditareEmail = FocusNode();
  final FocusNode focusNodeEditareTelefon = FocusNode();
  //final FocusNode focusNodeEditareCNP = FocusNode();

  bool editareContCorecta = false;
  bool showButonSalvare = true;

  bool editareCVCorecta = false;

  bool stergereEducatieMedicReusita = false;

  Future<http.Response?> updateDateMedic() async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resUpdateDateMedic = await apiCallFunctions.updateDateMedic(
      pUser: user,
      pParola: userPassMD5,
      pNumeleComplet: controllerEditareUser.text,
      pTelefonNou: controllerEditareTelefon.text,
      pAdresaEmailNoua: controllerEditareEmail.text,
      //pCNPNou: controllerEditareTelefon.text, //de modificat IGV
      pCNPNou: '1820607033341',
    );

    print('updateDateMedic resUpdateDateMedic.body ${resUpdateDateMedic!.body}');

    if (int.parse(resUpdateDateMedic.body) == 200) {
      setState(() {
        editareContCorecta = true;
        showButonSalvare = false;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pref_keys.userNumeComplet,
          controllerEditareUser.text.isEmpty ? contMedicMobile!.numeComplet : controllerEditareUser.text);
      prefs.setString(pref_keys.userEmail,
          controllerEditareEmail.text.isEmpty ? contMedicMobile!.email : controllerEditareEmail.text);
      prefs.setString(pref_keys.userTelefon,
          controllerEditareTelefon.text.isEmpty ? contMedicMobile!.telefon : controllerEditareTelefon.text);
      //prefs.setString(pref_keys.user, controllerEditareUser.text.isEmpty?widget.contMedicMobile.numeComplet:controllerEditareUser.text);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      //textMessage = 'Actualizare date finalizată cu succes!';  //old IGV
      textMessage = l.setariProfilActualizareDateFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resUpdateDateMedic.body) == 400) {
      setState(() {
        editareContCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilActualizareDateApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resUpdateDateMedic.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEditareEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      setState(() {
        editareContCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Datele nu au putut fi actualizate!'; //old IGV
      textMessage = l.setariProfilDateleNuAuPututFiActualizate;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resUpdateDateMedic.body) == 405) {
      setState(() {
        editareContCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilActualizareDateInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resUpdateDateMedic.body) == 500) {
      setState(() {
        editareContCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
      textMessage = l.setariProfilAAparutOEroareLaExecutiaMetodei;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    }

    if (context.mounted) {
      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resUpdateDateMedic;
    }

    return null;
  }

  Future<http.Response?> actualizeazaCVContMedic() async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userLogin = prefs.getString('user') ?? '';
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

    http.Response? resActualizeazaCVContMedic = await apiCallFunctions.actualizeazaCVContMedic(
      pUser: userLogin,
      pParola: userPassMD5,
      pLocDeMunca: locDeMuncaNume,
      pAdresaLocDeMunca: locDeMuncaAdresa,
      pSpecializare: specializare,
      pFunctie: titluProfesional,
      pExperienta: experienta, //de modificat IGV
    );

    print('actualizeazaCVContMedic resActualizeazaCVContMedic.body ${resActualizeazaCVContMedic!.body}');

    if (int.parse(resActualizeazaCVContMedic.body) == 200) {
      setState(() {
        editareCVCorecta = true;
        showButonSalvare = false;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(pref_keys.locDeMunca, locDeMuncaNume);
      prefs.setString(pref_keys.adresaLocDeMunca, locDeMuncaAdresa);
      prefs.setString(pref_keys.specializarea, specializare);
      prefs.setString(pref_keys.titulatura, titluProfesional);
      prefs.setString(pref_keys.experienta, experienta);
      //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      //textMessage = 'Actualizare CV finalizată cu succes!';  //old IGV
      textMessage = l.setariProfilActualizareCVFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 400) {
      setState(() {
        editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilActualizareCVApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEditareEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      setState(() {
        editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'CV-ul nu a putut fi actualizat!'; //old IGV
      textMessage = l.setariProfilCVulNuAFostActualizat;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 405) {
      setState(() {
        editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilActualizareCVInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaCVContMedic.body) == 500) {
      setState(() {
        editareCVCorecta = false;
        showButonSalvare = true;
      });

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

  Future<http.Response?> adaugaEducatieMedic(String pTipEducatie, String pInformatiiSuplimentare, int numarCamp) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;
    http.Response? resAdaugaEducatieMedic = await apiCallFunctions.adaugaEducatieMedic(
      pUser: user,
      pParola: userPassMD5,
      pTipEducatie: pTipEducatie,
      pInformatiiSuplimentare: pInformatiiSuplimentare,
    );

    print('adaugaEducatieMedic resAdaugaEducatieMedic.body ${resAdaugaEducatieMedic!.body}');

    if (int.parse(resAdaugaEducatieMedic.body) == 200) {
      setState(() {
        //editareCVCorecta = true;
        showButonSalvare = false;
      });

      if (numarCamp == 1) {
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(pref_keys.tipEducatie1, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare1, pInformatiiSuplimentare);
        //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));
      } else if (numarCamp == 2) {
        prefs.setString(pref_keys.tipEducatie2, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare2, pInformatiiSuplimentare);
      } else if (numarCamp == 3) {
        prefs.setString(pref_keys.tipEducatie3, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare3, pInformatiiSuplimentare);
      } else if (numarCamp == 4) {
        prefs.setString(pref_keys.tipEducatie4, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare4, pInformatiiSuplimentare);
      } else if (numarCamp == 5) {
        prefs.setString(pref_keys.tipEducatie5, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare5, pInformatiiSuplimentare);
      }

      //textMessage = 'Adăugare educație finalizată cu succes!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resAdaugaEducatieMedic.body) == 400) {
      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaEducatieMedic.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEditareEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Educația nu a fost adăugată!'; //old IGV
      textMessage = l.setariProfilEducatiaNuAFostAdaugata;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaEducatieMedic.body) == 405) {
      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilAdaugareEducatieInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resAdaugaEducatieMedic.body) == 500) {
      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

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
      String pIdEducatie, String pTipEducatie, String pInformatiiSuplimentare, int numarCamp) async {
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

    http.Response? resActualizeazaEducatieMedic = await apiCallFunctions.actualizeazaEducatieMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdEducatie: pIdEducatie,
      pTipEducatie: pTipEducatie,
      pInformatiiSuplimentare: pInformatiiSuplimentare,
    );

    print('actualizeazaEducatieMedic resActualizeazaEducatieMedic.body ${resActualizeazaEducatieMedic!.body}');

    if (int.parse(resActualizeazaEducatieMedic.body) == 200) {
      setState(() {
        //editareCVCorecta = true;
        showButonSalvare = false;
      });

      if (numarCamp == 1) {
        //SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(pref_keys.tipEducatie1, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare1, pInformatiiSuplimentare);
        //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));
      } else if (numarCamp == 2) {
        prefs.setString(pref_keys.tipEducatie2, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare2, pInformatiiSuplimentare);
      } else if (numarCamp == 3) {
        prefs.setString(pref_keys.tipEducatie3, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare3, pInformatiiSuplimentare);
      } else if (numarCamp == 4) {
        prefs.setString(pref_keys.tipEducatie4, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare4, pInformatiiSuplimentare);
      } else if (numarCamp == 5) {
        prefs.setString(pref_keys.tipEducatie5, pTipEducatie);
        prefs.setString(pref_keys.informatiiSuplimentare5, pInformatiiSuplimentare);
      }

      //textMessage = 'Actualizare educație finalizată cu succes!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieFinalizataCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resActualizeazaEducatieMedic.body) == 400) {
      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaEducatieMedic.body) == 401) {
      //prefs.setString(pref_keys.userEmail, controllerEditareEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerResetareParola.text));

      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Educația nu a fost actualizată!'; //old IGV
      textMessage = l.setariProfilEducatiaNuAFostActualizata;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaEducatieMedic.body) == 405) {
      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilActualizareEducatieInformatiiInsuficiente;
      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resActualizeazaEducatieMedic.body) == 500) {
      setState(() {
        //editareCVCorecta = false;
        showButonSalvare = true;
      });

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

  Future<http.Response?> stergeEducatieMedic(String idEducatie) async {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;

    http.Response? resStergeEducatieMedic = await apiCallFunctions.stergeEducatieMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdEducatie: idEducatie,
    );

    if (int.parse(resStergeEducatieMedic!.body) == 200) {
      setState(() {
        stergereEducatieMedicReusita = true;
      });

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString(pref_keys.userEmail, controllerEmail.text);

      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Educație ștearsă cu succes!'; //old IGV
      textMessage = l.setariProfilEducatieStearsaCuSucces;

      backgroundColor = const Color.fromARGB(255, 14, 190, 127);
      textColor = Colors.white;
    } else if (int.parse(resStergeEducatieMedic.body) == 400) {
      setState(() {
        stergereEducatieMedicReusita = false;
      });

      //textMessage = 'Apel invalid!'; //old IGV
      textMessage = l.setariProfilStergereEducatieApelInvalid;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resStergeEducatieMedic.body) == 401) {
      setState(() {
        stergereEducatieMedicReusita = false;
      });

      //prefs.setString(pref_keys.userEmail, controllerEmail.text);
      //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

      //textMessage = 'Eroare! Educația nu a putut fi ștearsă!'; //old IGV
      textMessage = l.setariProfilEducatiaNuAPututFiStearsa;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resStergeEducatieMedic.body) == 405) {
      setState(() {
        stergereEducatieMedicReusita = false;
      });

      //textMessage = 'Informații insuficiente!'; //old IGV
      textMessage = l.setariProfilStergereEducatieInformatiiInsuficiente;

      backgroundColor = Colors.red;
      textColor = Colors.black;
    } else if (int.parse(resStergeEducatieMedic.body) == 500) {
      setState(() {
        stergereEducatieMedicReusita = false;
      });

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

  String oneSignal = '';
  void getKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oneSignal = prefs.getString("oneSignalId")!;

    setState(() {});
  }

  bool isReturningFromCV = false;
  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String user = prefs.getString('user') ?? '';
        String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
        contMedicMobile = await apiCallFunctions.getContMedic(
          pUser: user,
          pParola: userPassMD5,
          pDeviceToken: oneSignal,
          pTipDispozitiv: Platform.isAndroid ? '1' : '2',
          pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
          pTokenVoip: '',
        );
        TotaluriMedic? totaluriMedic =
            await apiCallFunctions.getTotaluriDashboardMedic(pUser: user, pParola: userPassMD5);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DashboardScreen(contMedicMobile: contMedicMobile!, totaluriMedic: totaluriMedic!);
            },
          ),
        );
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          foregroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () async {
              // if (isReturningFromCV) {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              String user = prefs.getString('user') ?? '';
              String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
              contMedicMobile = await apiCallFunctions.getContMedic(
                pUser: user,
                pParola: userPassMD5,
                pDeviceToken: oneSignal,
                pTipDispozitiv: Platform.isAndroid ? '1' : '2',
                pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
                pTokenVoip: '',
              );
              TotaluriMedic? totaluriMedic =
                  await apiCallFunctions.getTotaluriDashboardMedic(pUser: user, pParola: userPassMD5);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DashboardScreen(contMedicMobile: contMedicMobile!, totaluriMedic: totaluriMedic!);
                  },
                ),
              );
              // } else {
              //   Navigator.pop(context);
              // }
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: Text(
            //'Setări - Profilul meu', //old IGV
            l.setariProfilTitlu,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07,
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Text(
                    //"Profil", //old IGV
                    l.setariProfilTitluProfil,
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(103, 114, 148, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        if (_selectedImage.path == '')
                          ClipOval(
                            child: SizedBox(
                              height: 75,
                              width: 75,
                              child: pozaStearsa
                                  ? Image.asset(
                                      './assets/images/user_fara_poza.png',
                                      width: 75,
                                      height: 75,
                                      fit: BoxFit.cover,
                                    )
                                  : widget.contMedicMobile.linkPozaProfil.isEmpty
                                      ? Image.asset(
                                          './assets/images/user_fara_poza.png',
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          widget.contMedicMobile.linkPozaProfil,
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                        if (_selectedImage.path != "")
                          ClipOval(
                            child: SizedBox(
                              height: 75,
                              width: 75,
                              child: Image.file(_selectedImage, fit: BoxFit.cover),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _updatePhotoDialog();
                            },
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(30, 214, 158, 1),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                )),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Form(
                  key: setariProfilKey,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.04,
                      top: MediaQuery.of(context).size.height * 0.005,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.030,
                                top: MediaQuery.of(context).size.height * 0.05,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        //builder: (context) => const ServiceSelectScreen(),
                                        builder: (context) => const ResetPasswordScreen(),
                                      ));
                                },
                                child: Text(
                                    //'Resetează Parola', //old IGV
                                    l.setariProfilReseteazaParola,
                                    style: GoogleFonts.rubik(
                                      color: const Color.fromRGBO(111, 139, 164, 1),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.075,
                                top: MediaQuery.of(context).size.height * 0.05,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        //builder: (context) => const ServiceSelectScreen(),
                                        //builder: (context) => const EditareProfilScreen(),
                                        builder: (context) => const ResetPasswordScreen(),
                                      ));
                                },
                                icon: Image.asset('./assets/images/reseteaza_parola_editeaza_cv_icon.png'),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        customPaddingProfilulMeu(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            onFieldSubmitted: (String s) {
                              focusNodeEditareEmail.requestFocus();
                            },
                            focusNode: focusNodeEditareUser,
                            controller: controllerEditareUser,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  //color: Color.fromRGBO(205, 211, 223, 1),
                                  color: Colors.white,
                                ),
                              ),
                              /*enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(205, 211, 223, 1),
                                width: 1.0,
                              ),
                            ),
                            */
                              filled: true,
                              fillColor: Colors.white,
                              //hintText: "Editare User", //old IGV
                              hintText: l.setariProfilEditareUserHint,
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(111, 139, 164, 1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400), //added by George Valentin Iordache
                            ),
                            validator: (value) {
                              // String namePattern =
                              //     r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                              // RegExp nameRegExp = RegExp(namePattern);
                              // if (value!.isEmpty ||
                              //     !nameRegExp.hasMatch(value))
                              if (controllerEditareUser.text.isEmpty) {
                                //return 'Introduceți numele complet'; //old IGV
                                return l.setariProfilIntroducetiNumeleComplet;
                              } else {
                                return null;
                              }
                            }),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        customPaddingProfilulMeu(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        TextFormField(
                          onFieldSubmitted: (String s) {
                            focusNodeEditareTelefon.requestFocus();
                          },
                          focusNode: focusNodeEditareEmail,
                          controller: controllerEditareEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                //color: Color.fromRGBO(205, 211, 223, 1),
                                color: Colors.white,
                              ),
                            ),

                            /*enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(205, 211, 223, 1),
                                width: 1.0,
                              ),
                            ),
                            */
                            filled: true,
                            fillColor: Colors.white,
                            //hintText: "Editează E-mail", //old IGV
                            hintText: l.setariProfilEditeazaEmailHint,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(111, 139, 164, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400), //added by George Valentin Iordache
                          ),
                          validator: (value) {
                            String emailPattern = r'.+@.+\.+';
                            RegExp emailRegExp = RegExp(emailPattern);
                            if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
                              //return "Introduceți o adresă de Email corectă"; //old IGV
                              return l.setariProfilIntroducetiOAdresaDeEmailCorecta;
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        customPaddingProfilulMeu(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        TextFormField(
                          //onFieldSubmitted: (String s) {
                          //  focusNodeEditareCNP.requestFocus();
                          //},
                          focusNode: focusNodeEditareTelefon,
                          controller: controllerEditareTelefon,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                //color: Color.fromRGBO(205, 211, 223, 1),
                                color: Colors.white,
                              ),
                            ),

                            /*enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(205, 211, 223, 1),
                                width: 1.0,
                              ),
                            ),
                            */
                            filled: true,
                            fillColor: Colors.white,
                            //hintText: 'Editează telefon', //old IGV
                            hintText: l.setariProfilEditeazaTelefonHint,

                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(111, 139, 164, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400), //added by George Valentin Iordache
                          ),
                          validator: (value) {
                            String phonePattern = r'(^(?:[+0]4)?[0-9]{10}$)';
                            RegExp phoneRegExp = RegExp(phonePattern);
                            if (value!.isEmpty || (!(value.length != 10) && !(value.length != 12))) {
                              //return 'Introduceti un număr de telefon corect'; //old IGV
                              return l.setariProfilIntroducetiUnNumarDeTelefonCorect;
                            } else if (!phoneRegExp.hasMatch(value)) {
                              //return 'Introduceți un număr de mobil corect'; //old IGV
                              return l.setariProfilIntroducetiUnNumarDeMobilCorect;
                            }
                            return null;
                            /*
                            if (value!.isEmpty || !(value.length != 10))
                            {
                              return "Introduceti un numar de telefon corect";
                            }
                            else
                            {
                              return null;
                            }
                            */
                          },
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        customPaddingProfilulMeu(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 40, 10),
                          child: GestureDetector(
                            onTap: () async {
                              isReturningFromCV = await Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CVEditPage(contMedicMobile: contMedicMobile!);
                                },
                              ));
                              setState(() {});
                              if (isReturningFromCV) {
                                SharedPreferences prefs = await SharedPreferences.getInstance();

                                String user = prefs.getString('user') ?? '';
                                String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
                                contMedicMobile = await apiCallFunctions.getContMedic(
                                  pUser: user,
                                  pParola: userPassMD5,
                                  pDeviceToken: oneSignal,
                                  pTipDispozitiv: Platform.isAndroid ? '1' : '2',
                                  pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
                                  pTokenVoip: '',
                                );
                                setState(() {});
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.030,
                                    top: MediaQuery.of(context).size.height * 0.001,
                                  ),
                                  child: Text(
                                      //'Editează CV', //old IGV
                                      l.setariProfilEditeazaCV,
                                      style: GoogleFonts.rubik(
                                        color: const Color.fromRGBO(111, 139, 164, 1),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      )),
                                ),
                                Image.asset('./assets/images/reseteaza_parola_editeaza_cv_icon.png'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final isValidMainForm = setariProfilKey.currentState!.validate();

                    if (isValidMainForm) {
                      await updateDateMedic();

                      if (editareContCorecta) {
                        showSnackbar(context, "Profile updated successfully", Colors.green, Colors.white);
                      } else {
                        showSnackbar(context, "Failed to update profile", Colors.red, Colors.white);
                      }
                    } else {
                      showSnackbar(context, "Please fill all required fields", Colors.red, Colors.white);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Container(
                      // margin:
                      //     const EdgeInsets.only(left: 25, right: 25, top: 50),

                      width: MediaQuery.of(context).size.width,
                      height: 36,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(30, 214, 158, 1), borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          //'Salvează', //old IGV
                          l.setariProfilSalveaza,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                !showCV
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.383,
                        color: Colors.white,
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        color: Colors.white,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File _selectedImage = File('');
  bool pozaStearsa = false;

  Future<void> _takePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Uint8List? selectedImageBytes;

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        pozaStearsa = false;
        selectedImageBytes = Uint8List.fromList(bytes);
        _selectedImage = File(photo.path);
        apiCallFunctions.uploadPicture(
            pExtensie: '.jpg', pUser: user, pParola: userPassMD5, pSirBitiDocument: selectedImageBytes.toString());
      });
    }
  }

  Future<void> _chooseFromGallery() async {
    Uint8List? selectedImageBytes;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() {
        pozaStearsa = false;
        selectedImageBytes = Uint8List.fromList(bytes);
        _selectedImage = File(photo.path);
        apiCallFunctions.uploadPicture(
            pExtensie: 'jpg', pUser: user, pParola: userPassMD5, pSirBitiDocument: selectedImageBytes.toString());
      });
    }
  }

  _updatePhotoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Schimba poza de profil"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galerie'),
                  onTap: () {
                    Navigator.pop(context);
                    _chooseFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Sterge poza curenta'),
                  onTap: () async {
                    pozaStearsa = true;
                    _selectedImage = File("");
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    String user = prefs.getString('user') ?? '';
                    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
                    Navigator.pop(context);
                    apiCallFunctions.deletePicture(pUser: user, pParola: userPassMD5);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//ignore: must_be_immutable
class SetariProfilCVScreen extends StatefulWidget {
  final ContMedicMobile contMedicMobile;

  final GlobalKey<FormState> setariProfilCvKey;

  final Function(String)? callbackTitluProfesional;

  final Function(String)? callbackSpecializare;

  final Function(String)? callbackExperienta;

  final Function(String)? callbackLocDeMuncaNume;

  final Function(String)? callbackLocDeMuncaAdresa;

  /*
  final Function(List<WidgetIndexIdEducatie>) callbackListaWidgetsEducatie1;

  final Function(List<WidgetIndexIdEducatie>) callbackListaWidgetsEducatie2;

  final Function(List<WidgetIndexIdEducatie>) callbackListaWidgetsEducatie3;

  final Function(List<WidgetIndexIdEducatie>) callbackListaWidgetsEducatie4;

  final Function(List<WidgetIndexIdEducatie>) callbackListaWidgetsEducatie5;
  */

  final Function(int, int) callbackDeleteSubList;
  //(List<WidgetIndexIdEducatie> newWidgetsEducatie )

  List<Function(EducatieMedic, int)>? listaFunctiiCallback;

  //final Function(List<WidgetIndexIdEducatie>)? callbackListaWidgets;

  //final Function(GlobalKey<FormState>) callbackSetariKey;

  //const SetariProfilCVScreen({super.key, required this.setariProfilCvKey, required this.callbackSetariKey});
  SetariProfilCVScreen({
    super.key,
    required this.contMedicMobile,
    required this.setariProfilCvKey,
    this.callbackTitluProfesional,
    this.callbackSpecializare,
    required this.callbackExperienta,
    required this.callbackLocDeMuncaNume,
    required this.callbackLocDeMuncaAdresa,
    this.listaFunctiiCallback,
    /*required this.callbackListaWidgetsEducatie1, required this.callbackListaWidgetsEducatie2, required this.callbackListaWidgetsEducatie3,
     required this.callbackListaWidgetsEducatie4, required this.callbackListaWidgetsEducatie5,
     */
    required this.callbackDeleteSubList,
    //required this.widgetsEducatie,
    //this.callbackListaWidgets,
  });

  @override
  State<SetariProfilCVScreen> createState() => _SetariProfilCVScreenState();
}

class _SetariProfilCVScreenState extends State<SetariProfilCVScreen> {
  final controllerTitluProfesional = TextEditingController();
  final controllerSpecializare = TextEditingController();
  final controllerExperienta = TextEditingController();
  final controllerLocDeMuncaNume = TextEditingController();
  final controllerLocDeMuncaAdresa = TextEditingController();

  final FocusNode focusNodeTitluProfesional = FocusNode();
  final FocusNode focusNodeSpecializare = FocusNode();
  final FocusNode focusNodeExperienta = FocusNode();
  final FocusNode focusNodeLocDeMuncaNume = FocusNode();
  final FocusNode focusNodeLocDeMuncaAdresa = FocusNode();

  final setariProfilCvKey = GlobalKey<FormState>();

  bool showCV = false;

  String oneSignal = '';
  void getKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    oneSignal = prefs.getString("oneSignalId")!;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getKey();

    setState(() {
      if (widget.listaFunctiiCallback != null) {
        numarEntitatiEducatie = listaEducatieMedic.isEmpty ? 0 : listaEducatieMedic.length;
      }
    });
    // setupInteractedMessage();
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    //int lungimeListaEducatie = widget.contMedicMobile.listaEducatie.length; //old IGV

    if (listaEducatieMedic.isNotEmpty) {
      int lungimeListaEducatie = listaEducatieMedic.length;

      for (int index = 0; index < lungimeListaEducatie; index++)
      //if (index < listaFiltrata.length-1)
      {
        if (listaEducatieMedic[index].id != -1) {
          bool containsElem = widgetsEducatie.any((item) {
            return (item.idEducatie == listaEducatieMedic[index].id);
          });
          for (int i = 0; i < 5; i++) {
            bool containsIndex = widgetsEducatie.any((item) {
              return (item.index == i);
            });

            if (!containsIndex && !containsElem) {
              widgetsEducatie.add(
                WidgetIndexIdEducatie(
                  index: i,
                  idEducatie: listaEducatieMedic[index].id,
                  contMedicMobile: widget.contMedicMobile,
                  widget: TextFormFieldTipEducatieInformatiiSuplimentare(
                    index: i,
                    contMedicMobile: widget.contMedicMobile,
                    callbackDeleteSubList: widget.callbackDeleteSubList,
                    listaFunctiiCallback: widget.listaFunctiiCallback,
                    hintTextTipEducatie: listaEducatieMedic[index].tipEducatie,
                    hintInformatiiSuplimentare: listaEducatieMedic[index].informatiiSuplimentare,
                    idEducatie: listaEducatieMedic[index].id,
                    iconButtonSterge: IconButtonSterge(
                      index: i,
                      idEducatie: listaEducatieMedic[index].id,
                      callbackDeleteSubList: widget.callbackDeleteSubList,
                    ),
                  ),
                ),
              );

              break;
            }
          }
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.0005),
        Form(
          key: widget.setariProfilCvKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  top: MediaQuery.of(context).size.height * 0.005,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    TextFormField(
                        onFieldSubmitted: (String s) {
                          widget.callbackTitluProfesional!(controllerTitluProfesional.text);
                          focusNodeSpecializare.requestFocus();
                        },
                        onChanged: (String newValue) {
                          controllerTitluProfesional.text = newValue;
                          widget.callbackTitluProfesional!(controllerTitluProfesional.text);
                        },
                        focusNode: focusNodeTitluProfesional,
                        controller: controllerTitluProfesional,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              //color: Color.fromRGBO(205, 211, 223, 1),
                              color: Colors.white,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          //hintText: 'Titlu profesional', //old IGV
                          hintText: widget.contMedicMobile.titulatura.isEmpty
                              ? l.setariProfilTitluProfestionalHint
                              : widget.contMedicMobile.titulatura,
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(111, 139, 164, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w400), //added by George Valentin Iordache
                        ),
                        validator: (value) {
                          //String namePattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                          //RegExp nameRegExp = RegExp(namePattern);
                          if (value!.isEmpty) {
                            //return 'Introduceți un titlu profesional';
                            return l.setariProfilIntroducetiUnTitluProfesional;
                          } else {
                            return null;
                          }
                        }),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    customPaddingProfilulMeu(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    TextFormField(
                      onFieldSubmitted: (String s) {
                        widget.callbackSpecializare!(controllerSpecializare.text);
                        focusNodeExperienta.requestFocus();
                      },
                      onChanged: (String newValue) {
                        controllerSpecializare.text = newValue;
                        widget.callbackSpecializare!(controllerSpecializare.text);
                      },
                      focusNode: focusNodeSpecializare,
                      controller: controllerSpecializare,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            //color: Color.fromRGBO(205, 211, 223, 1),
                            color: Colors.white,
                          ),
                        ),

                        /*
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(205, 211, 223, 1),
                            width: 1.0,
                          ),
                        ),
                        */
                        filled: true,
                        fillColor: Colors.white,
                        //hintText: "Specializare",

                        hintText: widget.contMedicMobile.specializarea.isEmpty
                            ? l.setariProfilSpecializareHint
                            : widget.contMedicMobile.specializarea,
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(111, 139, 164, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400), //added by George Valentin Iordache
                      ),
                      validator: (value) {
                        //String emailPattern = r'.+@.+\.+';
                        //RegExp emailRegExp = RegExp(emailPattern);
                        //if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
                        if (value!.isEmpty) {
                          //return 'Introduceți o specializare'; //old IGV
                          return l.setariProfilIntroducetiOSpecializare;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    customPaddingProfilulMeu(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    TextFormField(
                      onFieldSubmitted: (String s) {
                        widget.callbackExperienta!(controllerExperienta.text);
                        focusNodeLocDeMuncaNume.requestFocus();
                      },
                      onChanged: (String newValue) {
                        controllerExperienta.text = newValue;
                        widget.callbackExperienta!(controllerExperienta.text);
                      },
                      focusNode: focusNodeExperienta,
                      controller: controllerExperienta,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            //color: Color.fromRGBO(205, 211, 223, 1),
                            color: Colors.white,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        //hintText: 'Experiență', //old IGV
                        hintText: widget.contMedicMobile.experienta.isEmpty
                            ? l.setariProfilExperientaHint
                            : widget.contMedicMobile.experienta,
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(111, 139, 164, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400), //added by George Valentin Iordache
                      ),
                      validator: (value) {
                        //String emailPattern = r'.+@.+\.+';
                        //RegExp emailRegExp = RegExp(emailPattern);
                        //if (value!.isEmpty || !emailRegExp.hasMatch(value)) {
                        if (value!.isEmpty) {
                          //return 'Introduceți experiența';
                          return l.setariProfilIntroducetiExperienta;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    customPaddingProfilulMeu(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset('./assets/images/nume_loc_de_munca_icon.png')),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                              onFieldSubmitted: (String s) {
                                widget.callbackLocDeMuncaNume!(controllerLocDeMuncaNume.text);
                                focusNodeLocDeMuncaAdresa.requestFocus();
                              },
                              onChanged: (String newValue) {
                                controllerLocDeMuncaNume.text = newValue;
                                widget.callbackLocDeMuncaNume!(controllerLocDeMuncaNume.text);
                              },
                              focusNode: focusNodeLocDeMuncaNume,
                              controller: controllerLocDeMuncaNume,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    //color: Color.fromRGBO(205, 211, 223, 1),
                                    color: Colors.white,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                //hintText: 'Denumire loc de muncă', //old IGV
                                hintText: widget.contMedicMobile.locDeMunca.isEmpty
                                    ? l.setariProfilDenumireLocDeMuncaHint
                                    : widget.contMedicMobile.locDeMunca,
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(111, 139, 164, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400), //added by George Valentin Iordache
                              ),
                              validator: (value) {
                                //String namePattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                                //RegExp nameRegExp = RegExp(namePattern);
                                if (value!.isEmpty) {
                                  //return 'Introduceți o denumire de loc de muncă'; //old IGV
                                  return l.setariProfilIntroducetiODenumireDeLocDeMunca;
                                } else {
                                  return null;
                                }
                              }),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    customPaddingProfilulMeu(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset('./assets/images/locatie_loc_de_munca_icon.png')),
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                              onFieldSubmitted: (String s) {
                                widget.callbackLocDeMuncaAdresa!(controllerLocDeMuncaAdresa.text);
                                //if (widget.contMedicMobile.listaEducatie.isNotEmpty)
                                //{
                                //  focusNodeTipEducatie1.requestFocus();
                                //}
                              },
                              onChanged: (String newValue) {
                                controllerLocDeMuncaAdresa.text = newValue;
                                widget.callbackLocDeMuncaAdresa!(controllerLocDeMuncaAdresa.text);
                              },
                              focusNode: focusNodeLocDeMuncaAdresa,
                              controller: controllerLocDeMuncaAdresa,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    //color: Color.fromRGBO(205, 211, 223, 1),
                                    color: Colors.white,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                //hintText: "Adresă loc de muncă", //old IGV
                                hintText: widget.contMedicMobile.adresaLocDeMunca.isEmpty
                                    ? l.setariProfilAdresaLocDeMuncaHint
                                    : widget.contMedicMobile.adresaLocDeMunca,
                                hintStyle: const TextStyle(
                                    color: Color.fromRGBO(111, 139, 164, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400), //added by George Valentin Iordache
                              ),
                              validator: (value) {
                                //String namePattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                                //RegExp nameRegExp = RegExp(namePattern);
                                if (value!.isEmpty) {
                                  //return 'Introduceți o adresă de loc de muncă'; //old IGV
                                  return l.setariProfilIntroducetiOAdresaDeLocDeMunca;
                                } else {
                                  return null;
                                }
                              }),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.030,
                            top: MediaQuery.of(context).size.height * 0.001,
                          ),
                          child: Text(
                              //'Adaugă tip educație', //old IGV
                              l.setariProfilAdaugaTipEducatie,
                              style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(111, 139, 164, 1),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.075,
                            top: MediaQuery.of(context).size.height * 0.001,
                          ),
                          child: IconButton(
                            onPressed: () async {
                              //int index = 0;

                              setState(() {
                                numarEntitatiEducatie = numarEntitatiEducatie + 1;

                                //index = numarEntitatiEducatie-1;
                              });

                              if (numarEntitatiEducatie < 6) {
                                int i = 0;
                                bool containsIndex = true;
                                for (i = 0; i < 5; i++) {
                                  containsIndex = widgetsEducatie.any((item) {
                                    return (item.index == i);
                                  });
                                  if (!containsIndex) {
                                    widgetsEducatie.add(
                                      WidgetIndexIdEducatie(
                                        index: i,
                                        idEducatie: -1,
                                        listaFunctiiCallback: widget.listaFunctiiCallback,
                                        widget: TextFormFieldTipEducatieInformatiiSuplimentare(
                                          index: i,
                                          contMedicMobile: widget.contMedicMobile,
                                          callbackDeleteSubList: widget.callbackDeleteSubList,
                                          hintTextTipEducatie: '',
                                          hintInformatiiSuplimentare: '',
                                          listaFunctiiCallback: widget.listaFunctiiCallback,
                                          idEducatie: -1,
                                          iconButtonSterge: IconButtonSterge(
                                            index: i,
                                            idEducatie: -1,
                                            callbackDeleteSubList: widget.callbackDeleteSubList,
                                          ),
                                        ),
                                      ),
                                    );
                                    listaEducatieMedic
                                        .add(EducatieMedic(id: -1, tipEducatie: '', informatiiSuplimentare: ''));
                                    listaIndexEducatieMedic.add(i);

                                    break;
                                  }
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color.fromRGBO(30, 214, 158, 1),
                              size: 40.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ///////
                    /*
                    SingleChildScrollView(
                      child: Column(
                        children:
                          widgetsEducatie,
                      ),
                    ),
                    */
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          //const SizedBox(),

                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widgetsEducatie.isNotEmpty ? widgetsEducatie.length : 0,
                              itemBuilder: (context, index) {
                                return widgetsEducatie[index];
                              }),
                        ],
                      ),
                    ),
                    /*
                    SingleChildScrollView(
                      child: Column(
                        children:
                        [
                          Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widgetsEducatie.length,
                                itemBuilder: (context, index) {
                                  return widgetsEducatie[index];
                              }),
                            ),
                        ]
                      )
                    ),
                    */
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//ignore: must_be_immutable
class IconButtonSterge extends StatefulWidget {
  int index;
  final int idEducatie;
  //final Function(List<WidgetIndexIdEducatie>)? callbackListaWidgetsEducatie;
  //final Function(bool)? callbackShowWidget;

  //final ContMedicMobile contMedicMobile;

  final Function(int, int) callbackDeleteSubList;
  //List<WidgetIndexIdEducatie>? widgetsEducatie;

  IconButtonSterge({
    super.key,
    required this.index,
    required this.idEducatie,
    required this.callbackDeleteSubList,
    //this.widgetsEducatie,
    //required this.contMedicMobile,
    //this.callbackListaWidgetsEducatie, this.callbackShowWidget,
  });

  @override
  State<IconButtonSterge> createState() => _IconButtonStergeState();
}

//ignore: must_be_immutable
class _IconButtonStergeState extends State<IconButtonSterge> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.075,
        top: MediaQuery.of(context).size.height * 0.001,
      ),
      child: IconButton(
        onPressed: () async {
          //int indx = widget.index;

          setState(() {
            //widgetsEducatie.removeWhere((element) => (element.index == indx));
            //widgetsEducatieDeSters = widgetsEducatie.where( (element) => (element.index == indx)).toList();
            widget.callbackDeleteSubList(widget.index, widget.idEducatie);
          });

          //Navigator.pop(context);

          /*
          Navigator.push(
              context,
              MaterialPageRoute(
                //builder: (context) => const ServiceSelectScreen(),
                //builder: (context) => const EditareProfilScreen(),
                builder: (context) => SetariProfilScreen(contMedicMobile: widget.contMedicMobile,),
            ));
          */
        },
        icon: const Icon(
          Icons.delete,
          color: Color.fromRGBO(255, 0, 0, 1),
          size: 30.0,
        ),
      ),
    );
  }
}

/*
//ignore: must_be_immutable
class SizedBoxWidgetIndex extends StatefulWidget {

  const SizedBoxWidgetIndex({super.key});

  @override
  State<SizedBoxWidgetIndex> createState() => _SizedBoxWidgetIndexState();

}

class _SizedBoxWidgetIndexState extends State<SizedBoxWidgetIndex> {

  @override
  Widget build(BuildContext context) {
    print('SizedBoxWidgetIndex');
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }
}

class CustomPaddingProfilulMeuIndex extends StatefulWidget {

  const CustomPaddingProfilulMeuIndex({super.key,});

  @override
  State<CustomPaddingProfilulMeuIndex> createState() => _CustomPaddingProfilulMeuIndexState();

}

class _CustomPaddingProfilulMeuIndexState extends State<CustomPaddingProfilulMeuIndex> {

  @override
  Widget build(BuildContext context) {

    print('CustomPaddingProfilulMeuIndex');
    return customPaddingProfilulMeu();

  }

}
*/

//ignore: must_be_immutable
class TextFormFieldTipEducatieInformatiiSuplimentare extends StatefulWidget {
  int index;
  final int idEducatie;
  final ContMedicMobile contMedicMobile;

  //final FocusNode focusNodeCurent;
  //final FocusNode focusNodeNext;
  String? hintTextTipEducatie;
  String? hintInformatiiSuplimentare;

  IconButtonSterge iconButtonSterge;

  List<Function(EducatieMedic, int)>? listaFunctiiCallback;
  final Function(List<WidgetIndexIdEducatie>)? callbackListaWidgets;

  final Function(int, int) callbackDeleteSubList;
  //List<WidgetIndexIdEducatie>? widgetsEducatie;

  TextFormFieldTipEducatieInformatiiSuplimentare({
    super.key,
    required this.index,
    required this.contMedicMobile,
    required this.idEducatie,
    this.hintTextTipEducatie,
    this.hintInformatiiSuplimentare,
    this.listaFunctiiCallback,
    this.callbackListaWidgets,
    required this.callbackDeleteSubList,
    required this.iconButtonSterge,
    //this.widgetsEducatie
  });

  @override
  State<TextFormFieldTipEducatieInformatiiSuplimentare> createState() =>
      _TextFormFieldTipEducatieInformatiiSuplimentareState();
}

class _TextFormFieldTipEducatieInformatiiSuplimentareState
    extends State<TextFormFieldTipEducatieInformatiiSuplimentare> {
  TextEditingController textTipEducatieEditingController = TextEditingController();
  TextEditingController textInformatiiSuplimentareEditingController = TextEditingController();

  FocusNode focusNodeTipEducatie = FocusNode();
  FocusNode focusNodeInformatiiSuplimentare = FocusNode();

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return widgetsEducatie.isNotEmpty
        ? Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              customPaddingProfilulMeu(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          onFieldSubmitted: (String s) {
                            /*
                    widget.listaFunctiiCallback![widget.index](
                      EducatieMedic(id: widget.idEducatie,
                        tipEducatie: textTipEducatieEditingController.text.isNotEmpty?textTipEducatieEditingController.text:
                          widget.idEducatie!=-1?widget.contMedicMobile.listaEducatie[widget.idEducatie].tipEducatie:'',
                        informatiiSuplimentare: textInformatiiSuplimentareEditingController.text.isNotEmpty?
                          textInformatiiSuplimentareEditingController.text:widget.idEducatie!=-1?widget.contMedicMobile.listaEducatie[widget.idEducatie].informatiiSuplimentare:'',
                          //widget.contMedicMobile.listaEducatie[widget.index].informatiiSuplimentare
                      ),
                      widget.index,
                    );
                    */
                            focusNodeInformatiiSuplimentare.requestFocus();
                          },
                          onChanged: (String newValue) {
                            textTipEducatieEditingController.text = newValue;
                            //print('widget.index : ${widget.index} widget.idEducatie ${widget.idEducatie}, widget.listaFunctiiCallback: ${widget.listaFunctiiCallback![widget.index]}');
                            //print('tipEducatie: ${textTipEducatieEditingController.text.isNotEmpty?textTipEducatieEditingController.text:
                            //      (widget.idEducatie != -1)?widget.contMedicMobile.listaEducatie[widget.idEducatie].tipEducatie:''}');
                            //print('informatiiSuplimentare: ${textInformatiiSuplimentareEditingController.text.isNotEmpty?
                            //      textInformatiiSuplimentareEditingController.text:(widget.idEducatie!=-1)?widget.contMedicMobile.listaEducatie[widget.idEducatie].informatiiSuplimentare:''}');
                            widget.listaFunctiiCallback![widget.index](
                              EducatieMedic(
                                id: widget.idEducatie,
                                tipEducatie: textTipEducatieEditingController.text.isNotEmpty
                                    ? textTipEducatieEditingController.text
                                    : (widget.idEducatie != -1)
                                        ? widget.contMedicMobile.listaEducatie[widget.idEducatie].tipEducatie
                                        : '',
                                informatiiSuplimentare: textInformatiiSuplimentareEditingController.text.isNotEmpty
                                    ? textInformatiiSuplimentareEditingController.text
                                    : (widget.idEducatie != -1)
                                        ? widget.contMedicMobile.listaEducatie[widget.idEducatie].informatiiSuplimentare
                                        : '',
                                //widget.contMedicMobile.listaEducatie[widget.index].informatiiSuplimentare
                              ),
                              widget.index,
                            );
                          },
                          focusNode: focusNodeTipEducatie,
                          controller: textTipEducatieEditingController,
                          //keyboardType: TextInputType.none,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                //color: Color.fromRGBO(205, 211, 223, 1),
                                color: Colors.white,
                              ),
                            ),
                            fillColor: Colors.white,
                            //hintText: "Tip educație", //old IGV
                            hintText: (widget.hintTextTipEducatie ?? '').isEmpty
                                ? l.setariProfilTipEducatieHint
                                : widget.hintTextTipEducatie,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(111, 139, 164, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w400), //added by George Valentin Iordache
                          ),
                          validator: (value) {
                            //String namePattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                            //RegExp nameRegExp = RegExp(namePattern);
                            if (value!.isEmpty) {
                              //return 'Introduceți tip educație'; //old IGV
                              return l.setariProfilIntroducetiTipEducatie;
                            } else {
                              return null;
                            }
                          }),
                    ),
                    widget.iconButtonSterge,
                    /*
              IconButtonSterge(index: widget.index, idEducatie: widget.idEducatie, callbackListaWidgetsEducatie: widget.callbackListaWidgets,
                contMedicMobile:widget.contMedicMobile, callbackDeleteSubList: widget.callbackDeleteSubList,
                //widgetsEducatie: widget.widgetsEducatie,
              ),
              */
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              customPaddingProfilulMeu(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.07,
                child: TextFormField(
                    onFieldSubmitted: (String s) {
                      widget.listaFunctiiCallback![widget.index](
                        EducatieMedic(
                          id: widget.idEducatie,
                          tipEducatie: textTipEducatieEditingController.text.isNotEmpty
                              ? textTipEducatieEditingController.text
                              : (widget.idEducatie != -1)
                                  ? widget.contMedicMobile.listaEducatie[widget.idEducatie].tipEducatie
                                  : '',
                          informatiiSuplimentare: textInformatiiSuplimentareEditingController.text.isNotEmpty
                              ? textInformatiiSuplimentareEditingController.text
                              : (widget.idEducatie != -1)
                                  ? widget.contMedicMobile.listaEducatie[widget.idEducatie].informatiiSuplimentare
                                  : '',
                          /*tipEducatie: widget.contMedicMobile.listaEducatie[widget.index].tipEducatie,
                  informatiiSuplimentare: widget.textInformatiiSuplimentareEditingController.text.isNotEmpty?widget.textInformatiiSuplimentareEditingController.text:widget.contMedicMobile.listaEducatie[widget.index].informatiiSuplimentare
                  */
                        ),
                        widget.index,
                      );
                      focusNodeTipEducatie.requestFocus();
                    },
                    onChanged: (String newValue) {
                      textInformatiiSuplimentareEditingController.text = newValue;
                      widget.listaFunctiiCallback![widget.index](
                        EducatieMedic(
                          id: widget.idEducatie,
                          tipEducatie: textTipEducatieEditingController.text.isNotEmpty
                              ? textTipEducatieEditingController.text
                              : widget.idEducatie != -1
                                  ? widget.contMedicMobile.listaEducatie[widget.idEducatie].tipEducatie
                                  : '',
                          informatiiSuplimentare: textInformatiiSuplimentareEditingController.text.isNotEmpty
                              ? textInformatiiSuplimentareEditingController.text
                              : widget.idEducatie != -1
                                  ? widget.contMedicMobile.listaEducatie[widget.idEducatie].informatiiSuplimentare
                                  : '',
                          //widget.contMedicMobile.listaEducatie[widget.index].informatiiSuplimentare
                        ),
                        widget.index,
                      );
                    },
                    focusNode: focusNodeInformatiiSuplimentare,
                    controller: textInformatiiSuplimentareEditingController,
                    //keyboardType: TextInputType.none,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          //color: Color.fromRGBO(205, 211, 223, 1),
                          color: Colors.white,
                        ),
                      ),
                      fillColor: Colors.white,
                      //hintText: "Informații educație", //old IGV
                      hintText: (widget.hintInformatiiSuplimentare ?? '').isEmpty
                          ? l.setariProfilInformatiiEducatieHint
                          : widget.hintInformatiiSuplimentare,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(111, 139, 164, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w400), //added by George Valentin Iordache
                    ),
                    validator: (value) {
                      //String namePattern = r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                      //RegExp nameRegExp = RegExp(namePattern);
                      if (value!.isEmpty) {
                        //return 'Introduceți informații educație'; //old IGV
                        return l.setariProfilIntroducetiInformatiiEducatie;
                      } else {
                        return null;
                      }
                    }),
              ),
            ],
          )
        : const SizedBox();
  }
}

//ignore: must_be_immutable
class WidgetIndexIdEducatie extends StatefulWidget {
  int index;
  //int numarElementeEducatie;
  final int idEducatie;
  final Widget widget;
  final Function(List<WidgetIndexIdEducatie>)? callbackListaWidgets;

  ContMedicMobile? contMedicMobile;

  //TextEditingController? textTipEducatieEditingController;
  //FocusNode? focusNodeCurent;
  //FocusNode? focusNodeNext;
  String? hintText;

  List<Function(EducatieMedic, int)>? listaFunctiiCallback;
  //List<WidgetIndexIdEducatie>? widgetsEducatie;

  WidgetIndexIdEducatie({
    super.key,
    required this.index,
    required this.idEducatie,
    required this.widget,
    this.callbackListaWidgets,
    this.contMedicMobile,
    this.hintText,
    this.listaFunctiiCallback,
    //this.textTipEducatieEditingController, this.focusNodeCurent, this.focusNodeNext,
    //required this.numarElementeEducatie,
    //this.widgetsEducatie
  });

  @override
  State<WidgetIndexIdEducatie> createState() => _WidgetIndexIdEducatieState();
}

class _WidgetIndexIdEducatieState extends State<WidgetIndexIdEducatie> {
  @override
  void initState() {
    super.initState();

/*
    setState(() {

      showWidgetValue = widget.showWidget!;

    });
*/
    // setupInteractedMessage();
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  Widget build(BuildContext context) {
    //return showWidgetValue? widget.widget: const SizedBox();
    return widget.widget;
  }
}
