
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

//import 'package:sos_bebe_profil_bebe_doctor/data_picker_widgets/color_selector_btn.dart';

/// Page with the [RangePicker].
class RangePickerPage extends StatefulWidget {
  /// Custom events.

  ///
  const RangePickerPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RangePickerPageState();
}

class _RangePickerPageState extends State<RangePickerPage> {

  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 3450));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365));

  DatePeriod _selectedPeriod = DatePeriod(
      DateTime.now().subtract(const Duration(days: 350)),
      DateTime.now().subtract(const Duration(days: 12)));

  Color selectedPeriodStartColor = const Color.fromRGBO(14, 190, 127, 1);//Colors.blue;
  Color selectedPeriodLastColor = const Color.fromRGBO(14, 190, 127, 1);//Colors.blue;
  Color selectedPeriodMiddleColor = const Color.fromRGBO(40, 240, 200, 0.8);//Colors.blue;//Colors.blue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //selectedPeriodLastColor = Theme.of(context).colorScheme.secondary;
    //selectedPeriodMiddleColor = Theme.of(context).colorScheme.secondary;
    //selectedPeriodStartColor = Theme.of(context).colorScheme.secondary;
    selectedPeriodLastColor = const Color.fromRGBO(14, 190, 127, 1);
    selectedPeriodMiddleColor = const Color.fromRGBO(35, 234, 164, 1);
    selectedPeriodStartColor = const Color.fromRGBO(14, 190, 127, 1);
  }

  @override
  Widget build(BuildContext context) {
    // add selected colors to default settings
    DatePickerRangeStyles styles = DatePickerRangeStyles(
        selectedPeriodLastDecoration: const BoxDecoration(
          color: Color.fromRGBO(14, 190, 127, 1),
            //IGV
            //borderRadius: BorderRadius.all(
            //    Radius.circular(24.0),
            //color: selectedPeriodLastColor,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(24.0),
              bottomEnd: Radius.circular(24.0)
            //)),
        )),
        selectedPeriodStartDecoration: const BoxDecoration(
          color: Color.fromRGBO(14, 190, 127, 1),
          //borderRadius: BorderRadius.all(
          //      Radius.circular(24.0),
          //),
          //IGV    
          //color: selectedPeriodStartColor,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(24.0),
              bottomStart: Radius.circular(24.0)),    
        ),
        selectedPeriodMiddleDecoration: const BoxDecoration(
            color: Color.fromRGBO(35, 234, 164, 1),
            //color: selectedPeriodMiddleColor, 
            shape: BoxShape.rectangle,
        ),
        nextIcon: const Icon(Icons.arrow_right),
        prevIcon: const Icon(Icons.arrow_left),
        dayHeaderStyleBuilder: _dayHeaderStyleBuilder);

    return Flex(
      direction: MediaQuery.of(context).orientation == Orientation.portrait
          ? Axis.vertical
          : Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: RangePicker(
            initiallyShowDate: DateTime.now(),
            selectedPeriod: _selectedPeriod,
            onChanged: _onSelectedDateChanged,
            firstDate: _firstDate,
            lastDate: _lastDate,
            datePickerStyles: styles,
            selectableDayPredicate: _isSelectableCustom,
            onSelectionError: _onSelectionError,
          ),
        ),
        Container(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*Text(
                  "Selected date styles",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                _stylesBlock(),*/
                _selectedBlock()
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Block with show information about selected date
  // and boundaries of the selected period.
  Widget _selectedBlock() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Text("Selected period boundaries:"),
            ),
            Text(_selectedPeriod.start.toString()),
            Text(_selectedPeriod.end.toString()),
          ]),
        ],
      );

  // select background color for the first date of the selected period

  void _onSelectedDateChanged(DatePeriod newPeriod) {
    setState(() {
      _selectedPeriod = newPeriod;
    });
  }

  // ignore: prefer_expression_function_bodies
  bool _isSelectableCustom(DateTime day) {
    print('_isSelectableCustom: $day');
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime tomorrow = now.add(const Duration(days: 1));
    bool isYesterday = sameDate(day, yesterday);
    bool isTomorrow = sameDate(day, tomorrow);

    return !isYesterday && !isTomorrow;

    // return true;
//    return day.weekday < 6;
//    return day.day != DateTime.now().add(Duration(days: 7)).day ;
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
    bool isWeekend = weekday == 0 || weekday == 6;

    return DayHeaderStyle(
        textStyle: TextStyle(color: isWeekend ? Colors.red : Colors.teal));
  }
}

/// Only check the date part and not the time
bool sameDate(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;