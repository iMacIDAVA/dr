import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
import 'package:sos_bebe_profil_bebe_doctor/raspunde_intrebare_medic_screen.dart';
import 'package:intl/intl.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

class ChestionarScreen extends StatefulWidget {
  final ChestionarClientMobile chestionar;
  final VoidCallback onContinue;
  final String page;

  const ChestionarScreen({
    super.key,
    required this.chestionar, required this.onContinue, required this.page,
  });

  @override
  State<ChestionarScreen> createState() => _ChestionarScreenState();
}

class _ChestionarScreenState extends State<ChestionarScreen> {
  bool isChecked = false;
  bool isVisibleAlergicLaMedicament = false;
  String alergicLaMedicament = '';
  bool areFebra = false;
  bool tuseste = false;
  bool dificultatiRespiratorii = false;
  bool astenie = false;
  bool cefalee = false;
  bool dureriGat = false;
  bool greturiVarsaturi = false;
  bool diareeConstipatie = false;
  bool refuzAlimentatie = false;
  bool iritatiiPiele = false;
  bool nasInfundat = false;
  bool rinoree = false;

  String numePrenumeComplet = '';
  String prenumeComplet = '';

  String dataDeNastere = '';

  String greutate = '';

  @override
  initState() {
    super.initState();

    setState(() {
      if (widget.chestionar.numeCompletat.isNotEmpty) {
        numePrenumeComplet = '${widget.chestionar.prenumeCompletat} ${widget.chestionar.numeCompletat}';
        //controllerNumeComplet.text = chestionarInitial!.numeCompletat;
      }

      if (widget.chestionar.dataNastereCompletata.toString().isNotEmpty) {
        dataDeNastere = DateFormat("dd.MM.yyyy").format(widget.chestionar.dataNastereCompletata);
        //controllerDataNastere.text = chestionarInitial!.dataNastereCompletata.toString();
      }

      if (widget.chestionar.greutateCompletata.isNotEmpty) {
        greutate = widget.chestionar.greutateCompletata;
        //controllerGreutate.text = chestionarInitial!.greutateCompletata;
      }

      isVisibleAlergicLaMedicament = (widget.chestionar.listaRaspunsuri[0].raspunsIntrebare == '1') ? true : false;

      if (widget.chestionar.listaRaspunsuri[0].informatiiComplementare.isNotEmpty) {
        alergicLaMedicament = (widget.chestionar.listaRaspunsuri[0].raspunsIntrebare == '1')
            ? widget.chestionar.listaRaspunsuri[0].informatiiComplementare
            : '';

        //controllerAlergicLaMedicamentText.text = (chestionarInitial!.listaRaspunsuri[0].raspunsIntrebare == '1')? chestionarInitial!.listaRaspunsuri[0].informatiiComplementare : '';
      }

      areFebra = (widget.chestionar.listaRaspunsuri[1].raspunsIntrebare == '1') ? true : false;

      tuseste = (widget.chestionar.listaRaspunsuri[2].raspunsIntrebare == '1') ? true : false;

      dificultatiRespiratorii = (widget.chestionar.listaRaspunsuri[3].raspunsIntrebare == '1') ? true : false;

      astenie = (widget.chestionar.listaRaspunsuri[4].raspunsIntrebare == '1') ? true : false;

      cefalee = (widget.chestionar.listaRaspunsuri[5].raspunsIntrebare == '1') ? true : false;

      dureriGat = (widget.chestionar.listaRaspunsuri[6].raspunsIntrebare == '1') ? true : false;

      greturiVarsaturi = (widget.chestionar.listaRaspunsuri[7].raspunsIntrebare == '1') ? true : false;

      diareeConstipatie = (widget.chestionar.listaRaspunsuri[8].raspunsIntrebare == '1') ? true : false;

      refuzAlimentatie = (widget.chestionar.listaRaspunsuri[9].raspunsIntrebare == '1') ? true : false;

      iritatiiPiele = (widget.chestionar.listaRaspunsuri[10].raspunsIntrebare == '1') ? true : false;

      nasInfundat = (widget.chestionar.listaRaspunsuri[11].raspunsIntrebare == '1') ? true : false;

      rinoree = (widget.chestionar.listaRaspunsuri[12].raspunsIntrebare == '1') ? true : false;
    });

    /*

    isAlergic = widget.chestionar.listaRaspunsuri.where();
    areFebra = widget.areFebra;
    tuseste = widget.tuseste;
    dificultatiRespiratorii = widget.dificultatiRespiratorii;
    astenie = widget.astenie;
    cefalee = widget.cefalee;
    dureriGat = widget.dureriGat;
    greturiVarsaturi = widget.greturiVarsaturi;
    diareeConstipatie = widget.diareeConstipatie;
    refuzAlimentatie = widget.refuzAlimentatie;
    iritatiiPiele = widget.iritatiiPiele;
    nasInfundat = widget.nasInfundat;
    rinoree = widget.rinoree;

    */
  }

  void callbackIsAlergic(bool newIsAlergic) {
    setState(() {
      isVisibleAlergicLaMedicament = newIsAlergic;
      // ignore: avoid_print
      //print('is checked alergic: ' + isAlergic.toString());
    });
  }

  void callbackAreFebra(bool newAreFebra) {
    setState(() {
      areFebra = newAreFebra;
      // ignore: avoid_print
      //print('is checked febra: ' + areFebra.toString());
    });
  }

  void callbackTuse(bool newTuseste) {
    setState(() {
      tuseste = newTuseste;
      // ignore: avoid_print
      //print('is checked tuse: ' + tuseste.toString());
    });
  }

  void callbackRespiratie(bool newDificultatiRespiratorii) {
    setState(() {
      dificultatiRespiratorii = newDificultatiRespiratorii;
      // ignore: avoid_print
      //print('is checked dificultati respiratorii: ' + dificultatiRespiratorii.toString());
    });
  }

  void callbackAstenie(bool newAstenie) {
    setState(() {
      astenie = newAstenie;
      // ignore: avoid_print
      //print('is checked astenie: ' + astenie.toString());
    });
  }

  void callbackCefalee(bool newCefalee) {
    setState(() {
      cefalee = newCefalee;
      // ignore: avoid_print
      //print('is checked cefalee: ' + cefalee.toString());
    });
  }

  void callbackDureriGat(bool newDureriGat) {
    setState(() {
      dureriGat = newDureriGat;
      // ignore: avoid_print
      //print('is checked dureri gat: ' + dureriGat.toString());
    });
  }

  void callbackGreturiVarsaturi(bool newGreturiVarsaturi) {
    setState(() {
      greturiVarsaturi = newGreturiVarsaturi;
      // ignore: avoid_print
      //print('is checked greturi varsaturi: ' + greturiVarsaturi.toString());
    });
  }

  void callbackDiareeConstipatie(bool newDiareeConstipatie) {
    setState(() {
      diareeConstipatie = newDiareeConstipatie;
      // ignore: avoid_print
      //print('is checked diaree constipatie: ' + diareeConstipatie.toString());
    });
  }

  void callbackRefuzAlimentatie(bool newRefuzAlimentatie) {
    setState(() {
      refuzAlimentatie = newRefuzAlimentatie;
      // ignore: avoid_print
      //print('is checked refuz alimentatie: ' + refuzAlimentatie.toString());
    });
  }

  void callbackIritatiiPiele(bool newIritatiiPiele) {
    setState(() {
      iritatiiPiele = newIritatiiPiele;
      // ignore: avoid_print
      //print('is checked iritatii piele: ' + iritatiiPiele.toString());
    });
  }

  void callbackNasInfundat(bool newNasInfundat) {
    setState(() {
      nasInfundat = newNasInfundat;
      // ignore: avoid_print
      //print('is checked nas infundat: ' + nasInfundat.toString());
    });
  }

  void callbackRinoree(bool newRinoree) {
    setState(() {
      rinoree = newRinoree;
      // ignore: avoid_print
      //print('is checked rinoree: ' + rinoree.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
       onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
           
            const TopIconsTextWidget(),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    //Text('Nume și Prenume Pacient', style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)), //old IGV
                    Text(l.chestionarNumePrenumePacient,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(numePrenumeComplet,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w300)),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    //Text('Vârsta', style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)), //old IGV
                    //Text('Data de naștere', style: GoogleFonts.rubik(color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)), //old IGV
                    Text(
                        //l.chestionarVarsta,
                        l.chestionarDataDeNastere,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(dataDeNastere,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w300)),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Greutate', //old IGV
                        l.chestionarGreutate,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(greutate,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w300)),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Alergic la Paracetamol',  //old IGV
                        //l.chestionarAlergicLaMedicament, //old IGV
                        alergicLaMedicament,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                isVisibleAlergicLaMedicament
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomCheckBox(isChecked: isVisibleAlergicLaMedicament),
                          const SizedBox(width: 25),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 25),
                Text(
                    //'Simptome Pacient',  //old IGV
                    l.chestionarSimptomePacient,
                    style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Febră', old IGV
                        l.chestionarFebra,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: areFebra,
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Tuse', //old IGV
                        l.chestionarTuse,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: tuseste,
                    ), //onChecked: callbackTuse //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Dificultăți respiratorii',  //old IGV
                        l.chestionarDificultatiRespiratorii,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: dificultatiRespiratorii,
                    ), //onChecked: callbackRespiratie //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Astenie', //old IGV
                        l.chestionarAstenie,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: astenie,
                    ), // onChecked: callbackAstenie //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Cefalee',  old IGV
                        l.chestionarCefalee,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: cefalee,
                    ), //onChecked: callbackCefalee//old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Dureri în gât',
                        l.chestionarDureriInGat,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: dureriGat,
                    ), //onChecked: callbackDureriGat //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Grețuri/Vărsături',  //old IGV
                        l.chestionarGreturiVarsaturi,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: greturiVarsaturi,
                    ), //onChecked: callbackGreturiVarsaturi //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Diaree/Constipație', //old IGV
                        l.chestionarDiareeConstipatie,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: diareeConstipatie,
                    ), //onChecked: callbackDiareeConstipatie //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Iritații piele', //old IGV
                        l.chestionarIritatiiPiele,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: iritatiiPiele,
                    ), //onChecked: callbackIritatiiPiele //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Nas înfundat', //old IGV
                        l.chestionarNasInfundat,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: nasInfundat,
                    ), //onChecked: callbackNasInfundat //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 7),
            customPaddingChestionar(),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 25),
                    Text(
                        //'Rinoree', //old IGV
                        l.chestionarRinoree,
                        style: GoogleFonts.rubik(
                            color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomCheckBox(
                      isChecked: rinoree,
                    ), //onChecked: callbackRinoree //old IGV
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
            if (widget.page == "apel")
            SizedBox(
              width: 330,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  print("🟢 Button Clicked in ChestionarScreen");
                  widget.onContinue();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                    minimumSize: const Size.fromHeight(50), // NEW
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      //'CONTINUĂ CU APEL VIDEO', //old IGV
                      l.chestionarContinuaCuApelVideo,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (widget.page == "întrebare")
            SizedBox(
              width: 330,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  print("🟢 Button Clicked in ChestionarScreen");
                  widget.onContinue();
    
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) {
                  //     return const RaspundeIntrebareMedicScreen(
                  //       textNume: '',
                  //       textIntrebare: '',
                  //       textRaspuns: '',
                  //     );
                  //   }),
                  // );
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
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      //'RĂSPUNDE LA ÎNTREBARE', //old IGV
                      l.chestionarRaspundeLaIntrebare,
                      style: GoogleFonts.rubik(
                          color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopIconsTextWidget extends StatelessWidget {
  const TopIconsTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Column(
      children: [
        const SizedBox(height: 25),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     const SizedBox(width: 25),
        //     IconButton(
        //       onPressed: () => Navigator.pop(context),
        //       icon: Image.asset('./assets/images/inapoi_gri_icon.png'),
        //       color: const Color.fromRGBO(103, 114, 148, 1),
        //     ),
        //   ],
        // ),
            const SizedBox(height: 77),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 25),
            Text(
                //'Chestionar', //old IGV
                l.chestionarTitlu,
                style: GoogleFonts.rubik(
                    color: const Color.fromRGBO(103, 114, 148, 1), fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class CustomCheckBox extends StatefulWidget {
  final bool isChecked;

  final Function(bool)? onChecked;

  const CustomCheckBox({Key? key, required this.isChecked, this.onChecked}) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;

  @override
  initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.0,
      height: 16.0,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            isChecked = !isChecked;
            widget.onChecked!(isChecked);
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isChecked ? const Color.fromRGBO(30, 214, 158, 1) : const Color.fromRGBO(236, 238, 241, 1),
          shape: const CircleBorder(),
          side: BorderSide(
              width: 1.0,
              color: isChecked ? const Color.fromRGBO(30, 214, 158, 1) : const Color.fromRGBO(236, 238, 241, 1)),
        ),
        child: Text(
          '',
          style: TextStyle(
            color: isChecked ? const Color.fromRGBO(30, 214, 158, 1) : const Color.fromRGBO(236, 238, 241, 1),
            fontSize: 5,
          ),
        ),
      ),
    );
  }
}
