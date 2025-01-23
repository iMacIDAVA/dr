import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/curriculum_vitae_edit/cv_services.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

class CVEditPage extends StatefulWidget {
  final ContMedicMobile contMedicMobile;
  const CVEditPage({super.key, required this.contMedicMobile});

  @override
  State<CVEditPage> createState() => _CVEditPageState();
}

class _CVEditPageState extends State<CVEditPage> {
  bool isUpdatingCV = false;
  CVServices cvServices = CVServices();
  // Adauga educatie
  List<EducatieMedic> listaEducatie = [];
  bool isAddingEducation = false;
  TextEditingController tipEducatieController = TextEditingController();
  TextEditingController descriereEducatieController = TextEditingController();
  // Date cv  locDeMunca, adresaLocDeMunca, specializare, titluProfesional, experienta
  TextEditingController locDeMuncaController = TextEditingController();
  TextEditingController adresaLocDeMuncaController = TextEditingController();
  TextEditingController specializareController = TextEditingController();
  TextEditingController titluProfesionalController = TextEditingController();
  TextEditingController experientaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    locDeMuncaController.text = widget.contMedicMobile.locDeMunca;
    adresaLocDeMuncaController.text = widget.contMedicMobile.adresaLocDeMunca;
    specializareController.text = widget.contMedicMobile.specializarea;
    titluProfesionalController.text = widget.contMedicMobile.titulatura;
    experientaController.text = widget.contMedicMobile.experienta;
    listaEducatie = widget.contMedicMobile.listaEducatie;
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          foregroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () async {
                // isUpdatingCV = true;
                // setState(() {});
                // var resp = await cvServices
                //     .actualizeazaCVContMedic(
                //         context,
                //         locDeMuncaController.text,
                //         adresaLocDeMuncaController.text,
                //         specializareController.text,
                //         titluProfesionalController.text,
                //         experientaController.text)
                //     .then((value) {
                //   isUpdatingCV = false;
                // });

                // setState(() {
                Navigator.pop(context, true);
                // });
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            l.setariProfilEditeazaCV,
            style: GoogleFonts.rubik(
                color: const Color.fromRGBO(255, 255, 255, 1), fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: titluProfesionalController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: l.setariProfilTitluProfestionalHint,
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  customDivider(),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: specializareController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: l.setariProfilSpecializareHint,
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  customDivider(),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: experientaController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: l.setariProfilExperientaHint,
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  customDivider(),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: locDeMuncaController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          //color: Color.fromRGBO(205, 211, 223, 1),
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: l.setariProfilDenumireLocDeMuncaHint,
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  customDivider(),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: adresaLocDeMuncaController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          //color: Color.fromRGBO(205, 211, 223, 1),
                          color: Colors.white,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: l.setariProfilAdresaLocDeMuncaHint,
                      labelStyle: const TextStyle(
                          color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  customDivider(),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () {
                        isAddingEducation = !isAddingEducation;
                        tipEducatieController.clear();
                        descriereEducatieController.clear();
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              //'Adaugă tip educație', //old IGV
                              l.setariProfilAdaugaTipEducatie,
                              style: GoogleFonts.rubik(
                                color: const Color.fromRGBO(111, 139, 164, 1),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              )),
                          !isAddingEducation
                              ? const Icon(
                                  Icons.add_circle,
                                  color: Color.fromRGBO(30, 214, 158, 1),
                                  size: 40.0,
                                )
                              : const Icon(
                                  Icons.remove_circle,
                                  color: Color.fromRGBO(30, 214, 158, 1),
                                  size: 40.0,
                                )
                        ],
                      ),
                    ),
                  ),
                  if (isAddingEducation)
                    Column(
                      children: [
                        TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: tipEducatieController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                //color: Color.fromRGBO(205, 211, 223, 1),
                                color: Colors.white,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: l.setariProfilTipEducatieHint,
                            labelStyle: const TextStyle(
                                color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        customDivider(),
                        TextFormField(
                          controller: descriereEducatieController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                //color: Color.fromRGBO(205, 211, 223, 1),
                                color: Colors.white,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            labelText: l.setariProfilInformatiiEducatieHint,
                            labelStyle: const TextStyle(
                                color: Color.fromRGBO(111, 139, 164, 1), fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        customDivider(),
                        GestureDetector(
                            onTap: () async {
                              if (tipEducatieController.text.isNotEmpty) {
                                var resp = await cvServices.adaugaEducatieMedic(
                                    context, tipEducatieController.text, descriereEducatieController.text, 1);
                                if (int.parse(resp!.body) == 200) {
                                  ContMedicMobile cont = await cvServices.getContMedicUpdate();
                                  listaEducatie = cont.listaEducatie;
                                }

                                tipEducatieController.clear();
                                descriereEducatieController.clear();
                                isAddingEducation = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(30, 214, 158, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text(
                                "Adaugă Educație",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ))
                      ],
                    ),
                  customDivider(),
                  if (listaEducatie.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: listaEducatie.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l.setariProfilTipEducatieHint,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(111, 139, 164, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        listaEducatie[index].tipEducatie!,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(111, 139, 164, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        l.setariProfilInformatiiEducatieHint,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(111, 139, 164, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        listaEducatie[index].informatiiSuplimentare!,
                                        style: const TextStyle(
                                            color: Color.fromRGBO(111, 139, 164, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      customDivider()
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var resp = await cvServices.stergeEducatieMedic(
                                              context, listaEducatie[index].id.toString());
                                          if (int.parse(resp!.body) == 200) {
                                            ContMedicMobile cont = await cvServices.getContMedicUpdate();
                                            listaEducatie = cont.listaEducatie;
                                          }
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showEditDialog(
                                            listaEducatie[index].tipEducatie!,
                                            listaEducatie[index].informatiiSuplimentare!,
                                            listaEducatie[index].id.toString(),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                  if (!isAddingEducation)
                    GestureDetector(
                      onTap: () async {
                        isUpdatingCV = true;
                        setState(() {});

                        var resp = await cvServices.actualizeazaCVContMedic(
                          context,
                          locDeMuncaController.text,
                          adresaLocDeMuncaController.text,
                          specializareController.text,
                          titluProfesionalController.text,
                          experientaController.text,
                        );

                        if (int.parse(resp!.body) == 200) {
                          setState(() {
                            isUpdatingCV = false;
                            Navigator.pop(context, true);
                          });
                        } else {
                          setState(() {
                            isUpdatingCV = false;
                          });
                        }
                      },
                      child: isUpdatingCV
                          ? const CircularProgressIndicator(
                              color: Color.fromRGBO(30, 214, 158, 1),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(30, 214, 158, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text(
                                    "SALVEAZĂ CV",
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showEditDialog(String tipEducatie, String informatiiEducatie, String id) {
    LocalizationsApp l = LocalizationsApp.of(context)!;
    TextEditingController tipEducatieController = TextEditingController(text: tipEducatie);
    TextEditingController informatiiEducatieController = TextEditingController(text: informatiiEducatie);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Modifică educație"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: tipEducatieController,
                    decoration: InputDecoration(
                      labelText: l.setariProfilTipEducatieHint,
                    ),
                  ),
                  TextFormField(
                    controller: informatiiEducatieController,
                    decoration: InputDecoration(labelText: l.setariProfilInformatiiEducatieHint),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Anulează"),
              ),
              GestureDetector(
                onTap: () async {
                  var resp = await cvServices.actualizeazaEducatieMedic(
                      context, id, tipEducatieController.text, informatiiEducatieController.text);
                  if (int.parse(resp!.body) == 200) {
                    ContMedicMobile cont = await cvServices.getContMedicUpdate();
                    listaEducatie = cont.listaEducatie;
                  }
                  ContMedicMobile cont = await cvServices.getContMedicUpdate();
                  listaEducatie = cont.listaEducatie;
                  Navigator.of(context).pop();

                  setState(() {});
                },
                child: const Text("Salvează"),
              ),
            ],
          );
        });
  }

  Divider customDivider() {
    return const Divider(
      thickness: 2,
      color: Color.fromRGBO(240, 242, 246, 1),
    );
  }
}
