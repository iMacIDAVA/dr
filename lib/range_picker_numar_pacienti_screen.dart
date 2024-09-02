import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:sos_bebe_profil_bebe_doctor/initializare_numar_pacienti_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/numar_pacienti_widgets_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';

import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

import 'package:intl/intl.dart';

//import 'package:sos_bebe_profil_bebe_doctor/data_picker_widgets/color_selector_btn.dart';

/// Page with the [RangePicker].
class RangePickerNumarPacientiFiltrat extends StatefulWidget {
  final List<ConsultatiiMobile> listaConsultatiiMobileNumarPacienti;

  ///
  const RangePickerNumarPacientiFiltrat({
    super.key,
    required this.listaConsultatiiMobileNumarPacienti,
    //required this.contMedicMobile,
  });

  @override
  State<StatefulWidget> createState() =>
      _RangePickerNumarPacientiFiltratState();
}

class _RangePickerNumarPacientiFiltratState
    extends State<RangePickerNumarPacientiFiltrat> {
  final dateNow = DateTime.now().year;
  final DateTime _firstDate =
      DateTime.now().subtract(const Duration(days: 3450));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365));

  DatePeriod _selectedPeriod = DatePeriod(
      DateTime(DateTime.now().year, DateTime.now().month, 1), DateTime.now());

  Color selectedPeriodStartColor =
      const Color.fromRGBO(14, 190, 127, 1); //Colors.blue;
  Color selectedPeriodLastColor =
      const Color.fromRGBO(14, 190, 127, 1); //Colors.blue;
  Color selectedPeriodMiddleColor =
      const Color.fromRGBO(50, 250, 180, 0.8); //Colors.blue;//Colors.blue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedPeriodLastColor = const Color.fromRGBO(14, 190, 127, 1);
    selectedPeriodMiddleColor = const Color.fromRGBO(35, 234, 164, 1);
    selectedPeriodStartColor = const Color.fromRGBO(14, 190, 127, 1);
  }

  @override
  Widget build(BuildContext context) {
    //InitializareNumarPacientiWidget initPacienti = InitializareNumarPacientiWidget();

    // add selected colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
        selectedPeriodStartTextStyle:
            const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        selectedPeriodMiddleTextStyle:
            const TextStyle(color: Color.fromRGBO(78, 87, 133, 1)),
        selectedPeriodEndTextStyle:
            const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        selectedPeriodLastDecoration: const BoxDecoration(
          color: Color.fromRGBO(14, 190, 127, 1),
          shape: BoxShape.rectangle,

          //color: selectedPeriodLastColor,
          borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(24.0), bottomEnd: Radius.circular(24.0)),
        ),
        selectedSingleDateDecoration: const BoxDecoration(
          color: Color.fromRGBO(14, 190, 127, 1),

          //color: selectedPeriodStartColor,
          borderRadius: BorderRadiusDirectional.all(
            Radius.circular(24.0),
          ),
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

    return Column(
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
        SizedBox(
          // width: 400,
          // height: 350,
          child: NumarPacientiWidgets(
              listaConsultatiiMobileNumarPacienti:
                  widget.listaConsultatiiMobileNumarPacienti,
              startPerioada: _selectedPeriod.start,
              sfarsitPerioada: _selectedPeriod.end),
        ),
      ],
    );
  }

  // select background color for the first date of the selected period

  void _onSelectedDateChanged(DatePeriod newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
  }

  // ignore: prefer_expression_function_bodies
  bool _isSelectableCustom(DateTime day) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));
    bool isYesterday = sameDate(day, yesterday);
    bool isTomorrow = sameDate(day, tomorrow);

    return !isYesterday && !isTomorrow;
  }

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
bool sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
