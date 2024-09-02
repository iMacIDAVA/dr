import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:sos_bebe_profil_bebe_doctor/reset_password_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

class IncasariService {
  Future<List<dynamic>> getIncasariCustom(
      DateTime dataInceput, DateTime dataSfarsit) async {
    List<FlSpot> graphSpots = [];
    List<TotaluriMedic>? totaluriMedic = [];
    TotaluriMedic item;
    double maxListaTotalIncasariTotaluriMedicZi = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    DateFormat inputFormat = DateFormat('ddMMyyyy');

    totaluriMedic =
        await apiCallFunctions.getTotaluriDashboardMedicPePerioadaCustom(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(dataInceput).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(dataSfarsit).toString(),
    );
    for (int i = 0; i < totaluriMedic!.length; i++) {
      item = totaluriMedic[i];
      graphSpots.add(FlSpot(i.toDouble(), item.totalIncasari));

      if (maxListaTotalIncasariTotaluriMedicZi < item.totalIncasari) {
        maxListaTotalIncasariTotaluriMedicZi = item.totalIncasari;
      }
    }
    return [graphSpots, maxListaTotalIncasariTotaluriMedicZi];
  }

  Future<List<dynamic>> getIncasariAn() async {
    List<FlSpot> graphSpots = [];
    List<TotaluriMedic>? totaluriMedic = [];
    TotaluriMedic item;
    double maxListaTotalIncasariTotaluriMedicZi = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime astazi = DateTime.now();

    DateTime primaZiAn = DateTime.utc(astazi.year, 1, 1);
    DateTime primaZiAnNou = DateTime(astazi.year + 1, 1, 1);

    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedicPeAn(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(primaZiAn).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(primaZiAnNou).toString(),
    );
    for (int i = 0; i < totaluriMedic!.length; i++) {
      item = totaluriMedic[i];
      graphSpots.add(FlSpot(i.toDouble(), item.totalIncasari));

      if (maxListaTotalIncasariTotaluriMedicZi < item.totalIncasari) {
        maxListaTotalIncasariTotaluriMedicZi = item.totalIncasari;
      }
    }
    return [graphSpots, maxListaTotalIncasariTotaluriMedicZi];
  }

  Future<List<dynamic>> getIncasariLuna() async {
    List<FlSpot> graphSpots = [];
    List<TotaluriMedic>? totaluriMedic = [];
    TotaluriMedic item;
    double maxListaTotalIncasariTotaluriMedicZi = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime astazi = DateTime.now();

    DateTime primaZiLuna = DateTime.utc(astazi.year, astazi.month, 1);
    DateTime ultimaZiLuna = DateTime(astazi.year, astazi.month + 1, 1);

    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedicPeLuna(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY:
          inputFormat.format(primaZiLuna).toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(ultimaZiLuna).toString(),
    );
    for (int i = 0; i < totaluriMedic!.length; i++) {
      item = totaluriMedic[i];
      graphSpots.add(FlSpot(i.toDouble(), item.totalIncasari));

      if (maxListaTotalIncasariTotaluriMedicZi < item.totalIncasari) {
        maxListaTotalIncasariTotaluriMedicZi = item.totalIncasari;
      }
    }
    return [graphSpots, maxListaTotalIncasariTotaluriMedicZi];
  }

  Future<List<dynamic>> getIncasariSaptamana() async {
    List<FlSpot> graphSpots = [];
    List<TotaluriMedic>? totaluriMedic = [];
    TotaluriMedic item;
    double maxListaTotalIncasariTotaluriMedicZi = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    DateFormat inputFormat = DateFormat('ddMMyyyy');
    DateTime astazi = DateTime.now();

    int numarZiuaAstazi = astazi.weekday;
    DateTime primaZiSaptamana =
        getDate(astazi.subtract(Duration(days: numarZiuaAstazi - 1)));
    DateTime ultimaZiSaptamana = getDate(
        astazi.add(Duration(days: DateTime.daysPerWeek - numarZiuaAstazi + 1)));

    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedicPeSaptamana(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY: inputFormat
          .format(primaZiSaptamana)
          .toString(), //'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(ultimaZiSaptamana).toString(),
    );
    for (int i = 0; i < totaluriMedic!.length; i++) {
      item = totaluriMedic[i];
      graphSpots.add(FlSpot(i.toDouble(), item.totalIncasari));

      if (maxListaTotalIncasariTotaluriMedicZi < item.totalIncasari) {
        maxListaTotalIncasariTotaluriMedicZi = item.totalIncasari;
      }
    }
    return [graphSpots, maxListaTotalIncasariTotaluriMedicZi];
  }

  Future<List<dynamic>> getIncasariZi() async {
    List<FlSpot> graphSpots = [];
    List<TotaluriMedic>? totaluriMedic = [];
    TotaluriMedic item;
    double maxListaTotalIncasariTotaluriMedicZi = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    DateFormat inputFormat = DateFormat('ddMMyyyy');
    totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedicPeZi(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY: inputFormat.format(DateTime.now()).toString(),
    );

    for (int i = 0; i < totaluriMedic!.length; i++) {
      item = totaluriMedic[i];
      graphSpots.add(FlSpot(i.toDouble(), item.totalIncasari));

      if (maxListaTotalIncasariTotaluriMedicZi < item.totalIncasari) {
        maxListaTotalIncasariTotaluriMedicZi = item.totalIncasari;
      }
    }

    return [graphSpots, maxListaTotalIncasariTotaluriMedicZi];
  }
}
