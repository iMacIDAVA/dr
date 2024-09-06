import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class TermeniSiConditiiScreen extends StatelessWidget {
  const TermeniSiConditiiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        //leading:

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IconButton(
            //   onPressed: () {},
            //   icon: Image.asset('./assets/images/menu_icon_top_leading.png'),
            // ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            //Text('Termeni și condiții', //old IGV
            Text(
              l.termeniSiConditiiTitlu,
              style: GoogleFonts.rubik(
                  color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.28),
          ],
        ),
        centerTitle: false,
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
            children: [
              const SizedBox(height: 30),
              Row(
                children: [
                  const SizedBox(width: 55),
                  Row(
                    children: [
                      SizedBox(
                        width: 280,
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
                              minimumSize: const Size.fromHeight(40), // NEW
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          //child: const Text('Ultima actualizare : 27 / 03 / 2023', //old IGV
                          child: Text(l.termeniSiConditiiUltimaActualizare,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(255, 255, 255, 1),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 55),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: 355,
                child: AutoSizeText.rich(
                  // old value RichText(
                  TextSpan(
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(111, 139, 164, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    children: <TextSpan>[
                      //TextSpan(text: 'Vivamus ex felis, ullamcorper ac metus ac, finibus egestas nibh. Donec at mattis lacus. Duis cursus orci a convallis condimentum. Phasellus gravida felis leo.'), //old IGV
                      TextSpan(text: l.termeniSiConditiiTextCentral1),
                    ],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: 355,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("• ",
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(30, 214, 158, 1),
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        )),
                    SizedBox(
                      width: 280,
                      child: AutoSizeText.rich(
                        // old value RichText(
                        TextSpan(
                          style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(111, 139, 164, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          children: <TextSpan>[
                            //TextSpan(text: 'Donec molestie ultricies dolor, nec feugiat tellus laoreet ac praesent eu quam.'), //old IGV
                            TextSpan(text: l.termeniSiConditiiTextCentral2),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: 355,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("• ",
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(30, 214, 158, 1),
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        )),
                    SizedBox(
                      width: 280,
                      child: AutoSizeText.rich(
                        // old value RichText(
                        TextSpan(
                          style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(111, 139, 164, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          children: <TextSpan>[
                            //TextSpan(text: 'Maecenas pharetra ligula sed consequat imperdiet. Integer rhoncus sed nisl vitae.'), //old IGV
                            TextSpan(text: l.termeniSiConditiiTextCentral3),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: 355,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("• ",
                        style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(30, 214, 158, 1),
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                        )),
                    SizedBox(
                      width: 280,
                      child: AutoSizeText.rich(
                        // old value RichText(
                        TextSpan(
                          style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(111, 139, 164, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                          children: <TextSpan>[
                            //TextSpan(text: 'Donec commodo gravida risus, ac volutpat mauris tristique interdum.'), //old IGV
                            TextSpan(text: l.termeniSiConditiiTextCentral4),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                width: 355,
                child: AutoSizeText.rich(
                  // old value RichText(
                  TextSpan(
                    style: GoogleFonts.rubik(
                      color: const Color.fromRGBO(111, 139, 164, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    children: <TextSpan>[
                      //TextSpan(text: 'Vestibulum consequat massa aliquet, porttitor sapien ut, gravida tortor. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.'), //old IGV
                      TextSpan(text: l.termeniSiConditiiTextCentral5),
                    ],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 25),
              //FadingListViewWidget(text:'Vivamus ex felis, ullamcorper ac metus ac, finibus egestas nibh. Donec at mattis lacus. Duis cursus orci a convallis condimentum. Phasellus gravida felis leo. Fusce mollis auctor tincidunt. Vestibulun consequat massa aliquet, porttitor sapien ut, gravida tortor.'),
              //const FadingContainerWidget(text:'Vivamus ex felis, ullamcorper ac metus ac, finibus egestas nibh. Donec at mattis lacus. Duis cursus orci a convallis condimentum. Phasellus gravida felis leo. Fusce mollis auctor tincidunt. Vestibulun consequat massa aliquet, porttitor sapien ut, gravida tortor.'), //old IGV
              FadingContainerWidget(text: l.termeniSiConditiiTextCentral6),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class FadingListViewWidget extends StatelessWidget {

  final String text;

  const FadingListViewWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        width: 347,
        child: ShaderMask(
          shaderCallback: (Rect rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.white],
              //stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
            ).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: Text(
            text,
            style: GoogleFonts.rubik(
              color: const Color.fromRGBO(111, 139, 164, 1),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
            softWrap: true,
            overflow: TextOverflow.fade, //Overflow breaks on first line, even if softWrap = true.
            textAlign: TextAlign.left,
            maxLines: 5,
          ),
          /*child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                text,
                style: GoogleFonts.rubik(
                  color: const Color.fromRGBO(111, 139, 164, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                softWrap: true,
                overflow: TextOverflow.fade, //Overflow breaks on first line, even if softWrap = true.
                textAlign: TextAlign.left,
                maxLines: 5,
              );
            },
          ),
          */
        ),
      ),
    );
  }
  */
class FadingContainerWidget extends StatelessWidget {
  final String text;

  const FadingContainerWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: AutoSizeText.rich(
        // old value RichText(
        TextSpan(
            text: text,
            style: GoogleFonts.rubik(
              //color: const Color.fromRGBO(14, 210, 62, 1), old
              color: const Color.fromRGBO(111, 139, 164, 1),
              // fontSize: 32, old
              fontSize: 14,
              fontWeight: FontWeight.w300,
            )),
        maxLines: 6,
        softWrap: true,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.start,
      ),
      /*
        Text(
          text,
          style: GoogleFonts.rubik(
            color: const Color.fromRGBO(111, 139, 164, 1),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          softWrap: true,
          overflow: TextOverflow.fade, //Overflow breaks on first line, even if softWrap = true.
          textAlign: TextAlign.left,
          maxLines: 5,
        ),
        */
    );
  }
}
