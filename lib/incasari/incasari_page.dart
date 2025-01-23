import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/incasari/incasari_service.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

class IncasariPage extends StatefulWidget {
  final List<TotaluriMedic> totaluriMedic;
  const IncasariPage({super.key, required this.totaluriMedic});

  @override
  State<IncasariPage> createState() => _IncasariPageState();
}

class _IncasariPageState extends State<IncasariPage> {
  //service
  IncasariService incasariService = IncasariService();
  //loading bool
  bool isDoneLoading = true;
  // bool for every chart category
  bool showZi = false;
  bool showSaptamana = false;
  bool showLuna = true;
  bool showAn = false;
  bool showCustomPicker = false;
  //moneda string
  String moneda = "";
  //
  bool selectedCustomOnce = false;
  //list for day/week/month/year/custom
  List<FlSpot> dayListSpot = [];
  double maxListDay = 0;
  List<FlSpot> weekListSpot = [];
  double maxListWeek = 0;
  List<FlSpot> monthListSpot = [];
  double maxListMonth = 0;
  List<FlSpot> yearListSpot = [];
  double maxListYear = 0;
  List<FlSpot> customListSpot = [];
  double maxListCustom = 0;

  bool showCustomCalendar = false;
  //date time variables
  DatePeriod _selectedPeriod = DatePeriod(DateTime.now(), DateTime.now());
  DateTime dateNow = DateTime.now();
  final DateTime _firstDate = DateTime.now().subtract(const Duration(days: 4050));
  final DateTime _lastDate = DateTime.now().add(const Duration(days: 365));
  //function to get data for every case
  void getData() async {
    setState(() {
      isDoneLoading = false;
    });
    List<dynamic> dayList = await incasariService.getIncasariZi();
    List<dynamic> weekList = await incasariService.getIncasariSaptamana();
    List<dynamic> monthList = await incasariService.getIncasariLuna();
    List<dynamic> yearList = await incasariService.getIncasariAn();

    dayListSpot = dayList[0];
    weekListSpot = weekList[0];
    monthListSpot = monthList[0];
    yearListSpot = yearList[0];
    maxListDay = dayList[1];
    maxListWeek = weekList[1];
    maxListMonth = monthList[1];
    maxListYear = yearList[1];
    setState(() {
      isDoneLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.totaluriMedic[0].moneda == 1) {
      moneda = 'ron';
    } else if (widget.totaluriMedic[0].moneda == 2) {
      moneda = 'euro';
    }
    getData();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset('./assets/images/sageata_stanga_icon.png'),
          ),
          title: Text(
            //'Încasări', //old IGV
            l.incasariFiltratIncasari,
            style: GoogleFonts.rubik(
                color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 24, fontWeight: FontWeight.w400),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 29),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 58,
                        width: 278,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(2, 3), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Container(
                          margin: const EdgeInsets.all(1),
                          padding: const EdgeInsets.all(5),
                          height: 56,
                          width: 139,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(30, 214, 158, 1),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  l.sumeIncasariFiltratSoldCurent,
                                  style: GoogleFonts.rubik(
                                      color: const Color.fromRGBO(255, 255, 255, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.totaluriMedic[0].totalIncasari.toStringAsFixed(2),
                                      style: GoogleFonts.rubik(
                                          color: const Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      moneda == 'lei'
                                          ? l.sumeIncasariFiltratLei
                                          : moneda == 'euro'
                                              ? l.sumeIncasariFiltratEuro
                                              : l.sumeIncasariFiltratLei,
                                      style: GoogleFonts.rubik(
                                          color: const Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(1),
                          height: 56,
                          width: 137,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  l.sumeIncasariFiltratDeIncasat,
                                  style: GoogleFonts.rubik(
                                      color: const Color.fromRGBO(30, 214, 158, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.totaluriMedic[0].totalDeIncasat.toStringAsFixed(2),
                                      style: GoogleFonts.rubik(
                                          color: const Color.fromRGBO(103, 114, 148, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      moneda == 'lei'
                                          ? l.sumeIncasariFiltratLei
                                          : moneda == 'euro'
                                              ? l.sumeIncasariFiltratEuro
                                              : l.sumeIncasariFiltratLei,
                                      style: GoogleFonts.rubik(
                                          color: const Color.fromRGBO(103, 114, 148, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 75, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showZi = true;
                              showSaptamana = false;
                              showLuna = false;
                              showAn = false;
                              showCustomPicker = false;
                              showCustomCalendar = true;

                              _selectedPeriod = DatePeriod(DateTime.now(), DateTime.now());

                              setState(() {});
                            },
                            child: Text(
                              //'Zi', //old IGV
                              l.lineChartIncasariZi,
                              style: GoogleFonts.rubik(
                                  color: showZi
                                      ? const Color.fromRGBO(103, 114, 148, 1)
                                      : const Color.fromRGBO(103, 114, 148, 1).withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showZi = false;
                              showSaptamana = true;
                              showLuna = false;
                              showAn = false;
                              showCustomPicker = false;
                              showCustomCalendar = true;

                              DateTime startOfWeek =
                                  DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
                              DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
                              _selectedPeriod = DatePeriod(startOfWeek, endOfWeek);

                              setState(() {});
                            },
                            child: Text(
                              //'Săptamana', //old IGV
                              l.lineChartIncasariSaptamana,
                              style: GoogleFonts.rubik(
                                  color: showSaptamana
                                      ? const Color.fromRGBO(103, 114, 148, 1)
                                      : const Color.fromRGBO(103, 114, 148, 1).withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showZi = false;
                              showSaptamana = false;
                              showLuna = true;
                              showAn = false;
                              showCustomPicker = false;
                              showCustomCalendar = true;

                              DateTime firstDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
                              DateTime lastDayOfMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                              _selectedPeriod = DatePeriod(firstDayOfMonth, lastDayOfMonth);

                              setState(() {});
                            },
                            child: Text(
                              //'Luna', //old IGV
                              l.lineChartIncasariLuna,
                              style: GoogleFonts.rubik(
                                  color: showLuna
                                      ? const Color.fromRGBO(103, 114, 148, 1)
                                      : const Color.fromRGBO(103, 114, 148, 1).withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showZi = false;
                              showSaptamana = false;
                              showLuna = false;
                              showAn = true;
                              showCustomPicker = true;

                              DateTime firstDayOfYear = DateTime(DateTime.now().year, 1, 1);
                              DateTime lastDayOfYear = DateTime(DateTime.now().year, 12, 31);
                              _selectedPeriod = DatePeriod(firstDayOfYear, lastDayOfYear);

                              setState(() {});
                            },
                            child: Text(
                              //'An', //old IGVP
                              l.lineChartIncasariAn,
                              style: GoogleFonts.rubik(
                                  color: showAn
                                      ? const Color.fromRGBO(103, 114, 148, 1)
                                      : const Color.fromRGBO(103, 114, 148, 1).withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              showZi = false;
                              showSaptamana = false;
                              showLuna = false;
                              showAn = false;
                              showCustomPicker = true;
                              showCustomCalendar = !showCustomCalendar;

                              setState(() {});
                            },
                            icon: Image.asset('./assets/images/calendar_incasari_icon.png'),
                          ),
                        ],
                      ),
                      if (!showCustomPicker)
                        isDoneLoading
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  color: Colors.white,
                                ),
                                child: LineChart(
                                  LineChartData(
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
                                    titlesData: const FlTitlesData(
                                      show: false,
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      topTitles: AxisTitles(
                                        sideTitles: SideTitles(showTitles: false),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: false,
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      //border: Border.all(color: const Color(0xff37434d,)), old
                                      border: Border.all(color: Colors.white),
                                    ),
                                    minX: 0,
                                    maxX: showZi
                                        ? dayListSpot.length.toDouble() - 1
                                        : showSaptamana
                                            ? weekListSpot.length.toDouble() - 1
                                            : showLuna
                                                ? monthListSpot.length.toDouble() - 1
                                                : showAn
                                                    ? yearListSpot.length.toDouble() - 1
                                                    : 0,
                                    minY: 0,
                                    maxY: (showZi
                                            ? maxListDay
                                            : showSaptamana
                                                ? maxListWeek
                                                : showLuna
                                                    ? maxListMonth
                                                    : showAn
                                                        ? maxListYear
                                                        : 0) *
                                        1.1,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: showZi
                                            ? dayListSpot
                                            : showSaptamana
                                                ? weekListSpot
                                                : showLuna
                                                    ? monthListSpot
                                                    : showAn
                                                        ? yearListSpot
                                                        : [],
                                        isCurved: true,
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
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: Color.fromRGBO(30, 214, 158, 1),
                              ),
                      if (showCustomPicker)
                        if (customListSpot.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Nu există încasări în perioada selectată."),
                          ),
                      if (showCustomPicker && customListSpot.length == 1)
                        // if (customListSpot.isEmpty && selectedCustomOnce)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                customListSpot[0].y.toString(),
                                style: const TextStyle(
                                    color: Color.fromRGBO(30, 214, 158, 1), fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                height: 15,
                                width: 15,
                                decoration:
                                    const BoxDecoration(color: Color.fromRGBO(30, 214, 158, 1), shape: BoxShape.circle),
                              )
                            ],
                          ),
                        ),
                      if (showCustomPicker)
                        if (selectedCustomOnce && customListSpot.length != 1)
                          isDoneLoading
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: LineChart(
                                    LineChartData(
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
                                      titlesData: const FlTitlesData(
                                        show: false,
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: false,
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(
                                        show: true,
                                        //border: Border.all(color: const Color(0xff37434d,)), old
                                        border: Border.all(color: Colors.white),
                                      ),
                                      minX: 0,
                                      maxX: customListSpot.length.toDouble() - 1,
                                      minY: 0,
                                      maxY: (maxListCustom) * 1.1,
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: customListSpot,
                                          isCurved: true,
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
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(
                                  color: Color.fromRGBO(30, 214, 158, 1),
                                ),
                      if (showCustomPicker)
                        if (showCustomCalendar)
                          RangePicker(
                            initiallyShowDate: DateTime.now(),
                            selectedPeriod: _selectedPeriod,
                            onChanged: _onSelectedDateChanged,
                            firstDate: _firstDate,
                            lastDate: _lastDate,
                            datePickerStyles: DatePickerRangeStyles(
                                selectedPeriodStartTextStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                                selectedPeriodMiddleTextStyle: const TextStyle(color: Color.fromRGBO(78, 87, 133, 1)),
                                selectedPeriodEndTextStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                                selectedPeriodLastDecoration: const BoxDecoration(
                                  color: Color.fromRGBO(14, 190, 127, 1),
                                  shape: BoxShape.rectangle,

                                  //color: selectedPeriodLastColor,
                                  borderRadius: BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(24.0), bottomEnd: Radius.circular(24.0)),
                                ),
                                selectedPeriodStartDecoration: const BoxDecoration(
                                  color: Color.fromRGBO(14, 190, 127, 1),

                                  //color: selectedPeriodStartColor,
                                  borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(24.0), bottomStart: Radius.circular(24.0)),
                                ),
                                selectedPeriodMiddleDecoration: const BoxDecoration(
                                  color: Color.fromRGBO(50, 250, 190, 0.6),
                                  //color: selectedPeriodMiddleColor,
                                  shape: BoxShape.rectangle,
                                ),
                                nextIcon: const Icon(Icons.arrow_right),
                                prevIcon: const Icon(Icons.arrow_left),
                                dayHeaderStyleBuilder: _dayHeaderStyleBuilder),
                            //selectableDayPredicate: _isSelectableCustom,
                            onSelectionError: _onSelectionError,
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _onSelectedDateChanged(DatePeriod newPeriod) async {
    _selectedPeriod = newPeriod;

    if (_selectedPeriod.start.day == _selectedPeriod.end.day &&
        _selectedPeriod.start.month == _selectedPeriod.end.month &&
        _selectedPeriod.start.year == _selectedPeriod.end.year) {
    } else {
      selectedCustomOnce = true;
      List<dynamic> customList = await incasariService.getIncasariCustom(newPeriod.start, newPeriod.end);
      customListSpot = customList[0];
      maxListCustom = customList[1];
    }

    setState(() {});
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

  DayHeaderStyle _dayHeaderStyleBuilder(int weekday) {
    return const DayHeaderStyle(textStyle: TextStyle(color: Color.fromRGBO(103, 114, 148, 1)));
  }
}
