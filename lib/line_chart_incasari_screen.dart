//import 'package:fl_chart_app/presentation/resources/app_resources.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import 'package:sos_bebe_profil_bebe_doctor/initializare_incasari.dart';

import 'package:sos_bebe_profil_bebe_doctor/sume_incasari_filtrat_screen.dart';

import 'package:sos_bebe_profil_bebe_doctor/range_picker_incasari_filtrat_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class LineChartLuna extends StatefulWidget {
  final List<TotaluriMedic> listaInitialaTotaluriMedicZi;

  const LineChartLuna({super.key, required this.listaInitialaTotaluriMedicZi});

  @override
  State<LineChartLuna> createState() => _LineChartLunaState();
}

class _LineChartLunaState extends State<LineChartLuna> {
/*
  List<Color> gradientColors = [
    //AppColors.contentColorCyan,
    const Color.fromRGBO(30, 214, 158, 1),
    //AppColors.contentColorBlue,
    const Color.fromRGBO(255, 255, 255, 1),
  ];
*/
/*void callback(bool newshowRangePicker) {
    setState(() {
      showRangePicker = newshowRangePicker;
    });
  }
  */

  bool showZi = false;

  bool showSaptamana = false;

  bool showLuna = true;

  bool showAn = false;

  bool showRangePicker = false;

  bool showDeIncasat = false;

  double touchedValueZiDeIncasat = -1;

  double touchedValueSaptamanaDeIncasat = -1;

  double touchedValueLunaDeIncasat = -1;

  double touchedValueAnDeIncasat = -1;

  double touchedValuePerioadaDeIncasat = -1;

  double touchedValueZiSoldCurent = -1;

  double touchedValueSaptamanaSoldCurent = -1;

  double touchedValueLunaSoldCurent = -1;

  double touchedValueAnSoldCurent = -1;

  double touchedValuePerioadaSoldCurent = -1;

  int touchedMonedaZi = 1;

  int touchedMonedaSaptamana = -1;

  int touchedMonedaLuna = -1;

  int touchedMonedaAn = -1;

  int touchedMonedaPerioada = -1;

  //List<PunctItem> listaPuncteRangePicker = [];

  List<FlSpot> listaPuncte = [];

  List<TotaluriMedic>? listaTotaluriMedicZi = [];

  List<FlSpot> listaTotalIncasariPuncteZi = [];

  List<FlSpot> listaTotalDeIncasatPuncteZi = [];

  double maxListaTotalIncasariTotaluriMedicZi = 0.0;

  double maxListaTotalDeIncasatTotaluriMedicZi = 0.0;

  List<TotaluriMedic>? listaTotaluriMedicSaptamana = [];

  List<FlSpot> listaTotalIncasariPuncteSaptamana = [];

  List<FlSpot> listaTotalDeIncasatPuncteSaptamana = [];

  double maxListaTotalIncasariTotaluriMedicSaptamana = 0.0;

  double maxListaTotalDeIncasatTotaluriMedicSaptamana = 0.0;

  List<TotaluriMedic>? listaTotaluriMedicLuna = [];

  List<FlSpot> listaTotalIncasariPuncteLuna = [];

  List<FlSpot> listaTotalDeIncasatPuncteLuna = [];

  double maxListaTotalIncasariTotaluriMedicLuna = 0.0;

  double maxListaTotalDeIncasatTotaluriMedicLuna = 0.0;

  List<TotaluriMedic>? listaTotaluriMedicAn = [];

  List<FlSpot> listaTotalIncasariPuncteAn = [];

  List<FlSpot> listaTotalDeIncasatPuncteAn = [];

  double maxListaTotalIncasariTotaluriMedicAn = 0.0;

  double maxListaTotalDeIncasatTotaluriMedicAn = 0.0;

  List<TotaluriMedic>? listaTotaluriMedicPerioada = [];

  double newMaxListaTotalIncasariTotaluriMedicPerioadaRangePicker = 0.0;

  List<FlSpot> listaTotalIncasariPunctePerioada = [];

  List<FlSpot> listaTotalDeIncasatPunctePerioada = [];

  double maxListaTotalIncasariTotaluriMedicPerioada = 0.0;

  double maxListaTotalDeIncasatTotaluriMedicPerioada = 0.0;

  TotaluriMedic? totaluriDashboardMedic;

  int lungimeListaPerioada = 0;

  LineChart? dateTip;

  InitializareIncasariWidget initList = InitializareIncasariWidget();

  DatePeriod selectedPeriod = DatePeriod(
      DateTime.now().subtract(const Duration(days: 0)),
      DateTime.now().subtract(const Duration(days: 0)));

  void callbackShowDeIncasat(bool newShowDeIncasat) {
    setState(() {
      showDeIncasat = newShowDeIncasat;
    });
  }

  @override
  initState() {
    super.initState();
    //listaPuncteRangePicker = initList.initList();
    setState(() {
      listaTotaluriMedicZi = widget.listaInitialaTotaluriMedicZi;

      double totalIncasariInitial = 0.0;
      double totalDeIncasatInitial = 0.0;

      touchedValueZiDeIncasat = listaTotaluriMedicZi![0].totalDeIncasat;
      touchedValueZiSoldCurent = listaTotaluriMedicZi![0].totalIncasari;

      for (int i = 1; i <= listaTotaluriMedicZi!.length; i++) {
        TotaluriMedic item = listaTotaluriMedicZi![i - 1];
        totalIncasariInitial = item.totalIncasari;
        totalDeIncasatInitial = item.totalDeIncasat;

        listaTotalIncasariPuncteZi
            .add(FlSpot(i.toDouble(), totalIncasariInitial));
        listaTotalDeIncasatPuncteZi
            .add(FlSpot(i.toDouble(), totalDeIncasatInitial));

        print(
            'initState i : $i totalIncasariInitial : $totalIncasariInitial listaTotalIncasariPuncteZi i ${listaTotalIncasariPuncteZi.last.x} ${listaTotalIncasariPuncteZi.last.y} totalDeIncasatInitial : $totalDeIncasatInitial listaTotalDeIncasatPuncteZi i ${listaTotalDeIncasatPuncteZi.last.x} ${listaTotalDeIncasatPuncteZi.last.y}');

        if (maxListaTotalIncasariTotaluriMedicZi < totalIncasariInitial) {
          maxListaTotalIncasariTotaluriMedicZi = totalIncasariInitial;
        }

        if (maxListaTotalDeIncasatTotaluriMedicZi < totalDeIncasatInitial) {
          maxListaTotalDeIncasatTotaluriMedicZi = totalDeIncasatInitial;
        }
      }
    });
    getLuna();
  }

  void getLuna() async {
    await getPuncteTotaluriDashboardMedicLuna();
    setState(() {
      showLuna = true;
    });
  }

/*
  setTipDate () async {

    dateTip

  }
*/

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPePerioadaCustom(
      DateTime dataInceput, DateTime dataSfarsit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');

    listaTotaluriMedicPerioada!.clear();

    listaTotaluriMedicPerioada =
        await apiCallFunctions.getTotaluriDashboardMedicPePerioadaCustom(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(dataInceput).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(dataSfarsit).toString(),
    );

    return listaTotaluriMedicPerioada!;
  }

  getPuncteTotaluriDashboardMedicPerioada(DatePeriod newPeriod) async {
    print(
        'getPuncteTotaluriDashboardMedicPerioada... perioada ${newPeriod.start} - ${newPeriod.end}');

    //int numarZilePerioada = daysBetween(newPeriod.start, newPeriod.end) + 1;

    listaTotalIncasariPunctePerioada.clear();
    listaTotalDeIncasatPunctePerioada.clear();

    maxListaTotalIncasariTotaluriMedicPerioada = 0.0;
    maxListaTotalDeIncasatTotaluriMedicPerioada = 0.0;

    listaTotaluriMedicPerioada =
        await getTotaluriDashboardMedicPePerioadaCustom(
            newPeriod.start, newPeriod.end);

    if (listaTotaluriMedicPerioada != null &&
        listaTotaluriMedicPerioada!.isNotEmpty) {
      double totalIncasari = 0.0;
      double totalDeIncasat = 0.0;
      TotaluriMedic item;

      int listaTotaluriMedicPerioadaLength = listaTotaluriMedicPerioada!.length;

      for (int i = 0; i < listaTotaluriMedicPerioadaLength; i++) {
        item = listaTotaluriMedicPerioada![i];

        totalIncasari = item.totalIncasari;
        totalDeIncasat = item.totalDeIncasat;

        listaTotalIncasariPunctePerioada
            .add(FlSpot(i.toDouble(), totalIncasari));
        listaTotalDeIncasatPunctePerioada
            .add(FlSpot(i.toDouble(), totalDeIncasat));

        //totaluriDashboardMedic!.totalDeIncasat

        if (maxListaTotalIncasariTotaluriMedicPerioada < totalIncasari) {
          maxListaTotalIncasariTotaluriMedicPerioada = totalIncasari;
        }

        if (maxListaTotalDeIncasatTotaluriMedicPerioada < totalDeIncasat) {
          maxListaTotalDeIncasatTotaluriMedicPerioada = totalDeIncasat;
        }

        print(
            'getPuncteTotaluriDashboardMedicPerioada i : $i totalIncasari : $totalIncasari totalDeIncasat : $totalDeIncasat listaTotalIncasariPunctePerioada i ${listaTotalIncasariPunctePerioada!.last.x} ${listaTotalIncasariPunctePerioada!.last.y} listaTotalDeIncasatPunctePerioadaRangePicker ${listaTotalDeIncasatPunctePerioada!.last.x} ${listaTotalDeIncasatPunctePerioada!.last.y}');
      }
    }
    print(
        'getPuncteTotaluriDashboardMedicPerioada maxListaTotalIncasariTotaluriMedicPerioadaRangePicker $maxListaTotalIncasariTotaluriMedicPerioada maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker $maxListaTotalDeIncasatTotaluriMedicPerioada');
  }

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPeZi(
      DateTime dataInceput) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    //DateTime dateTime = DateTime.now();

    listaTotaluriMedicZi!.clear();

    listaTotaluriMedicZi = await apiCallFunctions.getTotaluriDashboardMedicPeZi(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY: inputFormat.format(dataInceput).toString(),
    );

    print('listaTotaluriMedicZi: $listaTotaluriMedicZi');

    return listaTotaluriMedicZi!;
  }

  getPuncteTotaluriDashboardMedicZi() async {
    listaTotalIncasariPuncteZi.clear();
    listaTotalDeIncasatPuncteZi.clear();

    maxListaTotalIncasariTotaluriMedicZi = 0.0;
    maxListaTotalDeIncasatTotaluriMedicZi = 0.0;

    DateTime astazi = DateTime.now();

    listaTotaluriMedicZi!.clear();

    listaTotaluriMedicZi = await getTotaluriDashboardMedicPeZi(astazi);

    if (listaTotaluriMedicZi != null && listaTotaluriMedicZi!.isNotEmpty) {
      double totalIncasari = 0.0;
      double totalDeIncasat = 0.0;
      TotaluriMedic item;

      int listaTotaluriMedicZiLength = listaTotaluriMedicZi!.length;

      for (int i = 0; i < listaTotaluriMedicZiLength; i++) {
        item = listaTotaluriMedicZi![i];

        totalIncasari = item.totalIncasari;
        totalDeIncasat = item.totalDeIncasat;

        listaTotalIncasariPuncteZi.add(FlSpot(i.toDouble(), totalIncasari));
        listaTotalDeIncasatPuncteZi.add(FlSpot(i.toDouble(), totalDeIncasat));

        //totaluriDashboardMedic!.totalDeIncasat

        if (maxListaTotalIncasariTotaluriMedicZi < totalIncasari) {
          maxListaTotalIncasariTotaluriMedicZi = totalIncasari;
        }

        if (maxListaTotalDeIncasatTotaluriMedicZi < totalDeIncasat) {
          maxListaTotalDeIncasatTotaluriMedicZi = totalDeIncasat;
        }

        print(
            'getPuncteTotaluriDashboardMedicZi i : $i totalIncasari : $totalIncasari totalDeIncasat : $totalDeIncasat listaTotalIncasariPuncteZi i ${listaTotalIncasariPuncteZi.last.x} ${listaTotalIncasariPuncteZi.last.y} listaTotalDeIncasatPuncteZi ${listaTotalDeIncasatPuncteZi.last.x} ${listaTotalDeIncasatPuncteZi.last.y}');
      }
    }
  }

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPeSaptamana(
      DateTime dataInceput, DateTime dataSfarsit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    //DateTime dateTime = DateTime.now();

    listaTotaluriMedicSaptamana!.clear();

    listaTotaluriMedicSaptamana =
        await apiCallFunctions.getTotaluriDashboardMedicPeSaptamana(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(dataInceput).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(dataSfarsit).toString(),
    );

    print('listaTotaluriMedicSaptamana: $listaTotaluriMedicSaptamana');

    return listaTotaluriMedicSaptamana!;
  }

  getPuncteTotaluriDashboardMedicSaptamana() async {
    listaTotalIncasariPuncteSaptamana.clear();
    listaTotalDeIncasatPuncteSaptamana.clear();

    maxListaTotalIncasariTotaluriMedicSaptamana = 0.0;
    maxListaTotalDeIncasatTotaluriMedicSaptamana = 0.0;

    DateTime astazi = DateTime.now();

    int numarZiuaAstazi = astazi.weekday;

    DateTime primaZiSaptamana =
        getDate(astazi.subtract(Duration(days: numarZiuaAstazi - 1)));
    DateTime ultimaZiSaptamana = getDate(
        astazi.add(Duration(days: DateTime.daysPerWeek - numarZiuaAstazi + 1)));

    listaTotaluriMedicSaptamana!.clear();

    listaTotaluriMedicSaptamana = await getTotaluriDashboardMedicPeSaptamana(
        primaZiSaptamana, ultimaZiSaptamana);

    if (listaTotaluriMedicSaptamana != null &&
        listaTotaluriMedicSaptamana!.isNotEmpty) {
      double totalIncasari = 0.0;
      double totalDeIncasat = 0.0;
      TotaluriMedic item;

      int listaTotaluriMedicSaptamanaLength =
          listaTotaluriMedicSaptamana!.length;

      for (int i = 0; i < listaTotaluriMedicSaptamanaLength; i++) {
        item = listaTotaluriMedicSaptamana![i];

        totalIncasari = item.totalIncasari;
        totalDeIncasat = item.totalDeIncasat;

        listaTotalIncasariPuncteSaptamana
            .add(FlSpot(i.toDouble(), totalIncasari));
        listaTotalDeIncasatPuncteSaptamana
            .add(FlSpot(i.toDouble(), totalDeIncasat));

        //totaluriDashboardMedic!.totalDeIncasat

        if (maxListaTotalIncasariTotaluriMedicSaptamana < totalIncasari) {
          maxListaTotalIncasariTotaluriMedicSaptamana = totalIncasari;
        }

        if (maxListaTotalDeIncasatTotaluriMedicSaptamana < totalDeIncasat) {
          maxListaTotalDeIncasatTotaluriMedicSaptamana = totalDeIncasat;
        }

        print(
            'getPuncteTotaluriDashboardMedicSaptamana i : $i totalIncasari : $totalIncasari totalDeIncasat : $totalDeIncasat listaTotalIncasariPuncteSaptamana i ${listaTotalIncasariPuncteSaptamana.last.x} ${listaTotalIncasariPuncteSaptamana.last.y} listaTotalDeIncasatPuncteSaptamana ${listaTotalDeIncasatPuncteSaptamana.last.x} ${listaTotalDeIncasatPuncteSaptamana.last.y}');
      }
    }
  }

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPeLuna(
      DateTime dataInceput, DateTime dataSfarsit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    //DateTime dateTime = DateTime.now();

    listaTotaluriMedicLuna!.clear();

    listaTotaluriMedicLuna =
        await apiCallFunctions.getTotaluriDashboardMedicPeLuna(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(dataInceput).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(dataSfarsit).toString(),
    );

    print('listaTotaluriMedicLuna: $listaTotaluriMedicLuna');

    return listaTotaluriMedicLuna!;
  }

  getPuncteTotaluriDashboardMedicLuna() async {
    listaTotalIncasariPuncteLuna.clear();
    listaTotalDeIncasatPuncteLuna.clear();

    maxListaTotalIncasariTotaluriMedicLuna = 0.0;
    maxListaTotalDeIncasatTotaluriMedicLuna = 0.0;

    DateTime astazi = DateTime.now();

    DateTime primaZiLuna = DateTime.utc(astazi.year, astazi.month, 1);
    DateTime ultimaZiLuna = DateTime(astazi.year, astazi.month + 1, 1);

    listaTotaluriMedicLuna!.clear();

    listaTotaluriMedicLuna =
        await getTotaluriDashboardMedicPeLuna(primaZiLuna, ultimaZiLuna);

    if (listaTotaluriMedicLuna != null && listaTotaluriMedicLuna!.isNotEmpty) {
      double totalIncasari = 0.0;
      double totalDeIncasat = 0.0;
      TotaluriMedic item;

      int listaTotaluriMedicLunaLength = listaTotaluriMedicLuna!.length;

      for (int i = 0; i < listaTotaluriMedicLunaLength; i++) {
        item = listaTotaluriMedicLuna![i];

        totalIncasari = item.totalIncasari;
        totalDeIncasat = item.totalDeIncasat;

        listaTotalIncasariPuncteLuna.add(FlSpot(i.toDouble(), totalIncasari));
        listaTotalDeIncasatPuncteLuna.add(FlSpot(i.toDouble(), totalDeIncasat));

        //totaluriDashboardMedic!.totalDeIncasat

        if (maxListaTotalIncasariTotaluriMedicLuna < totalIncasari) {
          maxListaTotalIncasariTotaluriMedicLuna = totalIncasari;
        }

        if (maxListaTotalDeIncasatTotaluriMedicLuna < totalDeIncasat) {
          maxListaTotalDeIncasatTotaluriMedicLuna = totalDeIncasat;
        }

        print(
            'getPuncteTotaluriDashboardMedicLuna i : $i totalIncasari : $totalIncasari totalDeIncasat : $totalDeIncasat listaTotalIncasariPuncteLuna i ${listaTotalIncasariPuncteLuna.last.x} ${listaTotalIncasariPuncteLuna.last.y} listaTotalDeIncasatPuncteLuna ${listaTotalDeIncasatPuncteLuna.last.x} ${listaTotalDeIncasatPuncteLuna.last.y}');
      }
    }
  }

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPeAn(
      DateTime dataInceput, DateTime dataSfarsit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    //DateTime dateTime = DateTime.now();

    listaTotaluriMedicAn!.clear();

    listaTotaluriMedicAn = await apiCallFunctions.getTotaluriDashboardMedicPeAn(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(dataInceput).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(dataSfarsit).toString(),
    );

    print('listaTotaluriMedicAn: $listaTotaluriMedicAn');

    return listaTotaluriMedicAn!;
  }

  getPuncteTotaluriDashboardMedicAn() async {
    listaTotalIncasariPuncteAn.clear();
    listaTotalDeIncasatPuncteAn.clear();

    maxListaTotalIncasariTotaluriMedicAn = 0.0;
    maxListaTotalDeIncasatTotaluriMedicAn = 0.0;

    DateTime astazi = DateTime.now();

    DateTime primaZiAn = DateTime.utc(astazi.year, 1, 1);
    DateTime primaZiAnNou = DateTime(astazi.year + 1, 1, 1);

    listaTotaluriMedicAn!.clear();

    listaTotaluriMedicAn =
        await getTotaluriDashboardMedicPeAn(primaZiAn, primaZiAnNou);

    if (listaTotaluriMedicAn != null && listaTotaluriMedicAn!.isNotEmpty) {
      double totalIncasari = 0.0;
      double totalDeIncasat = 0.0;
      TotaluriMedic item;

      int listaTotaluriMedicAnLength = listaTotaluriMedicAn!.length;

      for (int i = 0; i < listaTotaluriMedicAnLength; i++) {
        item = listaTotaluriMedicAn![i];

        totalIncasari = item.totalIncasari;
        totalDeIncasat = item.totalDeIncasat;

        listaTotalIncasariPuncteAn.add(FlSpot(i.toDouble(), totalIncasari));
        listaTotalDeIncasatPuncteAn.add(FlSpot(i.toDouble(), totalDeIncasat));

        //totaluriDashboardMedic!.totalDeIncasat

        if (maxListaTotalIncasariTotaluriMedicAn < totalIncasari) {
          maxListaTotalIncasariTotaluriMedicAn = totalIncasari;
        }

        if (maxListaTotalDeIncasatTotaluriMedicAn < totalDeIncasat) {
          maxListaTotalDeIncasatTotaluriMedicAn = totalDeIncasat;
        }

        print(
            'getPuncteTotaluriDashboardMedicAn i : $i totalIncasari : $totalIncasari totalDeIncasat : $totalDeIncasat listaTotalIncasariPuncteAn i ${listaTotalIncasariPuncteAn.last.x} ${listaTotalIncasariPuncteAn.last.y} listaTotalDeIncasatPuncteAn ${listaTotalDeIncasatPuncteAn.last.x} ${listaTotalDeIncasatPuncteAn.last.y}');
      }
    }
  }

  Future<void> callbackDatePeriodLista(
    DatePeriod newSelectedPeriod,
    List<TotaluriMedic> newListaTotaluriMedicPerioada,
    double newMaxListaTotalIncasariTotaluriMedicPerioada,
    List<FlSpot> newListaTotalIncasariPunctePerioada,
    double newMaxListaTotalDeIncasatTotaluriMedicPerioada,
    List<FlSpot> newListaTotalDeIncasatPunctePerioada,
  ) async {
    setState(() {
      selectedPeriod = newSelectedPeriod;
      showRangePicker = true;
      listaTotaluriMedicPerioada = newListaTotaluriMedicPerioada;
      maxListaTotalIncasariTotaluriMedicPerioada =
          newMaxListaTotalIncasariTotaluriMedicPerioada;
      listaTotalIncasariPunctePerioada = newListaTotalIncasariPunctePerioada;
      maxListaTotalDeIncasatTotaluriMedicPerioada =
          newMaxListaTotalDeIncasatTotaluriMedicPerioada;
      listaTotalDeIncasatPunctePerioada = newListaTotalDeIncasatPunctePerioada;

      //listaPuncteRangePicker = initList.filterListByIntervalData(selectedPeriod.start, selectedPeriod.end);

      //lungimeListaPerioada = listaPuncteRangePicker.length;

      //lungimeListaPerioada = listaPunctePerioada.length;
    });

    //await getPuncteTotaluriDashboardMedicPerioada();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center, //(-10.5, -10.5),
          child: SumeIncasariFiltrat(
              sumaDeIncasat: touchedValueZiDeIncasat,
              sumaSoldCurent: touchedValueZiSoldCurent,
              moneda: touchedMonedaZi,
              // sumaDeIncasat: showZi
              //     ? touchedValueZiDeIncasat
              //     : showSaptamana
              //         ? touchedValueSaptamanaDeIncasat
              //         : showLuna
              //             ? touchedValueLunaDeIncasat
              //             : showAn
              //                 ? touchedValueAnDeIncasat
              //                 : touchedValuePerioadaDeIncasat,
              // sumaSoldCurent: showZi
              //     ? touchedValueZiSoldCurent
              //     : showSaptamana
              //         ? touchedValueSaptamanaSoldCurent
              //         : showLuna
              //             ? touchedValueLunaSoldCurent
              //             : showAn
              //                 ? touchedValueAnSoldCurent
              //                 : touchedValuePerioadaSoldCurent,
              // moneda: showZi
              //     ? touchedMonedaZi
              //     : showSaptamana
              //         ? touchedMonedaSaptamana
              //         : showLuna
              //             ? touchedMonedaLuna
              //             : showAn
              //                 ? touchedMonedaAn
              //                 : touchedMonedaPerioada,
              callbackSumeDeIncasat: callbackShowDeIncasat),
        ),
        Column(
          children: [
            //const SizedBox(height:30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 35,
                  child: TextButton(
                    onPressed: () async {
                      await getPuncteTotaluriDashboardMedicZi();

                      setState(() {
                        showZi = true;
                        showSaptamana = false;
                        showLuna = false;
                        showAn = false;
                        showRangePicker = false;
                      });
                    },
                    child: Text(
                      //'Zi', //old IGV
                      l.lineChartIncasariZi,
                      style: GoogleFonts.rubik(
                          color: showZi
                              ? const Color.fromRGBO(103, 114, 148, 1)
                              : const Color.fromRGBO(103, 114, 148, 1)
                                  .withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  width: 115,
                  child: TextButton(
                    onPressed: () async {
                      await getPuncteTotaluriDashboardMedicSaptamana();

                      setState(() {
                        showZi = false;
                        showSaptamana = true;
                        showLuna = false;
                        showAn = false;
                        showRangePicker = false;
                      });
                    },
                    child: Text(
                      //'Săptamana', //old IGV
                      l.lineChartIncasariSaptamana,
                      style: GoogleFonts.rubik(
                          color: showSaptamana
                              ? const Color.fromRGBO(103, 114, 148, 1)
                              : const Color.fromRGBO(103, 114, 148, 1)
                                  .withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: TextButton(
                    onPressed: () async {
                      await getPuncteTotaluriDashboardMedicLuna();

                      setState(() {
                        showZi = false;
                        showSaptamana = false;
                        showLuna = true;
                        showAn = false;
                        showRangePicker = false;
                      });
                    },
                    child: Text(
                      //'Luna', //old IGV
                      l.lineChartIncasariLuna,
                      style: GoogleFonts.rubik(
                          color: showLuna
                              ? const Color.fromRGBO(103, 114, 148, 1)
                              : const Color.fromRGBO(103, 114, 148, 1)
                                  .withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextButton(
                    onPressed: () async {
                      await getPuncteTotaluriDashboardMedicAn();

                      setState(() {
                        showZi = false;
                        showSaptamana = false;
                        showLuna = false;
                        showAn = true;
                        showRangePicker = false;
                      });
                    },
                    child: Text(
                      //'An', //old IGV
                      l.lineChartIncasariAn,
                      style: GoogleFonts.rubik(
                          color: showAn
                              ? const Color.fromRGBO(103, 114, 148, 1)
                              : const Color.fromRGBO(103, 114, 148, 1)
                                  .withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(
                    onPressed: () async {
                      await getPuncteTotaluriDashboardMedicPerioada(
                          selectedPeriod);
                      //print('Aici getTotaluriDashboardMedicPePerioada ');

                      setState(() {
                        showZi = false;
                        showSaptamana = false;
                        showLuna = false;
                        showAn = false;
                        showRangePicker = true;
                      });
                    },
                    icon: Image.asset(
                        './assets/images/calendar_incasari_icon.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 340,
          //height: 140,
          child: AspectRatio(
            aspectRatio: 1.85,
            child: Container(
              color: Colors.white,
              child: LineChart(
                //key:key,
                //showZi ? avgData() : dateLuna(),
                showZi
                    ? dateZi()
                    : showSaptamana
                        ? dateSaptamana()
                        : showLuna
                            ? dateLuna()
                            : showAn
                                ? dateAn()
                                : datePerioada(),
              ),
            ),
          ),
        ),
        //const SizedBox(height:50),
        showRangePicker
            ? SizedBox(
                width: 380,
                child: Column(
                  children: [
                    SizedBox(
                      width: 380,
                      child: RangePickerIncasariFiltrat(
                          showRangePicker: showRangePicker,
                          selectedPeriod: selectedPeriod,
                          callback: callbackDatePeriodLista),
                    ),
                    Container(
                      width: 380,
                      height: MediaQuery.of(context).size.height * 0.05,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            : Container(
                width: 380,
                height: MediaQuery.of(context).size.height * 0.437,
                color: Colors.white,
              ),
        /*
        SizedBox(
          width:350, 
          //height:300,
          //height: MediaQuery.of(context).size.height * 0.4328, 
          child: RangePickerIncasariFiltrat(showRangePicker:showRangePicker, selectedPeriod: selectedPeriod, callback: callback),
        ),
        */
      ],
    );
  }

  Widget titluJosZiWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(103, 114, 148, 1),
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('1:00', style: style);
        break;
      case 4:
        text = const Text('4:00', style: style);
        break;
      case 7:
        text = const Text('7:00', style: style);
        break;
      case 11:
        text = const Text('11:00', style: style);
        break;
      case 14:
        text = const Text('14:00', style: style);
        break;
      case 18:
        text = const Text('18:00', style: style);
        break;
      case 22:
        text = const Text('22:00', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget titluJosSaptamanaWidgets(double value, TitleMeta meta) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        //text = const Text('LU', style: style); //old IGV
        text = Text(l.lineChartIncasariLuni, style: style);
        break;
      case 1:
        //text = const Text('MA', style: style); //old IGV
        text = Text(l.lineChartIncasariMarti, style: style);
        break;
      case 2:
        //text = const Text('MI', style: style); //old IGV
        text = Text(l.lineChartIncasariMiercuri, style: style);
        break;
      case 3:
        //text = const Text('JO', style: style); //old IGV
        text = Text(l.lineChartIncasariJoi, style: style);
        break;
      case 4:
        //text = const Text('VI', style: style); //old IGV
        text = Text(l.lineChartIncasariVineri, style: style);
        break;
      case 5:
        //text = const Text('SÂ', style: style); //old IGV
        text = Text(l.lineChartIncasariSambata, style: style);
        break;
      case 6:
        //text = const Text('DU', style: style); //old IGV
        text = Text(l.lineChartIncasariDuminica, style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

//old IGV
/*
  Widget titluJosLunaWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Ian', style: style);
        break;
      case 3:
        text = const Text('Mar', style: style);
        break;
      case 5:
        text = const Text('Mai', style: style);
        break;
      case 7:
        text = const Text('Iul', style: style);
        break;
      case 9:
        text = const Text('Sep', style: style);
        break;
      case 11:
        text = const Text('Noi', style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
  */

  Widget titluJosLunaWidgetsFebruarie28(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('01', style: style);
        break;
      case 4:
        text = const Text('05', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 14:
        text = const Text('15', style: style);
        break;
      case 19:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('25', style: style);
        break;
      case 27:
        text = const Text('28', style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget titluJosLunaWidgetsFebruarie29(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('01', style: style);
        break;
      case 4:
        text = const Text('05', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 14:
        text = const Text('15', style: style);
        break;
      case 19:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('25', style: style);
        break;
      case 28:
        text = const Text('29', style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget titluJosLunaWidgets30(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('01', style: style);
        break;
      case 4:
        text = const Text('05', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 14:
        text = const Text('15', style: style);
        break;
      case 19:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('25', style: style);
        break;
      case 29:
        text = const Text('30', style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget titluJosLunaWidgets31(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('01', style: style);
        break;
      case 4:
        text = const Text('05', style: style);
        break;
      case 9:
        text = const Text('10', style: style);
        break;
      case 14:
        text = const Text('15', style: style);
        break;
      case 19:
        text = const Text('20', style: style);
        break;
      case 24:
        text = const Text('25', style: style);
        break;
      case 30:
        text = const Text('31', style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget titluJosAnWidgets(double value, TitleMeta meta) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        //text = const Text('Ian', style: style); //old IGV
        text = Text(l.lineChartIncasariIanuarie, style: style);
        break;
      case 2:
        //text = const Text('Mar', style: style); //old IGV
        text = Text(l.lineChartIncasariMartie, style: style);
        break;
      case 4:
        //text = const Text('Mai', style: style); //old IGV
        text = Text(l.lineChartIncasariMai, style: style);
        break;
      case 6:
        //text = const Text('Iul', style: style); //old IGV
        text = Text(l.lineChartIncasariIulie, style: style);
        break;
      case 8:
        //text = const Text('Sep', style: style); //old IGV
        text = Text(l.lineChartIncasariSeptembrie, style: style);
        break;
      case 10:
        //text = const Text('Noi', style: style); //old IGV
        text = Text(l.lineChartIncasariNoiembrie, style: style);
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

/*  //old IGV
  Widget titluJosAnWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('2019', style: style);
        break;
      case 2:
        text = const Text('2020', style: style);
        break;
      case 3:
        text = const Text('2021', style: style);
        break;
      case 4:
        text = const Text('2022', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
*/

  Widget titluJosPerioadaWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    if (value.toInt() == 0) {
      //text = const Text('1', style: style);

      return SideTitleWidget(
        axisSide: meta.axisSide,
        //child: Text(selectedPeriod.start.day.toString() + '.' + selectedPeriod.start.month.toString() + '.' + selectedPeriod.start.year.toString()),
        child: Text(DateFormat('dd.MM.yyyy').format(selectedPeriod.start)),
      );
    } else if (value.toInt() == listaTotalIncasariPunctePerioada.length - 1) {
      //text = const Text('1', style: style);

      return SideTitleWidget(
        axisSide: meta.axisSide,
        //child: Text(selectedPeriod.end.day.toString() + '.' + selectedPeriod.end.month.toString() + '.' + selectedPeriod.end.year.toString()),
        child: Text(DateFormat('dd.MM.yyyy').format(selectedPeriod.end)),
      );
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: const Text(''),
    );
  }

  Widget titluJosPerioadaGolWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: const Text(''),
    );
  }
/*
  Widget titluJosPerioadaWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromRGBO(103, 114, 148, 1),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    //Widget text;
    int pasAfisare = lungimeListaPerioada~/7;
    int pasAfisare2 = 0;
    int pasAfisare3 = 0;
    int pasAfisare4 = 0;
    int pasAfisare5 = 0;
    int pasAfisare6 = 0;
    int pasAfisare7 = 0;

    if (pasAfisare == 0)
    {
      pasAfisare = 1;
      pasAfisare2 = 2;
      pasAfisare3 = 3;
      pasAfisare4 = 4;
      pasAfisare5 = 5;
      pasAfisare6 = 6;
      pasAfisare7 = 7;
    }
    else if (pasAfisare == 1)
    {
      
      pasAfisare2 = pasAfisare * 4;
      pasAfisare3 = pasAfisare * 6;
      pasAfisare4 = pasAfisare * 8;
      pasAfisare5 = pasAfisare * 10;
      pasAfisare6 = pasAfisare * 12;
      pasAfisare = 2;
    }

    if (showRangePicker == true && lungimeListaPerioada == 0) 
    {

      //print('valoare: ${value.toInt()}');
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: const Text(''),
      );
      
    }
    else if (pasAfisare == 0 || pasAfisare == 1)
    {
      if (value.toInt() == 0)
      {
        //text = const Text('1', style: style);
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: const Text('0', style: style),
        );
      }
      else if (value.toInt() == pasAfisare)
      {
        
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare.toString(), style: style),
        );
        //text = Text(pasAfisare.toString(), style: style);
      }
      else if (value.toInt() == pasAfisare2)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare2.toString(), style: style),
        );
      }
      else if (value.toInt() == pasAfisare3)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare3.toString(), style: style),
        );
      }
      else if (value.toInt() == pasAfisare4)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare4.toString(), style: style),
        );
      }
      else if (value.toInt() == pasAfisare5)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare5.toString(), style: style),
        );
      }
      else if (value.toInt() == pasAfisare6)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare6.toString(), style: style),
        );
      }
      else if (value.toInt() == pasAfisare7)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(pasAfisare7.toString(), style: style),
        );
      }
      else if (value.toInt() == lungimeListaPerioada+1)
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text(lungimeListaPerioada.toString(), style: style),
        );
      }
      else 
      {
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: const Text('', style: style),
        );
      }
    }
    else
    {
      if (value.toInt() == 1)
      {
        //text = const Text('1', style: style);
        
        return SideTitleWidget(
          axisSide: meta.axisSide,
          //child: Text(selectedPeriod.start.day.toString() + '.' + selectedPeriod.start.month.toString() + '.' + selectedPeriod.start.year.toString()),
          child: Text(DateFormat('dd.MM.yyyy').format(selectedPeriod.start)),
        );
      }
      else if (value.toInt() == lungimeListaPerioada)
      {
        //text = const Text('1', style: style);
        
        return SideTitleWidget(
          axisSide: meta.axisSide,
          //child: Text(selectedPeriod.end.day.toString() + '.' + selectedPeriod.end.month.toString() + '.' + selectedPeriod.end.year.toString()),
          child: Text(DateFormat('dd.MM.yyyy').format(selectedPeriod.end)),
        );
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: const Text(''),
    );
*/
/*
    switch (value.toInt()) {
      case 1:
        text = const Text('1', style: style);
        break;
      case pasAfisare:
        text = Text(pasAfisare.toString(), style: style);
        break;
      case pasAfisare2:
        text = const Text('2021', style: style);
        break;
      case pasAfisare3:
        text = const Text('2022', style: style);
        break;
      case pasAfisare4:
        text = const Text('2022', style: style);
        break;
      case pasAfisare5:
        text = const Text('2022', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
   

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
  */

  Widget titluStangaWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData datePerioada() {
    /*
    List<FlSpot> listaPunctePerioada = [];
    //listaPuncte.add(const FlSpot(0,0));
    
    int lungimeListaPerioadaDatePerioada = listaFiltrata.length;

    for (int i = 1; i <= lungimeListaPerioadaDatePerioada; i++)
    {
      listaPunctePerioada.add(FlSpot(i.toDouble(),listaFiltrata[i-1].totalIncasari));
    }
    */

    //listaPuncte.add(FlSpot(lungimeListaPerioada.toDouble()+1.0,0));

    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            //if (spot.x == 0 || spot.x == listaFiltrata.length+1) { //old IGV
            if (spot.x ==
                (showDeIncasat
                        ? listaTotalDeIncasatPunctePerioada.length
                        : listaTotalIncasariPunctePerioada.length) +
                    1) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                //color: widget.indicatorTouchedLineColor,
                color: Color.fromRGBO(30, 214, 158, 1),
                strokeWidth: 3,
                dashArray: [3, 8],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 3,
                    //widget.indicatorTouchedSpotStrokeColor,
                    strokeColor: const Color.fromRGBO(30, 214, 158, 1),
                  );
                },
              ),
            );
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (!event.isInterestedForInteractions ||
              lineTouch == null ||
              lineTouch.lineBarSpots == null) {
            setState(() {
              // ignore: avoid_print
              print("Null perioada!");
              //touchedValueZi = -1;
            });
            return;
          }

          final valueX = lineTouch.lineBarSpots![0].x;
          //final valueY = lineTouch.lineBarSpots![0].y; //old IGV
          final indexListaTotaluri = lineTouch.lineBarSpots![0].spotIndex;

          //if (valueX == 0 || valueX == (lungimeListaPerioada.toDouble() + 1.0)) //old IGV
          if (valueX ==
              (showDeIncasat
                  ? listaTotalDeIncasatPunctePerioada.length.toDouble()
                  : listaTotalIncasariPunctePerioada.length.toDouble() + 1.0)) {
            setState(() {
              touchedValuePerioadaDeIncasat = 0.00;
              touchedValuePerioadaSoldCurent = 0.00;
            });
            return;
          }
          setState(() {
            touchedValueZiDeIncasat = -1;
            touchedValueZiSoldCurent = -1;
            touchedValueSaptamanaDeIncasat = -1;
            touchedValueSaptamanaSoldCurent = -1;
            touchedValueLunaDeIncasat = -1;
            touchedValueLunaSoldCurent = -1;
            touchedValueAnDeIncasat = -1;
            touchedValueAnSoldCurent = -1;
            //touchedValuePerioadaDeIncasat = valueY;

            touchedValuePerioadaSoldCurent =
                listaTotaluriMedicPerioada![indexListaTotaluri].totalIncasari;
            touchedValuePerioadaDeIncasat =
                listaTotaluriMedicPerioada![indexListaTotaluri].totalDeIncasat;

            touchedMonedaPerioada =
                listaTotaluriMedicPerioada![indexListaTotaluri].moneda;
          });
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            //color: Color.fromRGBO(30, 214, 158, 1),
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        /*
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        */
        //IGV

        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            //getTitlesWidget: bottomTitleWidgets, old
            getTitlesWidget: listaTotalIncasariPunctePerioada.length > 1
                ? titluJosPerioadaWidgets
                : titluJosPerioadaGolWidgets, //IGV
          ),
        ),

        // leftTitles: const AxisTitles(
        //   sideTitles: SideTitles(showTitles: false),
        // ),
        /*
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            //showTitles: true,
            showTitles: false,
            interval: 1,
            getTitlesWidget: titluStangaWidgets,
            reservedSize: 42,
          ),
        ),
        */
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d,)), old
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: (showDeIncasat
          ? listaTotalDeIncasatPunctePerioada.length.toDouble()
          : listaTotalIncasariPunctePerioada.length.toDouble()),
      minY: 0,
      maxY: (showDeIncasat
              ? maxListaTotalDeIncasatTotaluriMedicPerioada
              : maxListaTotalIncasariTotaluriMedicPerioada) *
          1.1,
      lineBarsData: [
        LineChartBarData(
          spots: (showDeIncasat
              ? listaTotalDeIncasatPunctePerioada
              : listaTotalIncasariPunctePerioada),

          isCurved: true,
          //IGV ramane comentat
          //gradient: LinearGradient(
          //  colors: gradientColors,
          //),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromRGBO(30, 214, 158, 1),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(30, 214, 158, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData dateZi() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            //if (spot.x == 0 || spot.x == 24) { //old IGV
            if (spot.x == 24) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                //color: widget.indicatorTouchedLineColor,
                color: Color.fromRGBO(30, 214, 158, 1),
                strokeWidth: 3,
                dashArray: [3, 8],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 3,
                    //widget.indicatorTouchedSpotStrokeColor,
                    strokeColor: const Color.fromRGBO(30, 214, 158, 1),
                  );
                },
              ),
            );
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (!event.isInterestedForInteractions ||
              lineTouch == null ||
              lineTouch.lineBarSpots == null) {
            setState(() {
              //
              // ignore: avoid_print
              print("Null zi!");
              //touchedValueZi = -1;
            });
            return;
          }

          final valueX = lineTouch.lineBarSpots![0].x;
          //final valueY = lineTouch.lineBarSpots![0].y;
          final indexListaTotaluri = lineTouch.lineBarSpots![0].spotIndex;

          //if (valueX == 0 || valueX == 24) { //old IGV
          if (valueX == 24) {
            setState(() {
              touchedValueZiSoldCurent = 0.00;
              touchedValueZiDeIncasat = 0.00;
            });
            return;
          }
          setState(() {
            touchedValueZiDeIncasat =
                listaTotaluriMedicZi![indexListaTotaluri].totalDeIncasat;
            touchedValueZiSoldCurent =
                listaTotaluriMedicZi![indexListaTotaluri].totalIncasari;

            touchedMonedaZi = listaTotaluriMedicZi![indexListaTotaluri].moneda;

            touchedValueSaptamanaDeIncasat = -1;
            touchedValueSaptamanaSoldCurent = -1;
            touchedValueLunaDeIncasat = -1;
            touchedValueLunaSoldCurent = -1;
            touchedValueAnDeIncasat = -1;
            touchedValueAnSoldCurent = -1;
            //touchedValuePerioadaDeIncasat = valueY;
            touchedValuePerioadaSoldCurent = -1;
            touchedValuePerioadaDeIncasat = -1;
          });
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        //bottomTitles: const AxisTitles(
        //  sideTitles: SideTitles(showTitles: false),
        //),
        //IGV
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            //getTitlesWidget: bottomTitleWidgets, old
            getTitlesWidget: titluJosZiWidgets, //IGV
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            //showTitles: true,
            showTitles: false,
            interval: 1,
            getTitlesWidget: titluStangaWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d,)), old
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: 23,
      minY: 0,
      maxY: (showDeIncasat
              ? maxListaTotalDeIncasatTotaluriMedicZi
              : maxListaTotalIncasariTotaluriMedicZi) *
          1.1,
      lineBarsData: [
        LineChartBarData(
          spots: showDeIncasat
              ? listaTotalDeIncasatPuncteZi
              : listaTotalIncasariPuncteZi,
          /*const [
              FlSpot(0, 3),
              FlSpot(2, 2.2),
              FlSpot(4, 4),
              FlSpot(6, 4.1),
              FlSpot(8, 4.3),
              FlSpot(9, 3),
              FlSpot(11, 4),
              FlSpot(12, 3.5),
              FlSpot(14, 4.2),
              FlSpot(16.5, 2.3),
              FlSpot(17.25, 3.4),
              FlSpot(18, 1.3),
              FlSpot(19.5, 4.3),
              FlSpot(20, 2.4),
              FlSpot(21, 4.0),
              FlSpot(23, 0.0),
            ]
            */
          isCurved: true,
          //IGV ramane comentat
          //gradient: LinearGradient(
          //  colors: gradientColors,
          //),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromRGBO(30, 214, 158, 1),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(30, 214, 158, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData dateSaptamana() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            //if (spot.x == 0 || spot.x == 8) { //old IGV
            if (spot.x == 8) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                //color: widget.indicatorTouchedLineColor,
                color: Color.fromRGBO(30, 214, 158, 1),
                strokeWidth: 3,
                dashArray: [3, 8],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 3,
                    //widget.indicatorTouchedSpotStrokeColor,
                    strokeColor: const Color.fromRGBO(30, 214, 158, 1),
                  );
                },
              ),
            );
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (!event.isInterestedForInteractions ||
              lineTouch == null ||
              lineTouch.lineBarSpots == null) {
            setState(() {
              // ignore: avoid_print
              print("Null saptamana!");
              //touchedValueZi = -1;
            });
            return;
          }

          final valueX = lineTouch.lineBarSpots![0].x;
          //final valueY = lineTouch.lineBarSpots![0].y;
          final indexListaTotaluri = lineTouch.lineBarSpots![0].spotIndex;

          //if (valueX == 0 || valueX == 8) { //old IGV
          if (valueX == 8) {
            setState(() {
              touchedValueSaptamanaSoldCurent = 0.00;
              touchedValueSaptamanaDeIncasat = 0.00;
            });
            return;
          }
          setState(() {
            touchedValueZiDeIncasat = -1;
            touchedValueZiSoldCurent = -1;
            touchedValueSaptamanaDeIncasat =
                listaTotaluriMedicSaptamana![indexListaTotaluri].totalDeIncasat;
            touchedValueSaptamanaSoldCurent =
                listaTotaluriMedicSaptamana![indexListaTotaluri].totalIncasari;

            touchedMonedaSaptamana =
                listaTotaluriMedicSaptamana![indexListaTotaluri].moneda;

            touchedValueLunaDeIncasat = -1;
            touchedValueLunaSoldCurent = -1;
            touchedValueAnDeIncasat = -1;
            touchedValueAnSoldCurent = -1;
            //touchedValuePerioadaDeIncasat = valueY;
            touchedValuePerioadaSoldCurent = -1;
            touchedValuePerioadaDeIncasat = -1;
          });
        },
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            //color: Color.fromRGBO(30, 214, 158, 1),
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            //getTitlesWidget: bottomTitleWidgets, old
            getTitlesWidget: titluJosSaptamanaWidgets, //IGV
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            //showTitles: true,
            showTitles: false,
            interval: 1,
            getTitlesWidget: titluStangaWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d)),
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: (showDeIncasat
              ? maxListaTotalDeIncasatTotaluriMedicSaptamana
              : maxListaTotalIncasariTotaluriMedicSaptamana) *
          1.1,
      lineBarsData: [
        LineChartBarData(
          spots:

              /*
          const [
            FlSpot(0, 0),
            FlSpot(1, 2),
            FlSpot(2, 4.4),
            FlSpot(3, 3.1),
            FlSpot(4, 4.2),
            FlSpot(5, 4.1),
            FlSpot(6, 2.9),
            FlSpot(7, 1.9),
            FlSpot(8, 0),
          ]
          */
              (showDeIncasat
                  ? listaTotalDeIncasatPuncteSaptamana
                  : listaTotalIncasariPuncteSaptamana),
          isCurved: true,
          //IGV ramane comentat
          //gradient: LinearGradient(
          //  colors: gradientColors,
          //),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromRGBO(30, 214, 158, 1),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(30, 214, 158, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData dateLuna() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            if (spot.x == 0 ||
                spot.x ==
                    (showDeIncasat
                            ? listaTotalDeIncasatPuncteLuna.length
                            : listaTotalIncasariPuncteLuna.length) +
                        1) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                //color: widget.indicatorTouchedLineColor,
                color: Color.fromRGBO(30, 214, 158, 1),
                strokeWidth: 3,
                dashArray: [3, 8],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 3,
                    //widget.indicatorTouchedSpotStrokeColor,
                    strokeColor: const Color.fromRGBO(30, 214, 158, 1),
                  );
                },
              ),
            );
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (!event.isInterestedForInteractions ||
              lineTouch == null ||
              lineTouch.lineBarSpots == null) {
            setState(() {
              print("Null Luna!");
              //touchedValueZi = -1;
            });
            return;
          }

          final valueX = lineTouch.lineBarSpots![0].x;
          //final valueY = lineTouch.lineBarSpots![0].y;„
          final indexListaTotaluri = lineTouch.lineBarSpots![0].spotIndex;

          if (valueX == 0 ||
              valueX ==
                  (showDeIncasat
                      ? listaTotalDeIncasatPuncteLuna.length
                      : listaTotalIncasariPuncteLuna.length)) {
            setState(() {
              touchedValueLunaDeIncasat = 0.00;
              touchedValueLunaSoldCurent = 0.00;
            });
            return;
          }
          setState(() {
            touchedValueZiDeIncasat = -1;
            touchedValueZiSoldCurent = -1;
            touchedValueSaptamanaDeIncasat = -1;
            touchedValueSaptamanaSoldCurent = -1;

            touchedValueLunaDeIncasat =
                listaTotaluriMedicLuna![indexListaTotaluri].totalDeIncasat;
            touchedValueLunaSoldCurent =
                listaTotaluriMedicLuna![indexListaTotaluri].totalIncasari;

            touchedMonedaLuna =
                listaTotaluriMedicLuna![indexListaTotaluri].moneda;

            touchedValueAnDeIncasat = -1;
            touchedValueAnSoldCurent = -1;
            //touchedValuePerioadaDeIncasat = valueY;
            touchedValuePerioadaSoldCurent = -1;
            touchedValuePerioadaDeIncasat = -1;
          });
        },
      ),
      gridData: FlGridData(
        show: true,
        //drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            //color: Color.fromRGBO(30, 214, 158, 1),
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            color: Color.fromRGBO(255, 255, 255, 0.0),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            //getTitlesWidget: bottomTitleWidgets, old
            getTitlesWidget:
                //titluJosLunaWidgets, //old IGV
                (showDeIncasat
                            ? listaTotalDeIncasatPuncteLuna.length
                            : listaTotalIncasariPuncteLuna.length) ==
                        28
                    ? titluJosLunaWidgetsFebruarie28
                    : (showDeIncasat
                                ? listaTotalDeIncasatPuncteLuna.length
                                : listaTotalIncasariPuncteLuna.length) ==
                            29
                        ? titluJosLunaWidgetsFebruarie29
                        : (showDeIncasat
                                    ? listaTotalDeIncasatPuncteLuna.length
                                    : listaTotalIncasariPuncteLuna.length) ==
                                30
                            ? titluJosLunaWidgets30
                            : (showDeIncasat
                                        ? listaTotalDeIncasatPuncteLuna.length
                                        : listaTotalIncasariPuncteLuna
                                            .length) ==
                                    31
                                ? titluJosLunaWidgets31
                                : titluJosLunaWidgets30,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        /* old
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: titluStangaWidgets,
            reservedSize: 42,
          ),
        ),
        */
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d)),
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: (showDeIncasat
          ? listaTotalDeIncasatPuncteLuna.length.toDouble()
          : listaTotalIncasariPuncteLuna.length.toDouble()), //13,
      minY: 0,
      maxY: (showDeIncasat
              ? maxListaTotalDeIncasatTotaluriMedicLuna
              : maxListaTotalIncasariTotaluriMedicLuna) *
          1.1,
      lineBarsData: [
        LineChartBarData(
          spots: (showDeIncasat
              ? listaTotalDeIncasatPuncteLuna
              : listaTotalIncasariPuncteLuna),
          /*const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
            FlSpot(13, 0),
          ]
          */
          isCurved: true,
          //IGV ramane comentat
          //gradient: LinearGradient(
          //  colors: gradientColors,
          //),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromRGBO(30, 214, 158, 1),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(30, 214, 158, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData dateAn() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            final spot = barData.spots[spotIndex];
            //if (spot.x == 0 || spot.x == listaPuncteAn.length+1) { //old IGV
            if (spot.x ==
                (showDeIncasat
                        ? listaTotalDeIncasatPuncteAn.length
                        : listaTotalIncasariPuncteAn.length) +
                    1) {
              return null;
            }
            return TouchedSpotIndicatorData(
              const FlLine(
                //color: widget.indicatorTouchedLineColor,
                color: Color.fromRGBO(30, 214, 158, 1),
                strokeWidth: 3,
                dashArray: [3, 8],
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeWidth: 3,
                    //widget.indicatorTouchedSpotStrokeColor,
                    strokeColor: const Color.fromRGBO(30, 214, 158, 1),
                  );
                },
              ),
            );
          }).toList();
        },
        touchCallback: (FlTouchEvent event, LineTouchResponse? lineTouch) {
          if (!event.isInterestedForInteractions ||
              lineTouch == null ||
              lineTouch.lineBarSpots == null) {
            setState(() {
              print("Null An!");
              //touchedValueZi = -1;
            });
            return;
          }

          final valueX = lineTouch.lineBarSpots![0].x;
          //final valueY = lineTouch.lineBarSpots![0].y;
          final indexListaTotaluri = lineTouch.lineBarSpots![0].spotIndex;

          //if (valueX == 0 || valueX == (listaPuncteAn.length + 1)) { //old IGV
          if (valueX ==
              ((showDeIncasat
                      ? listaTotalDeIncasatPuncteAn.length
                      : listaTotalIncasariPuncteAn.length) +
                  1)) {
            setState(() {
              touchedValueAnDeIncasat = 0.00;
              touchedValueAnSoldCurent = 0.00;
            });

            return;
          }
          setState(() {
            touchedValueZiDeIncasat = -1;
            touchedValueZiSoldCurent = -1;
            touchedValueSaptamanaDeIncasat = -1;
            touchedValueSaptamanaSoldCurent = -1;
            touchedValueLunaDeIncasat = -1;
            touchedValueLunaSoldCurent = -1;

            touchedValueAnDeIncasat =
                listaTotaluriMedicAn![indexListaTotaluri].totalDeIncasat;
            touchedValueAnSoldCurent =
                listaTotaluriMedicAn![indexListaTotaluri].totalIncasari;

            touchedMonedaAn = listaTotaluriMedicAn![indexListaTotaluri].moneda;

            //touchedValuePerioadaDeIncasat = valueY;
            touchedValuePerioadaSoldCurent = -1;
            touchedValuePerioadaDeIncasat = -1;
          });
        },
      ),
      gridData: FlGridData(
        show: true,
        //drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            //color: Color.fromRGBO(30, 214, 158, 1),
            color: Color.fromRGBO(255, 255, 255, 1),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            //color: AppColors.mainGridLineColor,
            color: Color.fromRGBO(255, 255, 255, 1),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            //getTitlesWidget: bottomTitleWidgets, old
            getTitlesWidget: titluJosAnWidgets, //IGV
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
          /* old
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: titluStangaWidgets,
            reservedSize: 42,
          ),
          */
        ),
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d)),
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: (showDeIncasat
              ? listaTotalDeIncasatPuncteAn.length.toDouble()
              : listaTotalIncasariPuncteAn.length.toDouble()) -
          1,
      minY: 0,
      maxY: (showDeIncasat
              ? maxListaTotalDeIncasatTotaluriMedicAn
              : maxListaTotalIncasariTotaluriMedicAn) *
          1.1,
      lineBarsData: [
        LineChartBarData(
          spots: (showDeIncasat
              ? listaTotalDeIncasatPuncteAn
              : listaTotalIncasariPuncteAn),
          /*const [
            FlSpot(0, 0.0),
            FlSpot(1, 2.6),
            FlSpot(2, 4.9),
            FlSpot(3, 1.4),
            FlSpot(4, 2.5),
            FlSpot(5, 0.0),
          ],
          */

          isCurved: true,
          //IGV ramane comentat
          //gradient: LinearGradient(
          //  colors: gradientColors,
          //),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          color: const Color.fromRGBO(30, 214, 158, 1),
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(30, 214, 158, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/*
//old LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            //getTitlesWidget: bottomTitleWidgets, old
            getTitlesWidget: titluJosLunaWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            //showTitles: true,
            showTitles: false,
            getTitlesWidget: titluStangaWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d)),
        border: Border.all(color: Colors.white),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 5,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          //IGV ramane comentat
          //gradient: LinearGradient(
          //  colors: [
          //gradientColors[0],
          //gradientColors[1]
          //ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //          .lerp(0.2)!,
          //      ColorTween(begin: gradientColors[0], end: gradientColors[1])
          //          .lerp(0.2)!,
          //],
          //),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            //gradient: LinearGradient(
            //  colors: [
            //    gradientColors[1],
            //    gradientColors[0]
            //    ColorTween(begin: gradientColors[0], end: gradientColors[1])
            //        .lerp(0.2)!
            //        .withOpacity(0.1),
            //    ColorTween(begin: gradientColors[0], end: gradientColors[1])
            //        .lerp(0.2)!
            //        .withOpacity(0.1),
            //
            //],
            //),
          ),
        ),
      ],
    );
  }
  */
