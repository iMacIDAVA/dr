
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';


/// Screen with the [RangePicker].

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

TotaluriMedic? totaluriDashboardMedic;

// ignore: must_be_immutable
class RangePickerIncasariFiltrat extends StatefulWidget {
  
  final bool showRangePicker;
  DatePeriod selectedPeriod;
  final Future<void> Function(DatePeriod, List<TotaluriMedic>newListaTotaluriMedicPerioada, double newMaxListaTotalIncasariTotaluriMedicPerioada, List<FlSpot> newListaTotalIncasariPunctePerioada, double maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker, List<FlSpot> listaTotalDeIncasatPunctePerioadaRangePicker)? callback; 

  ///
  RangePickerIncasariFiltrat({Key? key, required this.showRangePicker, required this.selectedPeriod, required this.callback}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _RangePickerIncasariFiltratState();
}

class _RangePickerIncasariFiltratState extends State<RangePickerIncasariFiltrat> {

  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 4050));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365));

  List <TotaluriMedic>? listaTotaluriMedicPerioadaRangePicker = [];

  double maxListaTotalIncasariTotaluriMedicPerioadaRangePicker = 0.0;

  double maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker = 0.0;

  List<FlSpot>? listaTotalIncasariPunctePerioadaRangePicker = [];

  List<FlSpot>? listaTotalDeIncasatPunctePerioadaRangePicker = [];

  /*
  DatePeriod _selectedPeriod = DatePeriod(
      DateTime.now().subtract(const Duration(days: 350)),
      DateTime.now().subtract(const Duration(days: 12)));
  */
  DatePeriod _selectedPeriod = DatePeriod(
      DateTime.now(),
      DateTime.now());

  Color selectedPeriodStartColor = const Color.fromRGBO(14, 190, 127, 1);//Colors.blue;
  Color selectedPeriodLastColor = const Color.fromRGBO(14, 190, 127, 1);//Colors.blue;
  Color selectedPeriodMiddleColor = const Color.fromRGBO(50, 250, 180, 0.8);//Colors.blue;//Colors.blue;

  @override
  void initState() {
    super.initState();

    _selectedPeriod = widget.selectedPeriod;

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedPeriodLastColor = const Color.fromRGBO(14, 190, 127, 1);
    selectedPeriodMiddleColor = const Color.fromRGBO(35, 234, 164, 1);
    selectedPeriodStartColor = const Color.fromRGBO(14, 190, 127, 1);
  }

  Future<List<TotaluriMedic>?> getTotaluriDashboardMedicPePerioadaCustom(DateTime dataInceput, DateTime dataSfarsit) async 
  {
  
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    
    String user = prefs.getString('user')??'';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5)??'';

    DateFormat inputFormat = DateFormat('ddMMyyyy');
    //DateTime dateTime = DateTime.now();

    listaTotaluriMedicPerioadaRangePicker!.clear();

    listaTotaluriMedicPerioadaRangePicker = await apiCallFunctions.getTotaluriDashboardMedicPePerioadaCustom(
      pUser: user,
      pParola: userPassMD5,
      pDataInceputDDMMYYYY: inputFormat.format(dataInceput).toString(),//'01010001', //old IGV
      pDataSfarsitDDMMYYYY: inputFormat.format(dataSfarsit).toString(),
    );

    print('listaTotaluriMedicPerioadaRangePicker: $listaTotaluriMedicPerioadaRangePicker');


    return listaTotaluriMedicPerioadaRangePicker!;

  }


  getPuncteTotaluriDashboardMedicPerioada(DatePeriod newPeriod) async
  {

    print('getPuncteTotaluriDashboardMedicPerioada... perioada ${newPeriod.start} - ${newPeriod.end}');

    //int numarZilePerioada = daysBetween(newPeriod.start, newPeriod.end) + 1;

    
    listaTotalIncasariPunctePerioadaRangePicker!.clear();
    listaTotalDeIncasatPunctePerioadaRangePicker!.clear();

    maxListaTotalIncasariTotaluriMedicPerioadaRangePicker = 0.0;
    maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker = 0.0;

    listaTotaluriMedicPerioadaRangePicker = await getTotaluriDashboardMedicPePerioadaCustom(newPeriod.start, newPeriod.end);

    if (listaTotaluriMedicPerioadaRangePicker != null && listaTotaluriMedicPerioadaRangePicker!.isNotEmpty)
    {
      double totalIncasari = 0.0;
      double totalDeIncasat = 0.0;
      TotaluriMedic item;

      for (int i = 0; i < listaTotaluriMedicPerioadaRangePicker!.length; i++)
      {
        item = listaTotaluriMedicPerioadaRangePicker![i];
        
        totalIncasari = item.totalIncasari;
        totalDeIncasat = item.totalDeIncasat;

        listaTotalIncasariPunctePerioadaRangePicker!.add(FlSpot(i.toDouble(), totalIncasari));
        listaTotalDeIncasatPunctePerioadaRangePicker!.add(FlSpot(i.toDouble(), totalDeIncasat));

        //totaluriDashboardMedic!.totalDeIncasat

        if (maxListaTotalIncasariTotaluriMedicPerioadaRangePicker < totalIncasari)
        {

          maxListaTotalIncasariTotaluriMedicPerioadaRangePicker = totalIncasari;

        }
        
        if (maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker < totalDeIncasat)
        {

          maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker = totalDeIncasat;

        }

        print('getPuncteTotaluriDashboardMedicPerioada i : $i totalIncasari : $totalIncasari totalDeIncasat : $totalDeIncasat listaTotalIncasariPunctePerioada i ${listaTotalIncasariPunctePerioadaRangePicker!.last.x} ${listaTotalIncasariPunctePerioadaRangePicker!.last.y} listaTotalDeIncasatPunctePerioadaRangePicker ${listaTotalDeIncasatPunctePerioadaRangePicker!.last.x} ${listaTotalDeIncasatPunctePerioadaRangePicker!.last.y}');

      }
    }
    print('getPuncteTotaluriDashboardMedicPerioada maxListaTotalIncasariTotaluriMedicPerioadaRangePicker $maxListaTotalIncasariTotaluriMedicPerioadaRangePicker maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker $maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker');

  }

  @override
  Widget build(BuildContext context) {

    // add selected colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(

        selectedPeriodStartTextStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        selectedPeriodMiddleTextStyle: const TextStyle(color: Color.fromRGBO(78, 87, 133, 1)),
        selectedPeriodEndTextStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        selectedPeriodLastDecoration: const BoxDecoration(
          color: Color.fromRGBO(14, 190, 127, 1),
          shape: BoxShape.rectangle,

          //color: selectedPeriodLastColor,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(24.0),
              bottomEnd: Radius.circular(24.0)),
        ),
        selectedPeriodStartDecoration: const BoxDecoration(
          color: Color.fromRGBO(14, 190, 127, 1),

          //color: selectedPeriodStartColor,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(24.0),
              bottomStart: Radius.circular(24.0)),    
        ),
        selectedPeriodMiddleDecoration: const BoxDecoration(
            color: Color.fromRGBO(50, 250, 190, 0.6),
            //color: selectedPeriodMiddleColor, 
            shape: BoxShape.rectangle,
        ),
        nextIcon: const Icon(Icons.arrow_right),
        prevIcon: const Icon(Icons.arrow_left),
        dayHeaderStyleBuilder: _dayHeaderStyleBuilder);

    return widget.showRangePicker ? Flex(
      direction: MediaQuery.of(context).orientation == Orientation.portrait
          ? Axis.vertical
          : Axis.horizontal,
      children: <Widget>[
        RangePicker(
          initiallyShowDate: DateTime.now(),
          selectedPeriod: _selectedPeriod,
          onChanged: _onSelectedDateChanged,
          firstDate: _firstDate,
          lastDate: _lastDate,
          datePickerStyles: styles,
          //selectableDayPredicate: _isSelectableCustom,
          onSelectionError: _onSelectionError,
        ),
      ],
    ) : const SizedBox();
  }
    
  // select background color for the first date of the selected period

  void _onSelectedDateChanged(DatePeriod newPeriod) async {
    if (widget.callback != null) {
      await getPuncteTotaluriDashboardMedicPerioada(newPeriod);
      await widget.callback!(newPeriod, listaTotaluriMedicPerioadaRangePicker??[], maxListaTotalIncasariTotaluriMedicPerioadaRangePicker, listaTotalIncasariPunctePerioadaRangePicker??[], maxListaTotalDeIncasatTotaluriMedicPerioadaRangePicker, listaTotalDeIncasatPunctePerioadaRangePicker??[]);
      setState(() {
        
        _selectedPeriod = newPeriod;
      });
    } else {
      setState(() {
        widget.selectedPeriod = newPeriod;
        _selectedPeriod = newPeriod;
        // ignore: avoid_print
        //print(widget.selectedPeriod);
      });
    }
    /*
    setState(() {
      if (widget.callback != null) {
        widget.callback!(newPeriod);
      }  
      _selectedPeriod = newPeriod;
    });
    */
  }

  // ignore: prefer_expression_function_bodies
  /*
  bool _isSelectableCustom(DateTime day) {
    
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));
    bool isYesterday = sameDate(day, yesterday);
    bool isTomorrow = sameDate(day, tomorrow);

    return !isYesterday && !isTomorrow;

  }
  */

  void _onSelectionError(UnselectablePeriodException exception) {
    DatePeriod errorPeriod = exception.period;

    // If user supposed to set another start of the period.
    bool selectStart = _selectedPeriod.start != errorPeriod.start;

    DateTime newSelection = selectStart ? errorPeriod.start : errorPeriod.end;

    DatePeriod newPeriod = DatePeriod(newSelection, newSelection);

    setState(() {
      _selectedPeriod = newPeriod;
    });
  }

  // 0 is Sunday, 6 is Saturday
  DayHeaderStyle _dayHeaderStyleBuilder(int weekday) {
    return const DayHeaderStyle(
        //textStyle: TextStyle(color: isWeekend ? const Color.fromRGBO(103, 114, 148, 1) : Colors.teal));
        textStyle: TextStyle(color: Color.fromRGBO(103, 114, 148, 1)));
  }
}

/// Only check the date part and not the time
/*bool sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
    */