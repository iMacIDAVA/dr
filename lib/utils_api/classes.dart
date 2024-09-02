import 'package:flutter/material.dart';

class ContClientMobile {
  final int id;
  final String nume;
  final String prenume;
  final String email;
  final String telefon;
  final String user;
  String? linkPozaProfil;
  final int tipPersoana;
  final String codFiscal;
  final String denumireFirma;
  final String nregCom;
  final String seriecAct;
  final String numarAct;
  final String cnp;
  final int idJudet;
  final int idLocalitate;
  final String denumireJudet;
  final String denumireLocalitate;
  final String adresa1;

  ContClientMobile({
    required this.id,
    required this.nume,
    required this.prenume,
    required this.email,
    required this.telefon,
    required this.user,
    linkPozaProfil,
    required this.tipPersoana,
    required this.codFiscal,
    required this.denumireFirma,
    required this.nregCom,
    required this.seriecAct,
    required this.numarAct,
    required this.cnp,
    required this.idJudet,
    required this.idLocalitate,
    required this.denumireJudet,
    required this.denumireLocalitate,
    required this.adresa1,
  });

  factory ContClientMobile.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'Id': int id,
        'Nume': String nume,
        'Prenume': String prenume,
        'Email': String email,
        'Telefon': String telefon,
        'User': String user,
        'LinkPozaProfil': String linkPozaProfil,
        'TipPersoana': int tipPersoana,
        'CodFiscal': String codFiscal,
        'DenumireFirma': String denumireFirma,
        'NrRegCom': String nrRegCom,
        'SerieAct': String serieAct,
        'NumarAct': String numarAct,
        'CNP': String cnp,
        'IdJudet': int idJudet,
        'IdLocalitate': int idLocalitate,
        'DenumireJudet': String denumireJudet,
        'DenumireLocalitate': String denumireLocalitate,
        'AdresaLinie1': String adresaLinie1,
      } =>
        ContClientMobile(
            id: id,
            nume: nume,
            prenume: prenume,
            email: email,
            telefon: telefon,
            user: user,
            linkPozaProfil: linkPozaProfil,
            tipPersoana: tipPersoana,
            codFiscal: codFiscal,
            denumireFirma: denumireFirma,
            nregCom: nrRegCom,
            seriecAct: serieAct,
            numarAct: numarAct,
            cnp: cnp,
            idJudet: idJudet,
            idLocalitate: idLocalitate,
            denumireJudet: denumireJudet,
            denumireLocalitate: denumireLocalitate,
            adresa1: adresaLinie1),
      _ => throw ('Utilizatorul nu există')
    };
  }
}

class RecenzieMobile {
  final int id;
  final double rating;
  final String identitateClient;
  final DateTime dataRecenzie;
  final String comentariu;
  final String linkPozaProfil;
  final String raspuns;

  const RecenzieMobile({
    required this.id,
    required this.rating,
    required this.identitateClient,
    required this.dataRecenzie,
    required this.comentariu,
    required this.linkPozaProfil,
    required this.raspuns,
  });

  factory RecenzieMobile.fromJson(Map<String, dynamic> json) {
    print('RecenzieMobile.fromJson $json');

    return RecenzieMobile(
      id: json['ID'] as int,
      rating: json['Rating'] as double,
      identitateClient: json['IdentitateClient'] as String,
      //dataRecenzie: json['DataRecenzie'] as DateTime,
      dataRecenzie: DateTime.parse(json['DataRecenzie'].toString()),
      comentariu: json['Comentariu'] as String,
      linkPozaProfil: json['LinkPozaProfil'] as String,
      raspuns: json['Raspuns'] as String,
    );
  }
}

class ChestionarClientMobile {
  final String numeCompletat;
  final String prenumeCompletat;
  final DateTime dataNastereCompletata;
  final String greutateCompletata;
  final List<RaspunsIntrebareChestionarClientMobile> listaRaspunsuri;

  const ChestionarClientMobile({
    required this.numeCompletat,
    required this.prenumeCompletat,
    required this.dataNastereCompletata,
    required this.greutateCompletata,
    required this.listaRaspunsuri,
  });

  factory ChestionarClientMobile.fromJson(Map<String, dynamic> json) {
    print('ChestionarClientMobile.fromJson $json');

    return ChestionarClientMobile(
      numeCompletat: json['NumeCompletat'] ?? '',
      prenumeCompletat: json['PrenumeCompletat'] ?? '',
      dataNastereCompletata:
          DateTime.parse(json['DataNastereCompletata'].toString()),
      greutateCompletata: json['GreutateCompletata'] ?? '',
      listaRaspunsuri: List<dynamic>.from(json['ListaRaspunsuri'])
          .map((i) => RaspunsIntrebareChestionarClientMobile.fromJson(i))
          .toList(),
    );
  }
}

class RaspunsIntrebareChestionarClientMobile {
  final int idIntrebare;
  final String raspunsIntrebare;
  final String informatiiComplementare;

  const RaspunsIntrebareChestionarClientMobile({
    required this.idIntrebare,
    required this.raspunsIntrebare,
    required this.informatiiComplementare,
  });

  factory RaspunsIntrebareChestionarClientMobile.fromJson(
      Map<String, dynamic> json) {
    print('MesajConversatieMobile.fromJson $json');

    return RaspunsIntrebareChestionarClientMobile(
      idIntrebare: json['IdIntrebare'] as int,
      raspunsIntrebare: json['RaspunsIntrebare'] as String,
      informatiiComplementare: json['InformatiiComplementare'] as String,
    );
  }
}

class ContMedicMobile {
  final int id;
  final String numeComplet;
  final String cnp;
  final String email;
  final String telefon;
  final int stareCont;
  final String linkPozaProfil;
  final String titulatura;
  final String locDeMunca;
  final String functia;
  final String specializarea;
  final String adresaLocDeMunca;
  final String experienta;
  final bool esteActiv;
  final bool primesteIntrebari;
  final bool interpreteazaAnalize;
  final bool permiteConsultVideo;
  final List<EducatieMedic> listaEducatie;
  final double soldCurent;
  final int monedaSold;
  final String channelName;

  const ContMedicMobile({
    required this.id,
    required this.numeComplet,
    required this.cnp,
    required this.email,
    required this.telefon,
    required this.stareCont,
    required this.linkPozaProfil,
    required this.titulatura,
    required this.locDeMunca,
    required this.functia,
    required this.specializarea,
    required this.adresaLocDeMunca,
    required this.experienta,
    required this.esteActiv,
    required this.primesteIntrebari,
    required this.interpreteazaAnalize,
    required this.permiteConsultVideo,
    required this.listaEducatie,
    required this.soldCurent,
    required this.monedaSold,
    required this.channelName,
  });

  factory ContMedicMobile.fromJson(Map<String, dynamic> json) {
    print('ContMedicMobile.fromJson $json');

    return ContMedicMobile(
      id: json['Id'] ?? 0, //as int,
      numeComplet: json['NumeComplet'] ?? '', // as String,
      cnp: json['CNP'] ?? '' as String,
      email: json['Email'] ?? '' as String,
      telefon: json['Telefon'] ?? '' as String,
      stareCont: json['StareCont'] ?? 0 as int,
      linkPozaProfil: json['LinkPozaProfil'] ?? '' as String,
      titulatura: json['Titulatura'] ?? '' as String,
      locDeMunca: json['LocDeMunca'] ?? '' as String,
      functia: json['Functia'] ?? '' as String,
      specializarea: json['Specializarea'] ?? '' as String,
      adresaLocDeMunca: json['AdresaLocDeMunca'] ?? '' as String,
      experienta: json['Experienta'] ?? '' as String,
      esteActiv: json['EsteActiv'] ?? false as bool,
      primesteIntrebari: json['PrimesteIntrebari'] ?? false as bool,
      interpreteazaAnalize: json['InterpreteazaAnalize'] ?? false as bool,
      permiteConsultVideo: json['PermiteConsultVideo'] ?? false as bool,
      listaEducatie: (json['Id'] as int != 0)
          ? List<dynamic>.from(json['ListaEducatie'] ?? '')
              .map((i) => EducatieMedic.fromJson(i))
              .toList()
          : [],
      soldCurent: json['SoldCurent'] ?? 0.0 as double,
      monedaSold: json['MonedaSold'] ?? 0 as int,
      channelName: json['ChannelName'] ?? '' as String,
    );
  }
}

class TotaluriMedic {
  final int totalNrPacienti;
  final int totalNrRatinguri;
  final double totalDeIncasat;
  final double totalIncasari;
  final int moneda;
  final String etichetaData;

  const TotaluriMedic({
    required this.totalNrPacienti,
    required this.totalNrRatinguri,
    required this.totalDeIncasat,
    required this.totalIncasari,
    required this.moneda,
    required this.etichetaData,
  });

  factory TotaluriMedic.fromJson(Map<String, dynamic> json) {
    print('TotaluriMedic.fromJson $json');

    return TotaluriMedic(
      totalNrPacienti: json['TotalNrPacienti'] as int,
      totalNrRatinguri: json['TotalNrRatinguri'] as int,
      totalDeIncasat: json['TotalDeIncasat'] as double,
      totalIncasari: json['TotalIncasari'] as double,
      moneda: json['Moneda'] as int,
      etichetaData: json['EtichetaData'] ?? '',
    );
  }
}

class ConsultatiiMobile {
  final int id;
  final String numeCompletClient;
  final String linkPozaProfil;
  final String adresa;
  final DateTime dataInceput;
  final DateTime dataSfarsit;
  final String etichetaDurata;
  final int tipConsultatie;

  const ConsultatiiMobile({
    required this.id,
    required this.numeCompletClient,
    required this.linkPozaProfil,
    required this.adresa,
    required this.dataInceput,
    required this.dataSfarsit,
    required this.etichetaDurata,
    required this.tipConsultatie,
  });

  factory ConsultatiiMobile.fromJson(Map<String, dynamic> json) {


    return ConsultatiiMobile(
      id: json['Id'] as int,
      numeCompletClient: json['NumeCompletClient'] as String,
      linkPozaProfil: json['LinkPozaProfil'] as String,
      adresa: json['Adresa'] as String,
      dataInceput: DateTime.parse(json['DataInceput'].toString()),
      dataSfarsit: DateTime.parse(json['DataSfarsit'].toString()),
      etichetaDurata: json['EtichetaDurata'] as String,
      tipConsultatie: json['TipConsultatie'] as int,
    );
  }
}

class EducatieMedic {
  final int id;
  String? tipEducatie;
  String? informatiiSuplimentare;

  EducatieMedic({
    required this.id,
    this.tipEducatie,
    this.informatiiSuplimentare,
  });

  factory EducatieMedic.fromJson(Map<String, dynamic> json) {
    print('EducatieMedic.fromJson $json');

    return EducatieMedic(
      id: json['Id'] as int,
      tipEducatie: json['TipEducatie'] as String,
      informatiiSuplimentare: json['InformatiiSuplimentare'] as String,
    );
  }
}

class IncasareMedic {
  final int id;
  final String linkPozaProfil;
  final DateTime dataIncasare;
  final String numeCompletPacient;
  final double totalIncasat;
  final int moneda;

  const IncasareMedic({
    required this.id,
    required this.linkPozaProfil,
    required this.dataIncasare,
    required this.numeCompletPacient,
    required this.totalIncasat,
    required this.moneda,
  });

  factory IncasareMedic.fromJson(Map<String, dynamic> json) {
    print('IncasareMedic.fromJson $json');

    return IncasareMedic(
      id: json['Id'] as int,
      linkPozaProfil: json['LinkPozaProfil'] as String,
      dataIncasare: DateTime.parse(json['DataIncasare'].toString()),
      numeCompletPacient: json['NumeCompletPacient'] as String,
      totalIncasat: json['TotalIncasat'] as double,
      moneda: json['Moneda'] as int,
    );
  }
}

class Agora {
  String? appID;
  String? appCertificate;

  Agora({
    this.appID,
    this.appCertificate,
  });

  factory Agora.fromJson(Map<String, dynamic> json) {
    print('Agora.fromJson $json');

    return Agora(
      appID: json['AppID'] as String,
      appCertificate: json['AppCertificate'] as String,
    );
  }
}

class ConversatieMobile {
  final int id;
  final String identitateDestinatar;
  final int idDestinatar;
  final int idExpeditor;
  final String titulaturaDestinatar;
  final String linkPozaProfil;
  final String locDeMunca;
  final String functia;
  final String specializarea;

  const ConversatieMobile({
    required this.id,
    required this.identitateDestinatar,
    required this.idDestinatar,
    required this.idExpeditor,
    required this.titulaturaDestinatar,
    required this.linkPozaProfil,
    required this.locDeMunca,
    required this.functia,
    required this.specializarea,
  });

  factory ConversatieMobile.fromJson(Map<String, dynamic> json) {
    print('ConversatieMobile.fromJson $json');

    return ConversatieMobile(
      id: json['ID'] as int,
      identitateDestinatar: json['IdentitateDestinatar'] as String,
      idDestinatar: json['IdDestinatar'] as int,
      idExpeditor: json['IdExpeditor'] as int,
      titulaturaDestinatar: json['TitulaturaDestinatar'] as String,
      linkPozaProfil: json['LinkPozaProfil'] as String,
      locDeMunca: json['LocDeMunca'] as String,
      functia: json['Functia'] as String,
      specializarea: json['Specializarea'] as String,
    );
  }
}

class MesajConversatieMobile {
  final int id;
  final DateTime dataMesaj;
  final String comentariu;
  final int idDestinatar;
  final int idExpeditor;

  const MesajConversatieMobile({
    required this.id,
    required this.dataMesaj,
    required this.comentariu,
    required this.idDestinatar,
    required this.idExpeditor,
  });

  factory MesajConversatieMobile.fromJson(Map<String, dynamic> json) {
    print('MesajConversatieMobile.fromJson $json');

    return MesajConversatieMobile(
      id: json['ID'] as int,
      dataMesaj: DateTime.parse(json['DataMesaj'].toString()),
      comentariu: json['Comentariu'] as String,
      idDestinatar: json['IdDestinatar'] as int,
      idExpeditor: json['IdExpeditor'] as int,
    );
  }
}

enum EnumStareContMedic {
  nedefinit(0),
  inProcesare(1),
  activ(2);

  const EnumStareContMedic(this.value);
  final int value;
}

enum EnumTipMoneda {
  nedefinit(0),
  lei(1),
  euro(2);

  const EnumTipMoneda(this.value);
  final int value;
}

enum EnumTipDispozitiv {
  nedefinit(0),
  android(1),
  iOS(2);

  const EnumTipDispozitiv(this.value);
  final int value;
}

enum EnumTipConsultatie {
  nedefinit(0),
  consultVideo(1),
  interpretareAnalize(2),
  intrebare(3);

  const EnumTipConsultatie(this.value);
  final int value;
}

enum EnumTipNotificare {
  nedefinit(0),
  analizeDeInterpretat(1),
  consultatieVideo(2),
  intrebare(3),
  mesajChat(4);

  const EnumTipNotificare(this.value);
  final int value;
}

List<ConsultatiiMobile> filterListConsultatiiMobileByIntervalData(
    DateTime lowerThresholdData,
    DateTime higherThresholdData,
    List<ConsultatiiMobile> listaConsultatiiMobileNumarPacienti) {
  List<ConsultatiiMobile> listResult = [];
  if (lowerThresholdData.isAfter(higherThresholdData)) {
    return listResult;
  }

  for (int index = 0;
      index < listaConsultatiiMobileNumarPacienti.length;
      index++) {
    var dataStartItem = listaConsultatiiMobileNumarPacienti[index].dataInceput;

    print(
        'filterListConsultatiiMobileByIntervalData Aici dataStartItem $dataStartItem lowerThresholdData $lowerThresholdData higherThresholdData $higherThresholdData');

    if ((dataStartItem.year > lowerThresholdData.year) &&
        ((dataStartItem.year < higherThresholdData.year) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month < higherThresholdData.month) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month == higherThresholdData.month &&
                dataStartItem.day <= higherThresholdData.day))) {
      listResult.add(listaConsultatiiMobileNumarPacienti[index]);
    } else if (((dataStartItem.year == lowerThresholdData.year) &&
            (dataStartItem.month > lowerThresholdData.month)) &&
        ((dataStartItem.year < higherThresholdData.year) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month < higherThresholdData.month) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month == higherThresholdData.month &&
                dataStartItem.day <= higherThresholdData.day))) {
      listResult.add(listaConsultatiiMobileNumarPacienti[index]);
    } else if (((dataStartItem.year == lowerThresholdData.year) &&
            (dataStartItem.month == lowerThresholdData.month) &&
            (dataStartItem.day >= lowerThresholdData.day)) &&
        ((dataStartItem.year < higherThresholdData.year) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month < higherThresholdData.month) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month == higherThresholdData.month &&
                dataStartItem.day <= higherThresholdData.day))) {
      listResult.add(listaConsultatiiMobileNumarPacienti[index]);
    }
  }

  return listResult;
}

List<RecenzieMobile> filterListRecenzieMobileByIntervalData(
    DateTime lowerThresholdData,
    DateTime higherThresholdData,
    List<RecenzieMobile> listaRecenzieMobileRating) {
  List<RecenzieMobile> listResult = [];
  if (lowerThresholdData.isAfter(higherThresholdData)) {
    return listResult;
  }

  for (int index = 0; index < listaRecenzieMobileRating.length; index++) {
    var dataStartItem = listaRecenzieMobileRating[index].dataRecenzie;

    print(
        'filterListRecenzieMobileByIntervalData Aici dataStartItem $dataStartItem lowerThresholdData $lowerThresholdData higherThresholdData $higherThresholdData');

    if ((dataStartItem.year > lowerThresholdData.year) &&
        ((dataStartItem.year < higherThresholdData.year) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month < higherThresholdData.month) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month == higherThresholdData.month &&
                dataStartItem.day <= higherThresholdData.day))) {
      listResult.add(listaRecenzieMobileRating[index]);
    } else if (((dataStartItem.year == lowerThresholdData.year) &&
            (dataStartItem.month > lowerThresholdData.month)) &&
        ((dataStartItem.year < higherThresholdData.year) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month < higherThresholdData.month) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month == higherThresholdData.month &&
                dataStartItem.day <= higherThresholdData.day))) {
      listResult.add(listaRecenzieMobileRating[index]);
    } else if (((dataStartItem.year == lowerThresholdData.year) &&
            (dataStartItem.month == lowerThresholdData.month) &&
            (dataStartItem.day >= lowerThresholdData.day)) &&
        ((dataStartItem.year < higherThresholdData.year) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month < higherThresholdData.month) ||
            (dataStartItem.year == higherThresholdData.year &&
                dataStartItem.month == higherThresholdData.month &&
                dataStartItem.day <= higherThresholdData.day))) {
      listResult.add(listaRecenzieMobileRating[index]);
    }
  }

  return listResult;
}

////////////////////////////////////////////////// old Andrei Bădescu

class DosarulMeu {
  final String titlu;
  final Widget widgetRoute;

  DosarulMeu({
    required this.titlu,
    required this.widgetRoute,
  });
}

class Sediu {
  final String id, denumire, adresa, telefon;

  Sediu(
      {required this.id,
      required this.denumire,
      required this.adresa,
      required this.telefon});
}

class DetaliiProgramare {
  final String dataInceput;
  final String oraFinal;
  final String numeMedic;
  final String idCategorie;
  final String statusProgramare;
  final String esteAnulat;
  final String numeLocatie;
  final List<String> listaInterventii;

  DetaliiProgramare({
    required this.dataInceput,
    required this.oraFinal,
    required this.numeMedic,
    required this.idCategorie,
    required this.statusProgramare,
    required this.esteAnulat,
    required this.numeLocatie,
    required this.listaInterventii,
  });

  double GetTotal() {
    // print(listaInterventii.map((e) => e.split("*\$*")[6]).toList()[0]);
    // return listaInterventii
    //     .map((e) => e.split("*\$*"))
    //     .where((element) => element.length >= 7)
    //     .map((e) => e[6])
    //     .map((e) => e.replaceAll(RegExp(r'([A-Z\s,])'), ""))
    //     .map((e) => double.parse(e))
    //     .reduce((value, element) => value + element);
    double total = 0;
    print(listaInterventii);
    for (var interv in listaInterventii) {
      if (interv.isEmpty) continue;
      String pretstr = interv.split("*\$*")[6];
      pretstr = pretstr.replaceAll(RegExp(r'([A-Z\s,])'), "");
      print(pretstr);
      double pret = double.parse(pretstr);
      total += pret;
    }
    return total;
  }
}

class Programare {
  final String locatie;
  final String idMedic;
  String hasFeedback;
  final String id;
  final DateTime inceput, sfarsit;
  final String medic, categorie;
  String status, anulata;
  final String idPacient, nume, prenume;

  static const String statusConfirmat = "Confirmat";
  static const String statusAnulat = "Anulat";

  Programare({
    required this.id,
    required this.medic,
    required this.anulata,
    required this.categorie,
    required this.inceput,
    required this.sfarsit,
    required this.status,
    required this.idPacient,
    required this.nume,
    required this.prenume,
    required this.locatie,
    required this.idMedic,
    required this.hasFeedback,
  });
}

class LinieFisaTratament {
  final String tipObiect;
  final String idObiect;
  final String numeMedic;
  final String denumireInterventie;
  final String dinti;
  final String observatii;
  final DateTime dataDateTime;
  final String dataString;
  final String pret;
  final Color culoare;
  final DateTime? dataCreareDateTime;
  final String? dataCreareString;
  final String valoareInitiala;

  LinieFisaTratament(
      {required this.tipObiect,
      required this.pret,
      required this.idObiect,
      required this.numeMedic,
      required this.denumireInterventie,
      required this.dinti,
      required this.observatii,
      required this.dataDateTime,
      required this.dataString,
      required this.culoare,
      this.dataCreareDateTime,
      this.dataCreareString,
      required this.valoareInitiala});
}

class Programari {
  List<Programare> viitoare;
  List<Programare> trecute;

  Programari({required this.viitoare, required this.trecute});
}

class MembruFamilie {
  final String id, nume, prenume;

  MembruFamilie({required this.id, required this.nume, required this.prenume});
}

class Shared {
  static GlobalKey<NavigatorState> sharedNavigatorKey =
      GlobalKey<NavigatorState>();
  // static String flavor = '';
  static String FCMtoken = '';
  static String idMembruFamilieConectat = '_';
  static String sediuPacient = '';
  //static List<Medic> medici = <Medic>[];
  //static List<MedicSlotLiber> mediciFiltrati = <MedicSlotLiber>[];
  //static List<CategorieProgramare> categorii = <CategorieProgramare>[];
  static List<MembruFamilie> familie = <MembruFamilie>[];
  static List<Sediu> sedii = <Sediu>[];
  static String idPacientAsociat = '0';

  static List<Judet> judete = <Judet>[];
  static List<Localitate> localitati = <Localitate>[];

  //static GenericLanguage limba = LanguageEN();
}

class Judet {
  final String id, denumire;

  Judet({
    required this.id,
    required this.denumire,
  });
}

class Localitate {
  final String id, denumire;

  Localitate({
    required this.id,
    required this.denumire,
  });
}
