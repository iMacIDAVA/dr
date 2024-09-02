
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
//import 'package:sos_bebe_profil_bebe_doctor/initializare_rating_screen.dart';
//import 'package:sos_bebe_profil_bebe_doctor/rating_widgets_screen.dart';

//import 'package:sos_bebe_profil_bebe_doctor/data_picker_widgets/color_selector_btn.dart';


import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';


/// Page with the [RangePicker].
class SumeIncasariFiltrat extends StatefulWidget {
  
  final double sumaSoldCurent;
  final double sumaDeIncasat;
  final int moneda;

  final Function(bool)? callbackSumeDeIncasat;


  ///
  const SumeIncasariFiltrat({Key? key, required this.sumaSoldCurent, required this.sumaDeIncasat, required this.moneda, required this.callbackSumeDeIncasat}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _SumeIncasariFiltratState();

}

class _SumeIncasariFiltratState extends State<SumeIncasariFiltrat> {


  static const ron = EnumTipMoneda.lei;
  static const euro = EnumTipMoneda.euro;

  @override
  Widget build(BuildContext context) {

    LocalizationsApp l = LocalizationsApp.of(context)!;

    //InitializareRatingsWidget initPacienti = InitializareRatingsWidget();

    return 
    SizedBox( 
      height: 80.0,
      width: 300.0,
      child:
      Stack(
        children: [
          Positioned(
            left: 145,
            top: 5,  
            child: SizedBox(
              width: 150,
              height: 65,
              child: ElevatedButton(
                onPressed: () {

                  widget.callbackSumeDeIncasat!(true);
                  //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                        //builder: (context) => const ServiceSelectScreen(),
                        //builder: (context) => const TestimonialScreen(),
                      //));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                    minimumSize: const Size.fromHeight(40), // NEW
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [ 
                        //Text('De încasat', //old IGV
                        Text(l.sumeIncasariFiltratDeIncasat,
                          style: GoogleFonts.rubik(color: const Color.fromRGBO(30, 214, 158, 1), fontSize: 14, fontWeight: FontWeight.w500),),
                      ],
                    ),    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.sumaDeIncasat.toStringAsFixed(2),
                        style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 14, fontWeight: FontWeight.w500),),
                        Column( 
                          children: [
                            //Text(' lei', //old IGV
                            Text(widget.moneda == ron.value? l.sumeIncasariFiltratLei:widget.moneda == euro.value?l.sumeIncasariFiltratEuro:l.sumeIncasariFiltratLei,
                              style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 14, fontWeight: FontWeight.w500),),
                          ],
                        ),    
                      ],
                    ),
                  ],    
                ),
              ),
            ),
          ),
          Positioned(
            left: 5,
            top: 5, 	
            child: SizedBox(
              width: 150,
              height: 65,
              child: ElevatedButton(
                onPressed: () {

                  widget.callbackSumeDeIncasat!(false);
                  
                  //Navigator.push(
                      //context,
                      //MaterialPageRoute(
                        //builder: (context) => const ServiceSelectScreen(),
                        //builder: (context) => const TestimonialScreen(),
                      //));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                    minimumSize: const Size.fromHeight(40), // NEW
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text('Sold curent', //old IGV
                        Text(l.sumeIncasariFiltratSoldCurent,
                          style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.sumaSoldCurent.toStringAsFixed(2),
                        style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 14, fontWeight: FontWeight.w500),),
                        Column( 
                          children: [ 
                            //const SizedBox(height: 4),
                            //Text(' lei', //old IGV
                            Text(widget.moneda == ron.value? l.sumeIncasariFiltratLei:widget.moneda == euro.value?l.sumeIncasariFiltratEuro:l.sumeIncasariFiltratLei,
                              style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 14, fontWeight: FontWeight.w500),),
                          ],
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
    );    
  }
}