import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_delegate.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/ro.dart' as romanian;

class LocalizationsApp {
  LocalizationsApp(this.locale);

  final Locale locale;

    get universalSave => null;

  static LocalizationsApp? of(BuildContext context) {
    return Localizations.of<LocalizationsApp>(context, LocalizationsApp);
  }

  static const LocalizationsDelegate delegate = AppLocalizationsDelegate();

  static final Map<String, Map<String, dynamic>> _localizedValues = {
    'ro': romanian.values,
    /*
    'en': english.values,
    'fr': french.values,
    'it': italian.values
    */
  };



  String get universalInapoi {
    return _localizedValues[locale.languageCode]!['universal']['inapoi'];
  }


  // register

  String get registerInregistrareCuSucces {

    return _localizedValues[locale.languageCode]!['register']['inregistrare_cu_succes'];

  }

  String get registerApelInvalid {

    return _localizedValues[locale.languageCode]!['register']['apel_invalid'];

  }

  String get registerContDejaExistent {

    return _localizedValues[locale.languageCode]!['register']['cont_deja_existent'];

  }

  String get registerInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['register']['informatii_insuficiente'];

  }

  String get registerAAparutEroare {

    return _localizedValues[locale.languageCode]!['register']['a_aparut_eroare'];
  
  }

  String get registerInregistrare {

    return _localizedValues[locale.languageCode]!['register']['inregistrare'];
  
  }

  String get registerNumeCompletHint {

    return _localizedValues[locale.languageCode]!['register']['nume_complet_hint'];
  
  }

  String get registerIntroducetiNumeleComplet {

    return _localizedValues[locale.languageCode]!['register']['introduceti_numele_complet'];
  
  }

  String get registerEmailHint {

    return _localizedValues[locale.languageCode]!['register']['email_hint'];
  
  }

  String get registerIntroducetiOAdresaDeEmailCorecta {

    return _localizedValues[locale.languageCode]!['register']['introduceti_o_adresa_de_email_corecta'];
  
  }

  String get registerTelefonHint {

    return _localizedValues[locale.languageCode]!['register']['telefon_hint'];
  
  }

  String get registerIntroducetiUnNumarDeTelefonCorect {

    return _localizedValues[locale.languageCode]!['register']['introduceti_un_numar_de_telefon_corect'];
  
  }

  String get registerIntroducetiUnNumarDeMobilCorect {

    return _localizedValues[locale.languageCode]!['register']['introduceti_un_numar_de_mobil_corect'];
  
  }

  String get registerCNPHint {

    return _localizedValues[locale.languageCode]!['register']['CNP_hint'];
  
  }

  String get registerIntroducetiUnCNPValid {

    return _localizedValues[locale.languageCode]!['register']['introduceti_un_CNP_valid'];
  
  }

  String get registerParolaHint {

    return _localizedValues[locale.languageCode]!['register']['parola_hint'];
  
  }

  String get registerVaRugamIntroducetiOParolaNoua {

    return _localizedValues[locale.languageCode]!['register']['va_rugam_introduceti_o_parola_noua'];
  
  }

  String get registerParolaTrebuieSaAibaCelPutin {

    return _localizedValues[locale.languageCode]!['register']['parola_trebuie_sa_aiba_cel_putin'];
  
  }

  String get registerSeIncearcaInregistrarea {

    return _localizedValues[locale.languageCode]!['register']['se_incearca_inregistrarea'];
  
  }

  String get registerTrimiteDatele {

    return _localizedValues[locale.languageCode]!['register']['trimite_datele'];
  
  }


  // login

  String get loginLoginCuSucces {

    return _localizedValues[locale.languageCode]!['login']['login_cu_succes'];

  }

  String get loginEroareReintroducetiUserParola {

    return _localizedValues[locale.languageCode]!['login']['eroare_reintroduceti_user_parola'];

  }

  String get loginEmailTelefonHint {

    return _localizedValues[locale.languageCode]!['login']['email_telefon_hint'];

  }

  String get loginIntroducetiUnEmailNumarTelefonValid {

    return _localizedValues[locale.languageCode]!['login']['introduceti_un_email_numar_telefon_valid'];

  }

  String get loginParolaHint {

    return _localizedValues[locale.languageCode]!['login']['parola_hint'];

  }

  String get loginVaRugamIntroducetiOParolaNoua {

    return _localizedValues[locale.languageCode]!['login']['va_rugam_introduceti_o_parola_noua'];

  }

  String get loginParolaTrebuieSaAibaCelPutin {

    return _localizedValues[locale.languageCode]!['login']['parola_trebuie_sa_aiba_cel_putin'];

  }

  String get loginConectare {

    return _localizedValues[locale.languageCode]!['login']['conectare'];

  }

  String get loginAiUitatParola {

    return _localizedValues[locale.languageCode]!['login']['ai_uitat_parola'];

  }

  String get loginClickAiciParola {

    return _localizedValues[locale.languageCode]!['login']['click_aici_parola'];

  }

  String get loginNuAiCont {

    return _localizedValues[locale.languageCode]!['login']['nu_ai_cont'];

  }

  String get loginClickAiciCont {

    return _localizedValues[locale.languageCode]!['login']['click_aici_cont'];

  }


  // reset_password

  String get resetPasswordReseteazaParola {

    return _localizedValues[locale.languageCode]!['reset_password']['reseteaza_parola'];

  }

  String get resetPasswordReseteazaParolaTextMijloc {

    return _localizedValues[locale.languageCode]!['reset_password']['reseteaza_parola_text_mijloc'];

  }

  String get resetPasswordTelefonHint {

    return _localizedValues[locale.languageCode]!['reset_password']['telefon_hint'];

  }

  String get resetPasswordIntroducetiUnNumarDeTelefonCorect {

    return _localizedValues[locale.languageCode]!['reset_password']['introduceti_un_numar_de_telefon_corect'];

  }

  String get resetPasswordIntroducetiUnNumarDeMobilCorect {

    return _localizedValues[locale.languageCode]!['reset_password']['introduceti_un_numar_de_mobil_corect'];

  }

  String get resetPasswordSendCode {

    return _localizedValues[locale.languageCode]!['reset_password']['send_code'];

  }

  String get resetPasswordCodTrimisCuSucces {

    return _localizedValues[locale.languageCode]!['reset_password']['cod_trimis_cu_succes'];

  }

  String get resetPasswordApelInvalid {

    return _localizedValues[locale.languageCode]!['reset_password']['apel_invalid'];

  }

  String get resetPasswordContInexistent {

    return _localizedValues[locale.languageCode]!['reset_password']['cont_inexistent'];

  }

  String get resetPasswordContExistentDarClientulNuAreDateDeContact {

    return _localizedValues[locale.languageCode]!['reset_password']['cont_existent_dar_clientul_nu_are_date_de_contact'];

  }

  String get resetPasswordAAparutOEroareLaExecutiaMetodei {

    return _localizedValues[locale.languageCode]!['reset_password']['a_aparut_o_eroare_la_executia_metodei'];

  }

  String get resetPasswordContulDumneavoastra {

    return _localizedValues[locale.languageCode]!['reset_password']['contul_dumneavoastra'];

  }


  // verifica_codul

  String get verificaCodulTitlu {

    return _localizedValues[locale.languageCode]!['verifica_codul']['verifica_codul_titlu'];

  }

  String get verificaCodulTextMijloc {

    return _localizedValues[locale.languageCode]!['verifica_codul']['text_mijloc'];

  }

  String get verificaCodulTrimiteDinNouCodul {

    return _localizedValues[locale.languageCode]!['verifica_codul']['trimite_din_nou_codul'];

  }

  String get verificaCodulVerifica {

    return _localizedValues[locale.languageCode]!['verifica_codul']['verifica'];

  }

  String get verificaCodulCodVerificatCuSucces {

    return _localizedValues[locale.languageCode]!['verifica_codul']['cod_verificat_cu_succes'];

  }

  String get verificaCodulApelInvalid {

    return _localizedValues[locale.languageCode]!['verifica_codul']['apel_invalid'];

  }

  String get verificaCodulEroareCodulNuAPututFiVerificat {

    return _localizedValues[locale.languageCode]!['verifica_codul']['eroare_codul_nu_a_putut_fi_verificat'];

  }

  String get verificaCodulInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['verifica_codul']['informatii_insuficiente'];

  }

  String get verificaCodulAAparutOEroareLaExecutiaMetodei {

    return _localizedValues[locale.languageCode]!['verifica_codul']['a_aparut_o_eroare_la_executia_metodei'];

  }


  // parola_noua

  String get parolaNouaParolaResetataCuSucces {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_resetata_cu_succes'];

  }

  String get parolaNouaApelInvalid {

    return _localizedValues[locale.languageCode]!['parola_noua']['apel_invalid'];

  }

  String get parolaNouaEroareLaResetareParola {

    return _localizedValues[locale.languageCode]!['parola_noua']['eroare_la_resetare_parola'];

  }

  String get parolaNouaInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['parola_noua']['informatii_insuficiente'];

  }

  String get parolaNouaAAparutOEroareLaExecutiaMetodei {

    return _localizedValues[locale.languageCode]!['parola_noua']['a_aparut_o_eroare_la_executia_metodei'];

  }

  String get parolaNouaTitlu {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_noua_titlu'];

  }

  String get parolaNouaTextMijloc {

    return _localizedValues[locale.languageCode]!['parola_noua']['text_mijloc'];

  }

  String get parolaNouaParolaHint {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_hint'];

  }

  String get parolaNouaVaRugamIntroducetiOParolaNoua {

    return _localizedValues[locale.languageCode]!['parola_noua']['va_rugam_introduceti_o_parola_noua'];

  }

  String get parolaNouaParolaTrebuieSaAibaCelPutin {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_trebuie_sa_aiba_cel_putin'];

  }

  String get parolaNouaParolaTrebuieSaFieAceeasi {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_trebuie_sa_fie_aceeasi'];

  }

  String get parolaNouaRepetaNouaParolaHint {

    return _localizedValues[locale.languageCode]!['parola_noua']['repeta_noua_parola_hint'];

  }

  String get parolaNouaVaRugamIntroducetiOParolaNouaRepetaParola {

    return _localizedValues[locale.languageCode]!['parola_noua']['va_rugam_introduceti_o_parola_noua_repeta_parola'];

  }

  String get parolaNouaParolaTrebuieSaAibaCelPutinRepetaParola {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_trebuie_sa_aiba_cel_putin_repeta_parola'];

  }

  String get parolaNouaParolaTrebuieSaFieAceeasiRepetaParola {

    return _localizedValues[locale.languageCode]!['parola_noua']['parola_trebuie_sa_fie_aceeasi_repeta_parola'];

  }

  String get parolaNouaSeIncearcaResetareaParolei {

    return _localizedValues[locale.languageCode]!['parola_noua']['se_incearca_resetarea_parolei'];

  }

  String get parolaNouaConfirma {

    return _localizedValues[locale.languageCode]!['parola_noua']['confirma'];

  }


  // dashboard

  String get dashboardEstiON {

    return _localizedValues[locale.languageCode]!['dashboard']['esti_on'];

  }

  String get dashboardBunVenit {

    return _localizedValues[locale.languageCode]!['dashboard']['bun_venit'];

  }

  String get dashboardPrimesteIntrebari {

    return _localizedValues[locale.languageCode]!['dashboard']['primeste_intrebari'];

  }

  String get dashboardInterpretareAnalize {

    return _localizedValues[locale.languageCode]!['dashboard']['interpretare_analize'];

  }

  String get dashboardConsultatieVideo {

    return _localizedValues[locale.languageCode]!['dashboard']['consultatie_video'];

  }

  String get dashboardRaportTitlu {

    return _localizedValues[locale.languageCode]!['dashboard']['raport_titlu'];

  }

  String get dashboardNumarPacienti {

    return _localizedValues[locale.languageCode]!['dashboard']['numar_pacienti'];

  }

  String get dashboardRating {

    return _localizedValues[locale.languageCode]!['dashboard']['rating'];

  }

  String get dashboardSumaDeIncasat {

    return _localizedValues[locale.languageCode]!['dashboard']['suma_de_incasat'];

  }

  String get dashboardTotalIncasari {

    return _localizedValues[locale.languageCode]!['dashboard']['total_incasari'];

  }

  String get dashboardStatusuriSetateCuSucces {

    return _localizedValues[locale.languageCode]!['dashboard']['statusuri_setate_cu_succes'];

  }

  String get dashboardApelInvalid {

    return _localizedValues[locale.languageCode]!['dashboard']['apel_invalid'];

  }

  String get dashboardStatusurileNuAuFostSetate {

    return _localizedValues[locale.languageCode]!['dashboard']['statusurile_nu_au_fost_setate'];

  }

  String get dashboardInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['dashboard']['informatii_insuficiente'];

  }

  String get dashboardAAparutOEroareLaExecutiaMetodei {

    return _localizedValues[locale.languageCode]!['dashboard']['a_aparut_o_eroare_la_executia_metodei'];

  }

  String get dashboardDetaliiRatingNumarPacienti {

    return _localizedValues[locale.languageCode]!['dashboard']['detalii_rating_numar_pacienti'];

  }

  String get dashboardDetaliiIncasariSumaDeIncasat {

    return _localizedValues[locale.languageCode]!['dashboard']['detalii_incasari_suma_de_incasat'];

  }

  String get dashboardLei {

    return _localizedValues[locale.languageCode]!['dashboard']['lei'];

  }

  String get dashboardEuro {

    return _localizedValues[locale.languageCode]!['dashboard']['euro'];

  }



  // analize

  String get analizeAtiPrimitUnSetDeAnalize {

    return _localizedValues[locale.languageCode]!['analize']['ati_primit_un_set_de_analize'];

  }

  String get analizeVeziAnalize {

    return _localizedValues[locale.languageCode]!['analize']['vezi_analize'];

  }


  // apel_video_medic

  String get apelVideoMedicVaRugamAsteptati {

    return _localizedValues[locale.languageCode]!['apel_video_medic']['va_rugam_asteptati'];

  }


  // solicitare_consultatie_video

  String get solicitareConsultatieVideoAtiFostSolicitatPentruOConsultatieVideo {

    return _localizedValues[locale.languageCode]!['solicitare_consultatie_video']['ati_fost_solicitat_pentru_o_consultatie_video'];

  }

  String get solicitareConsultatieVideoCitesteChestionarul {

    return _localizedValues[locale.languageCode]!['solicitare_consultatie_video']['citeste_chestionarul'];

  }


  // intrebare

  String get intrebareViSAAdresatOIntrebare {

    return _localizedValues[locale.languageCode]!['intrebare']['vi_s_a_adresat_o_intrebare'];

  }

  String get intrebareCitesteChestionarul {

    return _localizedValues[locale.languageCode]!['intrebare']['citeste_chestionarul'];

  }


  // multumim_inregistrare

  String get multumimInregistrareVaMultumim {

    return _localizedValues[locale.languageCode]!['multumim_inregistrare']['va_multumim'];

  }

  String get multumimInregistrareSolicitareaDumneavoastraAFostInregistrata {

    return _localizedValues[locale.languageCode]!['multumim_inregistrare']['solicitarea_dumneavoastra_a_fost_inregistrata'];

  }

  String get multumimInregistrareUrmeazaSaFitiContactatDe {

    return _localizedValues[locale.languageCode]!['multumim_inregistrare']['urmeaza_sa_fiti_contactat_de'];

  }

  String get multumimInregistrareCatreUnReprezentant {

    return _localizedValues[locale.languageCode]!['multumim_inregistrare']['catre_un_reprezentant'];

  }

  String get multumimInregistrareSosBebe {

    return _localizedValues[locale.languageCode]!['multumim_inregistrare']['sos_bebe'];

  }

  String get multumimInregistrareInCelMaiScurtTimp {

    return _localizedValues[locale.languageCode]!['multumim_inregistrare']['in_cel_mai_scurt_timp'];

  }


  // succes


  String get succesFelicitari {

    return _localizedValues[locale.languageCode]!['succes']['felicitari'];

  }

  String get succesTextMijloc {

    return _localizedValues[locale.languageCode]!['succes']['text_mijloc'];

  }

  String get succesLogIn {

    return _localizedValues[locale.languageCode]!['succes']['log_in'];

  }


  // error


  String get errorOops {

    return _localizedValues[locale.languageCode]!['error']['oops'];

  }

  String get errorTextMijloc {

    return _localizedValues[locale.languageCode]!['error']['text_mijloc'];

  }

  String get errorResetareParola {

    return _localizedValues[locale.languageCode]!['error']['resetare_parola'];

  }


  // chestionar


  String get chestionarNumePrenumePacient {

    return _localizedValues[locale.languageCode]!['chestionar']['nume_prenume_pacient'];

  }

/*
  String get chestionarVarsta {

    return _localizedValues[locale.languageCode]!['chestionar']['varsta'];

  }
*/

  String get chestionarDataDeNastere {

    return _localizedValues[locale.languageCode]!['chestionar']['data_de_nastere'];

  }

  String get chestionarGreutate {

    return _localizedValues[locale.languageCode]!['chestionar']['greutate'];

  }

  String get chestionarAlergicLaMedicament{

    return _localizedValues[locale.languageCode]!['chestionar']['alergic_la_medicament'];

  }

  String get chestionarSimptomePacient{

    return _localizedValues[locale.languageCode]!['chestionar']['simptome_pacient'];

  }

  String get chestionarFebra{

    return _localizedValues[locale.languageCode]!['chestionar']['febra'];

  }

  String get chestionarTuse{

    return _localizedValues[locale.languageCode]!['chestionar']['tuse'];

  }

  String get chestionarDificultatiRespiratorii{

    return _localizedValues[locale.languageCode]!['chestionar']['dificultati_respiratorii'];

  }

  String get chestionarAstenie{

    return _localizedValues[locale.languageCode]!['chestionar']['astenie'];

  }

  String get chestionarCefalee{

    return _localizedValues[locale.languageCode]!['chestionar']['cefalee'];

  }

  String get chestionarDureriInGat{

    return _localizedValues[locale.languageCode]!['chestionar']['dureri_in_gat'];

  }

  String get chestionarGreturiVarsaturi{

    return _localizedValues[locale.languageCode]!['chestionar']['greturi_varsaturi'];

  }

  String get chestionarDiareeConstipatie{

    return _localizedValues[locale.languageCode]!['chestionar']['diaree_constipatie'];

  }

  String get chestionarIritatiiPiele{

    return _localizedValues[locale.languageCode]!['chestionar']['iritatii_piele'];

  }

  String get chestionarNasInfundat{

    return _localizedValues[locale.languageCode]!['chestionar']['nas_infundat'];

  }

  String get chestionarRinoree{

    return _localizedValues[locale.languageCode]!['chestionar']['rinoree'];

  }

  String get chestionarContinuaCuApelVideo{

    return _localizedValues[locale.languageCode]!['chestionar']['continua_cu_apel_video'];

  }

  String get chestionarRaspundeLaIntrebare{

    return _localizedValues[locale.languageCode]!['chestionar']['raspunde_la_intrebare'];

  }

  String get chestionarTitlu{

    return _localizedValues[locale.languageCode]!['chestionar']['chestionar_titlu'];

  }


  // editare_profil


  String get editareProfilulMeuTitlu {

    return _localizedValues[locale.languageCode]!['editare_profil']['profilul_meu_titlu'];

  }

  String get editareProfilUser {

    return _localizedValues[locale.languageCode]!['editare_profil']['user'];

  }

  String get editareProfilEmail {

    return _localizedValues[locale.languageCode]!['editare_profil']['email'];

  }

  String get editareProfilNavigareEditareProfil {

    return _localizedValues[locale.languageCode]!['editare_profil']['navigare_editare_profil'];

  }

  String get editareProfilDeconectare {

    return _localizedValues[locale.languageCode]!['editare_profil']['deconectare'];

  }

  String get editareProfilNotificari {

    return _localizedValues[locale.languageCode]!['editare_profil']['notificari'];

  }

  String get editareProfilTermeniSiConditii {

    return _localizedValues[locale.languageCode]!['editare_profil']['termeni_si_conditii'];

  }


  // meniu


  String get meniuEstiON {

    return _localizedValues[locale.languageCode]!['meniu']['esti_on'];

  }

  String get meniuEstiOFF {

    return _localizedValues[locale.languageCode]!['meniu']['esti_off'];

  }

  String get meniuBunVenit {

    return _localizedValues[locale.languageCode]!['meniu']['bun_venit'];

  }

  String get meniuNumarPacienti {

    return _localizedValues[locale.languageCode]!['meniu']['numar_pacienti'];

  }

  String get meniuRating {

    return _localizedValues[locale.languageCode]!['meniu']['rating'];

  }

  String get meniuVeziIncasari {

    return _localizedValues[locale.languageCode]!['meniu']['vezi_incasari'];

  }

  String get meniuProfilulMeu {

    return _localizedValues[locale.languageCode]!['meniu']['profilul_meu'];

  }


  // setari_profil


  String get setariProfilActualizareDateFinalizataCuSucces {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_date_finalizata_cu_succes'];

  }

  String get setariProfilActualizareDateApelInvalid {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_date_apel_invalid'];

  }

  String get setariProfilDateleNuAuPututFiActualizate {

    return _localizedValues[locale.languageCode]!['setari_profil']['datele_nu_au_putut_fi_actualizate'];

  }

  String get setariProfilActualizareDateInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_date_informatii_insuficiente'];

  }

  String get setariProfilAAparutOEroareLaExecutiaMetodei {

    return _localizedValues[locale.languageCode]!['setari_profil']['a_aparut_o_eroare_la_executia_metodei'];

  }

  String get setariProfilTitlu {

    return _localizedValues[locale.languageCode]!['setari_profil']['setari_profilul_meu_titlu'];

  }

  String get setariProfilTitluProfil {

    return _localizedValues[locale.languageCode]!['setari_profil']['titlu_profil'];

  }

  String get setariProfilReseteazaParola {

    return _localizedValues[locale.languageCode]!['setari_profil']['reseteaza_parola'];

  }

  String get setariProfilEditareUserHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['editare_user_hint'];

  }

  String get setariProfilIntroducetiNumeleComplet {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_numele_complet'];

  }

  String get setariProfilEditeazaEmailHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['editeaza_email_hint'];

  }

  String get setariProfilIntroducetiOAdresaDeEmailCorecta {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_o_adresa_de_email_corecta'];

  }

  String get setariProfilEditeazaTelefonHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['editeaza_telefon_hint'];

  }

  String get setariProfilIntroducetiUnNumarDeTelefonCorect {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_un_numar_de_telefon_corect'];

  }

  String get setariProfilIntroducetiUnNumarDeMobilCorect {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_un_numar_de_mobil_corect'];

  }

  String get setariProfilEditeazaCV {

    return _localizedValues[locale.languageCode]!['setari_profil']['editeaza_cv'];

  }

  String get setariProfilSalveaza {

    return _localizedValues[locale.languageCode]!['setari_profil']['salveaza'];

  }

  String get setariProfilTitluProfestionalHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['titlu_profestional_hint'];

  }

  String get setariProfilIntroducetiUnTitluProfesional {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_un_titlu_profesional'];

  }

  String get setariProfilSpecializareHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['specializare_hint'];

  }

  String get setariProfilIntroducetiOSpecializare {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_o_specializare'];

  }

  String get setariProfilExperientaHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['experienta_hint'];

  }

  String get setariProfilIntroducetiExperienta {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_experienta'];

  }

  String get setariProfilDenumireLocDeMuncaHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['denumire_loc_de_munca_hint'];

  }

  String get setariProfilIntroducetiODenumireDeLocDeMunca {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_o_denumire_de_loc_de_munca'];

  }

  String get setariProfilAdresaLocDeMuncaHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['adresa_loc_de_munca_hint'];

  }

  String get setariProfilIntroducetiOAdresaDeLocDeMunca {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_o_adresa_de_loc_de_munca'];

  }

  String get setariProfilTipEducatieHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['tip_educatie_hint'];

  }

  String get setariProfilIntroducetiTipEducatie {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_tip_educatie'];

  }

  String get setariProfilAdaugaTipEducatie {

    return _localizedValues[locale.languageCode]!['setari_profil']['adauga_tip_educatie'];

  }

  String get setariProfilInformatiiEducatieHint {

    return _localizedValues[locale.languageCode]!['setari_profil']['informatii_educatie_hint'];

  }

  String get setariProfilIntroducetiInformatiiEducatie {

    return _localizedValues[locale.languageCode]!['setari_profil']['introduceti_informatii_educatie'];

  }

  String get setariProfilActualizareCVFinalizataCuSucces {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_cv_finalizata_cu_succes'];

  }

  String get setariProfilActualizareCVApelInvalid {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_cv_apel_invalid'];

  }

  String get setariProfilCVulNuAFostActualizat {

    return _localizedValues[locale.languageCode]!['setari_profil']['cv_ul_nu_a_fost_actualizat'];

  }

  String get setariProfilActualizareCVInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_cv_informatii_insuficiente'];

  }

  String get setariProfilActualizareCVAAparutOEroare {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_cv_a_aparut_o_eroare'];

  }

  String get setariProfilAdaugareEducatieFinalizataCuSucces {

    return _localizedValues[locale.languageCode]!['setari_profil']['adaugare_educatie_finalizata_cu_succes'];

  }

  String get setariProfilAdaugareEducatieApelInvalid {

    return _localizedValues[locale.languageCode]!['setari_profil']['adaugare_educatie_apel_invalid'];

  }

  String get setariProfilEducatiaNuAFostAdaugata {

    return _localizedValues[locale.languageCode]!['setari_profil']['educatia_nu_a_fost_adaugata'];

  }

  String get setariProfilAdaugareEducatieInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['setari_profil']['adaugare_educatie_informatii_insuficiente'];

  }

  String get setariProfilAdaugareEducatieAAparutOEroare {

    return _localizedValues[locale.languageCode]!['setari_profil']['adaugare_educatie_a_aparut_o_eroare'];

  }

  String get setariProfilActualizareEducatieFinalizataCuSucces {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_educatie_finalizata_cu_succes'];

  }

  String get setariProfilActualizareEducatieApelInvalid {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_educatie_apel_invalid'];

  }

  String get setariProfilEducatiaNuAFostActualizata {

    return _localizedValues[locale.languageCode]!['setari_profil']['educatia_nu_a_fost_actualizata'];

  }

  String get setariProfilActualizareEducatieInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_educatie_informatii_insuficiente'];

  }

  String get setariProfilActualizareEducatieAAparutOEroare {

    return _localizedValues[locale.languageCode]!['setari_profil']['actualizare_educatie_a_aparut_o_eroare'];

  }

  String get setariProfilEducatieStearsaCuSucces {

    return _localizedValues[locale.languageCode]!['setari_profil']['educatie_stearsa_cu_succes'];

  }

  String get setariProfilStergereEducatieApelInvalid {

    return _localizedValues[locale.languageCode]!['setari_profil']['stergere_educatie_apel_invalid'];

  }

  String get setariProfilEducatiaNuAPututFiStearsa {

    return _localizedValues[locale.languageCode]!['setari_profil']['educatia_nu_a_putut_fi_stearsa'];

  }

  String get setariProfilStergereEducatieInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['setari_profil']['stergere_educatie_informatii_insuficiente'];

  }

  String get setariProfilStergereEducatieAAparutOEroare {

    return _localizedValues[locale.languageCode]!['setari_profil']['stergere_educatie_a_aparut_o_eroare'];

  }


  // meniu_profil


  String get meniuProfilProfilulMeu {

    return _localizedValues[locale.languageCode]!['meniu_profil']['profilul_meu'];

  }

  String get meniuProfilIncasari {

    return _localizedValues[locale.languageCode]!['meniu_profil']['incasari'];

  }

  String get meniuProfilSetari {

    return _localizedValues[locale.languageCode]!['meniu_profil']['setari'];

  }

  String get meniuProfilTermeniSiConditii {

    return _localizedValues[locale.languageCode]!['meniu_profil']['termeni_si_conditii'];

  }

  // suma_de_incasat


  String get sumaDeIncasatIncasari {

    return _localizedValues[locale.languageCode]!['suma_de_incasat']['incasari'];

  }

  String get sumaDeIncasatSoldCurent {

    return _localizedValues[locale.languageCode]!['suma_de_incasat']['sold_curent'];

  }

  String get sumaDeIncasatLanguage {

    return _localizedValues[locale.languageCode]!['suma_de_incasat']['language'];

  }

  String get sumaDeIncasatLei {

    return _localizedValues[locale.languageCode]!['suma_de_incasat']['lei'];

  }

  String get sumaDeIncasatEuro {

    return _localizedValues[locale.languageCode]!['suma_de_incasat']['euro'];

  }

  String get sumaDeIncasatTranzactii {

    return _localizedValues[locale.languageCode]!['suma_de_incasat']['tranzactii'];

  }

  // incasari_filtrat


  String get incasariFiltratIncasari {

    return _localizedValues[locale.languageCode]!['incasari_filtrat']['incasari'];

  }

  // initializare_apel_video


  String get initializareApelVideoGlisatiInSus {

    return _localizedValues[locale.languageCode]!['initializare_apel_video']['glisati_in_sus'];

  }

  //line_chart_incasari


  String get lineChartIncasariZi {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['zi'];

  }

  String get lineChartIncasariSaptamana {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['saptamana'];

  }

  String get lineChartIncasariLuna {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['luna'];

  }

  String get lineChartIncasariAn {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['an'];

  }

  String get lineChartIncasariLuni {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['luni'];

  }

  String get lineChartIncasariMarti {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['marti'];

  }

  String get lineChartIncasariMiercuri {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['miercuri'];

  }

  String get lineChartIncasariJoi {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['joi'];

  }

  String get lineChartIncasariVineri {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['vineri'];

  }

  String get lineChartIncasariSambata {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['sambata'];

  }

  String get lineChartIncasariDuminica {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['duminica'];

  }

  String get lineChartIncasariIanuarie {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['ianuarie'];

  }

  String get lineChartIncasariMartie {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['martie'];

  }

  String get lineChartIncasariMai {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['mai'];

  }

  String get lineChartIncasariIulie {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['iulie'];

  }

  String get lineChartIncasariSeptembrie {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['septembrie'];

  }

  String get lineChartIncasariNoiembrie {

    return _localizedValues[locale.languageCode]!['line_chart_incasari']['noiembrie'];

  }


  //numar_pacienti_filtrat


  String get numarPacientiFiltratAlegePerioada {

    return _localizedValues[locale.languageCode]!['numar_pacienti_filtrat']['alege_perioada'];

  }


  //numar_pacienti


  String get numarPacientiSelecteazaPerioada {

    return _localizedValues[locale.languageCode]!['numar_pacienti']['selecteaza_perioada'];

  }

  String get numarPacientiBunVenit {

    return _localizedValues[locale.languageCode]!['numar_pacienti']['bun_venit'];

  }

  String get numarPacientiApelVideo {

    return _localizedValues[locale.languageCode]!['numar_pacienti']['apel_video'];

  }

  String get numarPacientiRecomandare {

    return _localizedValues[locale.languageCode]!['numar_pacienti']['recomandare'];

  }

  String get numarPacientiIntrebare {

    return _localizedValues[locale.languageCode]!['numar_pacienti']['intrebare'];

  }


  //numar_pacienti_widgets


  String get numarPacientiWidgetsApelVideo {

    return _localizedValues[locale.languageCode]!['numar_pacienti_widgets']['apel_video'];

  }

  String get numarPacientiWidgetsRecomandare {

    return _localizedValues[locale.languageCode]!['numar_pacienti_widgets']['recomandare'];

  }


  //range_picker_rating


  String get rangePickerRatingRatinguri {

    return _localizedValues[locale.languageCode]!['range_picker_rating']['rating_uri'];

  }


  //rating_filtrat


  String get ratingFiltratAlegePerioada {

    return _localizedValues[locale.languageCode]!['rating_filtrat']['alege_perioada'];

  }


  //rating


  String get ratingLimba {

    return _localizedValues[locale.languageCode]!['rating']['limba'];

  }

  String get ratingAlegePerioada {

    return _localizedValues[locale.languageCode]!['rating']['alege_perioada'];

  }

  String get ratingRatinguri {

    return _localizedValues[locale.languageCode]!['rating']['rating_uri'];

  }

  String get ratingRaspunde {

    return _localizedValues[locale.languageCode]!['rating']['raspunde'];

  }

  String get ratingModifica {

    return _localizedValues[locale.languageCode]!['rating']['modifica'];

  }

  String get ratingSterge {

    return _localizedValues[locale.languageCode]!['rating']['sterge'];

  }

  String get ratingRaspunsSalvatCuSucces {

    return _localizedValues[locale.languageCode]!['rating']['raspuns_salvat_cu_succes'];

  }

  String get ratingRaspundeLaFeedbackDinContMedicApelInvalid {

    return _localizedValues[locale.languageCode]!['rating']['raspunde_la_feedback_din_cont_medic_apel_invalid'];

  }

  String get ratingRaspundeLaFeedbackDinContMedicEroareLaAdaugareRaspuns {

    return _localizedValues[locale.languageCode]!['rating']['raspunde_la_feedback_din_cont_medic_eroare_la_adaugare_raspuns'];

  }

  String get ratingRaspundeLaFeedbackDinContMedicInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['rating']['raspunde_la_feedback_din_cont_medic_informatii_insuficiente'];

  }

  String get ratingRaspundeLaFeedbackDinContMedicAAparutOEroare {

    return _localizedValues[locale.languageCode]!['rating']['raspunde_la_feedback_din_cont_medic_a_aparut_o_eroare'];

  }

  String get ratingModificaRaspunsDeLaFeedbackRaspunsModificatCuSucces {

    return _localizedValues[locale.languageCode]!['rating']['modifica_raspuns_de_la_feedback_raspuns_modificat_cu_succes'];

  }

  String get ratingModificaRaspunsDeLaFeedbackApelInvalid {

    return _localizedValues[locale.languageCode]!['rating']['modifica_raspuns_de_la_feedback_apel_invalid'];

  }

  String get ratingModificaRaspunsDeLaFeedbackEroareLaModificareRaspuns {

    return _localizedValues[locale.languageCode]!['rating']['modifica_raspuns_de_la_feedback_eroare_la_modificare_raspuns'];

  }

  String get ratingModificaRaspunsDeLaFeedbackInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['rating']['modifica_raspuns_de_la_feedback_informatii_insuficiente'];

  }

  String get ratingModificaRaspunsDeLaFeedbackAAparutOEroare {

    return _localizedValues[locale.languageCode]!['rating']['modifica_raspuns_de_la_feedback_a_aparut_o_eroare'];

  }

  String get ratingStergeRaspunsDeLaFeedbackRaspunsStersCuSucces {

    return _localizedValues[locale.languageCode]!['rating']['sterge_raspuns_de_la_feedback_raspuns_sters_cu_succes'];

  }

  String get ratingStergeRaspunsDeLaFeedbackApelInvalid {

    return _localizedValues[locale.languageCode]!['rating']['sterge_raspuns_de_la_feedback_apel_invalid'];

  }

  String get ratingStergeRaspunsDeLaFeedbackEroareRaspunsulNuAPututFiSters {

    return _localizedValues[locale.languageCode]!['rating']['sterge_raspuns_de_la_feedback_eroare_raspunsul_nu_a_putut_fi_sters'];

  }

  String get ratingStergeRaspunsDeLaFeedbackInformatiiInsuficiente {

    return _localizedValues[locale.languageCode]!['rating']['sterge_raspuns_de_la_feedback_informatii_insuficiente'];

  }

  String get ratingStergeRaspunsDeLaFeedbackAAparutOEroare {

    return _localizedValues[locale.languageCode]!['rating']['sterge_raspuns_de_la_feedback_a_aparut_o_eroare'];

  }


  //rating_widgets


  String get ratingWidgetsLimba {

    return _localizedValues[locale.languageCode]!['rating_widgets']['limba'];

  }

  String get ratingWidgetsApelVideo {

    return _localizedValues[locale.languageCode]!['rating_widgets']['apel_video'];

  }

  String get ratingWidgetsRecomandare {

    return _localizedValues[locale.languageCode]!['rating_widgets']['recomandare'];

  }

  String get ratingWidgetsRaspunde {

    return _localizedValues[locale.languageCode]!['rating_widgets']['raspunde'];

  }


  //sume_incasari_filtrat


  String get sumeIncasariFiltratDeIncasat {

    return _localizedValues[locale.languageCode]!['sume_incasari_filtrat']['de_incasat'];

  }


  String get sumeIncasariFiltratLei {

    return _localizedValues[locale.languageCode]!['sume_incasari_filtrat']['lei'];

  }


  String get sumeIncasariFiltratEuro {

    return _localizedValues[locale.languageCode]!['sume_incasari_filtrat']['euro'];

  }


  String get sumeIncasariFiltratSoldCurent {

    return _localizedValues[locale.languageCode]!['sume_incasari_filtrat']['sold_curent'];

  }


  //termeni_si_conditii


  String get termeniSiConditiiTitlu {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['titlu'];

  }


  String get termeniSiConditiiUltimaActualizare {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['ultima_actualizare'];

  }


  String get termeniSiConditiiTextCentral1 {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['text_central1'];

  }


  String get termeniSiConditiiTextCentral2 {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['text_central2'];

  }


  String get termeniSiConditiiTextCentral3 {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['text_central3'];

  }


  String get termeniSiConditiiTextCentral4 {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['text_central4'];

  }


  String get termeniSiConditiiTextCentral5 {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['text_central5'];

  }


  String get termeniSiConditiiTextCentral6 {

    return _localizedValues[locale.languageCode]!['termeni_si_conditii']['text_central6'];

  }


  //vizualizare_analize


  String get vizualizareAnalizeOferaRecomandare {

    return _localizedValues[locale.languageCode]!['vizualizare_analize']['ofera_recomandare'];

  }

  String get vizualizareAnalizeIncarcaReteta {

    return _localizedValues[locale.languageCode]!['vizualizare_analize']['incarca_reteta'];

  }



}