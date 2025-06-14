import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';

import 'package:flutter_switch/flutter_switch.dart';

class EditareProfilScreen extends StatefulWidget {
  const EditareProfilScreen({super.key});

  @override
  State<EditareProfilScreen> createState() => _EditareProfilScreenState();
}

class _EditareProfilScreenState extends State<EditareProfilScreen> {
  void callback(bool newIsVisible) {
    setState(() {
      isVisible = newIsVisible;
    });
  }

  bool isToggled = false;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:const Color.fromRGBO(30, 214, 158, 1),
      appBar: AppBar( 
        toolbarHeight: 90,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        leading:
          const BackButton(
            color: Colors.white,
          ),
        title:Row(
          children: [
            const SizedBox(width: 40),
            Text('Editare Profil',
                style: GoogleFonts.rubik(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
              ),  
          ],
        ),
        centerTitle: false,
      ),  
      body: 
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child:Column(
          children: [
            const SizedBox(height: 28),
            Center(
              child:IconButton(
              onPressed: () {},
              icon: Image.asset('./assets/images/daniela_preoteasa_meniu_profil.png'),
              ),
            ),
            Center(
              child:
              Text( 'Dr. Daniela Preoteasa',
                  style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 21, fontWeight: FontWeight.w500),
              ),
            ),
            Center(
              child:
              Text( 'AIS Clinics & Hospital București',
                  style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w300),
              ),
            ),
            Center(
              child:
              Text( 'Pediatrie, Medic Primar',
                  style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 9, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 65),
            const TexteLinie(textStanga:'User',textDreapta:'@Dr Daniela Preoteasa'),
            customPaddingProfilulMeu(),
            const TexteLinie(textStanga:'Email',textDreapta:'drdanielaperoteasa@gmail.com'),
            customPaddingProfilulMeu(),
            const IconTextCV(textLinie:'cv', iconCV: './assets/images/profil_navigare_icon.png'),
            customPaddingProfilulMeu(),
            TextAndSwitchWidget(isToggled: isVisible, text: "Notificari", callback: callback),
            const SizedBox(height: 60),
            Row (
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 352,
                  child: ElevatedButton(
                    onPressed: () {
                      //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                            //builder: (context) => const ServiceSelectScreen(),
                            //builder: (context) => const TestimonialScreen(),
                          //));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                        minimumSize: const Size.fromHeight(50), // NEW
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    child: const Text('Finalizare',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.bold,
                        color:Color.fromRGBO(255, 255, 255, 1),
                      )
                    ),
                  ),
                ),    
              ],
            ), 
          ],
        ),  
      ),
    );
  }
}

class TexteLinie extends StatelessWidget {
  
  final String textStanga;
  final String textDreapta;

  const TexteLinie({super.key, required this.textStanga, required this.textDreapta});

  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: [
        const SizedBox(
          height: 25
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width:15),
            SizedBox(
              width: 350,
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text( textStanga,
                    style: GoogleFonts.rubik(color: const Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                  ),            
                  Text( textDreapta,
                    style: GoogleFonts.rubik(color: const Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              ),    
            ),
          ],
        ),
        const SizedBox(
          height: 25
        ),
      ],
    );
  }
}

class IconTextCV extends StatelessWidget {
  
  final String textLinie;
  final String iconCV;

  const IconTextCV({super.key, required this.textLinie, required this.iconCV});

  @override
  Widget build(BuildContext context) {
    return
    Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width:15),
            SizedBox(
              width: 370,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Text( textLinie,
                    style: const TextStyle(color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(iconCV),
                  ),
                ],  
              ),
            ),  
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TextAndSwitchWidget extends StatefulWidget {
  bool isToggled;
  final Function(bool)? callback;
  final String text;
  TextAndSwitchWidget({super.key, required this.isToggled, required this.text, this.callback});

  @override
  State<TextAndSwitchWidget> createState() => _TextAndSwitchWidgetState();
}

class _TextAndSwitchWidgetState extends State<TextAndSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 25
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width:15),
            SizedBox(
              width: 350,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //Text(widget.disease, style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w400)), old

                  Text(widget.text, style: GoogleFonts.rubik(color: const Color.fromRGBO(59, 86, 110, 1), fontSize: 14, fontWeight: FontWeight.w400)),

                  FlutterSwitch(
                    value: widget.isToggled,
                    height: 20,
                    width: 40,

                    //activeColor: const Color.fromARGB(255, 103, 197, 108),

                    //added by George Valentin Iordache
                    activeColor: const Color.fromRGBO(30, 214, 158, 1),
                    
                    inactiveColor: Colors.grey[200]!,
                    onToggle: (value) {
                      if (widget.callback != null) {
                        setState(() {
                          widget.callback!(value);
                        });
                      } else {
                        setState(() {
                          widget.isToggled = value;
                          // ignore: avoid_print
                          print(widget.isToggled);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}