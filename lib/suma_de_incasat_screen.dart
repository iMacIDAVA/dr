import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

class SumaIncasatScreen extends StatefulWidget {
  final TotaluriMedic totaluriDashboardMedic;

  final List<IncasareMedic> listaTranzactiiMedicPePerioada;

  const SumaIncasatScreen(
      {super.key, required this.totaluriDashboardMedic, required this.listaTranzactiiMedicPePerioada});

  @override
  State<SumaIncasatScreen> createState() => _SumaIncasatScreenState();
}

class _SumaIncasatScreenState extends State<SumaIncasatScreen> {
  static const ron = EnumTipMoneda.lei;
  static const euro = EnumTipMoneda.euro;

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    List<Widget> widgetsTranzactii = [];
    //List<NumarPacientiItem> listaFiltrata = filterListByLowerDurata(25);
    //List<NumarPacientiItem> listaFiltrata = filterListByLowerData(DateTime.utc(2023, 2, 1));
    //List<NumarPacientiItem> listaFiltrata = filterListByHigherData(DateTime.utc(2023, 1, 8));
    //List<ConsultatiiMobile> listaFiltrata = filterListByIntervalData(DateTime.utc(2021, 11, 9), DateTime.utc(2023, 3, 14));
    List<IncasareMedic> listaFiltrata = widget.listaTranzactiiMedicPePerioada;

    final length = listaFiltrata.length;
    int i = 0;

    for (var item in listaFiltrata) {
      //if (index < listaFiltrata.length-1)
      //{
      String dataFormat = DateFormat('dd MMMM, yyyy', l.sumaDeIncasatLanguage).format(item.dataIncasare);
      String dataFormatLuna =
          dataFormat.substring(0, 3) + dataFormat.substring(3, 4).toUpperCase() + dataFormat.substring(4);
      i++;
      if (i == length) {
        widgetsTranzactii.add(
          IconNumeDataSuma(
            textNume: item.numeCompletPacient,
            iconPath: item.linkPozaProfil,
            textData: dataFormatLuna,
            textSuma:
                '${item.totalIncasat} ${widget.totaluriDashboardMedic.moneda == ron.value ? l.sumaDeIncasatLei : widget.totaluriDashboardMedic.moneda == euro.value ? l.sumaDeIncasatEuro : l.sumaDeIncasatLei}',
            //'230 lei',
          ),
          //textDurata: '10:00 AM - 10:30 AM (30 min)'),
        );
      } else {
        widgetsTranzactii.add(
          IconNumeDataSuma(
            textNume: item.numeCompletPacient,
            iconPath: item.linkPozaProfil,
            textData: dataFormatLuna,
            textSuma:
                '${item.totalIncasat} ${widget.totaluriDashboardMedic.moneda == ron.value ? l.sumaDeIncasatLei : widget.totaluriDashboardMedic.moneda == euro.value ? l.sumaDeIncasatEuro : l.sumaDeIncasatLei}',
            //'230 lei',
          ),
        );

        /*
          widgetsTranzactii.add(
            IconNumeDataSuma(textNume: item.numeCompletPacient,
              iconPath:item.linkPozaProfil, textData: '14 August, 2023', textSuma: '230 lei',
            ),
            //textDurata: '10:00 AM - 10:30 AM (30 min)'),
          );
          */

        widgetsTranzactii.add(
          const SizedBox(height: 10),
        );
      }
      //}
      /*else
      {
        widgetsTranzactii.add(
          FadingListViewWidget(textNume: listaFiltrata[index].numeCompletClient, textOras: listaFiltrata[index].adresa, iconPath:listaFiltrata[index].linkPozaProfil,
            textDurata: '10:00 AM - 10:30 AM (30 min)'),
        );
        widgetsTranzactii.add(
          const SizedBox(height: 10),
        );
      }
      */
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 285,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                color: const Color.fromRGBO(255, 255, 255, 1),
                icon: Image.asset('./assets/images/inapoi_alb_icon.png'),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        //'Încasări', //old IGV
                        l.sumaDeIncasatIncasari,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset('./assets/images/incasari_appbar_transparent.png'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    //'SOLD CURENT - ' //AUGUST', //old IGV
                    l.sumaDeIncasatSoldCurent + DateFormat.MMMM(l.sumaDeIncasatLanguage).format(DateTime.now()).toUpperCase(),
                    style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1).withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    //'4580.00', //old IGV
                    widget.totaluriDashboardMedic.totalIncasari.toString(),
                    style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1), fontSize: 48, fontWeight: FontWeight.w500),
                  ),
                  // Column(
                  //   children:[
                  //     const SizedBox(height:26),
                  //     Text(
                  //       //'lei' //old IGV
                  //       widget.totaluriDashboardMedic.moneda == ron.value? l.sumaDeIncasatLei: widget.totaluriDashboardMedic.moneda == euro.value?l.sumaDeIncasatEuro:l.sumaDeIncasatLei,
                  //       style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 20, fontWeight: FontWeight.w500),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
          //],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            TopTextIconWidget(
              topText:
                  //'Tranzacții' //old IGV
                  l.sumaDeIncasatTranzactii,
            ),
            const SizedBox(height: 15),
            Center(
              child: Column(
                children: widgetsTranzactii,
                //[
                /*
                  IconNumeDataSuma(textNume: "Cristina Mihalache",
                    iconPath:'./assets/images/cristina_mihalache_sume_transparent.png', textData: '14 August, 2023', textSuma: '230 lei',
                  ),
                  SizedBox(height: 15),
                  IconNumeDataSuma(textNume: "Cristina Mihalache",
                    iconPath:'./assets/images/cristina_mihalache_sume_transparent.png', textData: '14 August, 2023', textSuma: '230 lei',
                  ),
                  SizedBox(height: 15),
                  IconNumeDataSuma(textNume: "Cristina Mihalache",
                    iconPath:'./assets/images/cristina_mihalache_sume_transparent.png', textData: '14 August, 2023', textSuma: '230 lei',
                  ),
                  SizedBox(height: 15),
                  FadingListViewWidget(textNume: "Cristina Mihalache",
                    iconPath:'./assets/images/cristina_mihalache_sume_transparent.png', textData: '14 August, 2023', textSuma: '230 lei',
                  ),
                  */
                //],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FadingListViewWidget extends StatelessWidget {
  final String iconPath;
  final String textNume;
  final String textData;
  final String textSuma;

  const FadingListViewWidget(
      {super.key, required this.textNume, required this.iconPath, required this.textData, required this.textSuma});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.transparent, Colors.transparent, Colors.white],
            //stops: [0.0, 0.1, 0.9, 1.0], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return IconNumeDataSuma(iconPath: iconPath, textNume: textNume, textData: textData, textSuma: textSuma);
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TopTextIconWidget extends StatelessWidget {
  final String topText;

  const TopTextIconWidget({super.key, required this.topText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(topText,
              style: GoogleFonts.rubik(
                  color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 16, fontWeight: FontWeight.w500)),

          // Row(
          //   children: [
          //     IconButton(
          //       onPressed: () {},
          //       icon: Image.asset('./assets/images/top_icon_suma_de_incasat.png'),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class IconNumeDataSuma extends StatefulWidget {
  final String iconPath;
  final String textNume;
  final String textSuma;
  final String textData;

  const IconNumeDataSuma(
      {super.key, required this.iconPath, required this.textNume, required this.textData, required this.textSuma});

  @override
  State<IconNumeDataSuma> createState() => _IconNumeDataSuma();
}

class _IconNumeDataSuma extends State<IconNumeDataSuma> {
  //double? _ratingValue = 4.9;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0 , right: 20.0 , top: 5 , bottom: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xff0EBE7F), // Uniform color for all sides
            width: 0,
          ),
          gradient: const LinearGradient(
            colors: [
              Color(0xff0EBE7F),
              Color(0xff0EBE7F),
              Colors.white,
              Colors.white,
            ],
            stops: [0.0, 0.02, 0.02, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
                  child: widget.iconPath.isNotEmpty
                      ? Image.network(
                          widget.iconPath,
                        )
                      : Image.asset(
                          './assets/images/user_fara_poza.png',
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.textNume,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff677294),
                      ),
                    ),
                    Text(
                      widget.textData,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff677294),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(
              widget.textSuma,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xff0EBE7F),
              ),
            )
          ],
        ),
      ),
    );
  }
}
