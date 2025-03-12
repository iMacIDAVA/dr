import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:auto_size_text/auto_size_text.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';
//import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
//import 'package:sos_bebe_profil_bebe_doctor/rating_widgets_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/range_picker_rating_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class RatingFiltratScreen extends StatefulWidget {
  const RatingFiltratScreen({super.key, required this.listaRecenziiByMedicRating});

  final List<RecenzieMobile> listaRecenziiByMedicRating;

  @override
  State<RatingFiltratScreen> createState() => _RatingFiltratScreenState();
}

class _RatingFiltratScreenState extends State<RatingFiltratScreen> {
  @override
  void initState() {
    // Do some other stuff
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset('./assets/images/inapoi_icon.png'),
        ),
      ),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              //child: Text('Alege perioada', style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 28, fontWeight: FontWeight.w400)), //old IGV
              child: Text(l.ratingFiltratAlegePerioada,
                  style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 26, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 35),
            //const RangePickerPage(),
            SizedBox(
              width: 390,
              child: RangePickerRatingFiltrat(
                listaRecenziiByMedicRating: widget.listaRecenziiByMedicRating,
                  onDateSelected: (DateTime start, DateTime end) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String user = prefs.getString('user') ?? '';
                    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

                    String startDate = DateFormat('ddMMyyyy').format(start);
                    String endDate = DateFormat('ddMMyyyy').format(end);

                    List<RecenzieMobile>? filteredList = await apiCallFunctions.getListaRecenziiByMedicPePerioada(
                      pUser: user,
                      pParola: userPassMD5,
                      pDataInceputDDMMYYYY: startDate,
                      pDataSfarsitDDMMYYYY: endDate,
                    );


                    print("Filtered ${filteredList?.length ?? 0} reviews from $startDate to $endDate");

                    if (filteredList != null && filteredList.isNotEmpty) {
                      print("First filtered review: ID=${filteredList[0].id}, Name=${filteredList[0].identitateClient}");

                      setState(() {
                        widget.listaRecenziiByMedicRating.clear();
                        widget.listaRecenziiByMedicRating.addAll(filteredList);
                      });
                    } else {
                      print("No ratings found for the selected period.");

                      setState(() {
                        widget.listaRecenziiByMedicRating.clear();
                      });
                    }
                  }

              ),
            ),

          ],
        ),
      ),
    );
  }
}
