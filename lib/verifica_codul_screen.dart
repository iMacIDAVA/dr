import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sos_bebe_profil_bebe_doctor/parola_noua_screen.dart';
//import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
//import 'package:auto_size_text/auto_size_text.dart';

import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
//import 'package:auto_size_text/auto_size_text.dart';

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();


class VerificaCodulScreen extends StatefulWidget 
{

  final String user;

  const VerificaCodulScreen({super.key, required this.user});

  @override
  State<VerificaCodulScreen> createState() => _VerificaCodulScreenState();

}

class _VerificaCodulScreenState extends State<VerificaCodulScreen> {
  final verificaCodulKey = GlobalKey<FormState>();

  String? currentPIN;

  bool isHidden = true;
  final controllerCode = TextEditingController();

  final FocusNode focusNodePhone = FocusNode();

  @override
  Widget build(BuildContext context) {

    LocalizationsApp l = LocalizationsApp.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 125),
                Center(
                  child: Text(
                    //'Verifică codul', //old IGV
                    l.verificaCodulTitlu,
                    style: GoogleFonts.rubik(
                        color: const Color.fromRGBO(14, 190, 127, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 70),
                Form(
                  key: verificaCodulKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width:250,
                        child:AutoSizeText.rich(// old value RichText(
                          TextSpan(
                            style: GoogleFonts.rubik(
                              color: const Color.fromRGBO(103, 114, 148, 1),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                //text: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod..' //old IGV
                                text: l.verificaCodulTextMijloc,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),  
                      const SizedBox(height: 35),
                      SizedBox(height: 80, width: 270,
                       child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: const Color.fromRGBO(205, 211, 223, 1)),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center( 
                            child: SizedBox(
                              width: 200,
                              height:80,  
                              child: Padding(
                                padding: const EdgeInsets.only(top: 17.0 ,right: 32 , left: 32),
                                child: PinCodeTextField(
                                  length: 4,
                                  //obscureText: false,
                                  textStyle: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  //animationType: AnimationType.fade,
                                  appContext: context,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.circle,
                                    borderRadius: BorderRadius.zero,
                                    fieldHeight: 15,
                                    fieldWidth: 15,
                                    activeFillColor: const Color.fromRGBO(14, 190, 127, 1),
                                    inactiveColor: const Color.fromRGBO(103, 114, 148, 1),
                                    inactiveFillColor: const Color.fromRGBO(103, 114, 148, 1),
                                    selectedFillColor: const Color.fromRGBO(103, 114, 148, 1),
                                    selectedColor: const Color.fromRGBO(103, 114, 148, 1),
                                    activeColor: const Color.fromRGBO(103, 114, 148, 1),
                                  ),
                                  animationDuration: const Duration(milliseconds: 300),
                                  //cursorColor: const Color.fromRGBO(103, 114, 148, 1),
                                  backgroundColor: Colors.transparent,
                                  enableActiveFill: true,
                                  //errorAnimationController: errorController,
                                  //controller: textEditingController,
                                  onCompleted: (v)
                                  {


                                  },
                                  onChanged: (value)
                                  {

                                    setState(() {
                                      currentPIN = value;
                                    });


                                  },
                                  beforeTextPaste: (text) {
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                ),
                              ),
                            ),  
                          ),
                        ),   
                      ),  
                      const SizedBox(height: 45),
                      
                      SizedBox(
                        width:250,
                        child:
                        GestureDetector(
                          onTap: () async
                          {                               
                            // http.Response? resTrimitePin;
                            // resTrimitePin = await trimitePinPentruResetareParolaMedic();
                            /*
                            if(context.mounted)
                            {
                              if (int.parse(resTrimitePin!.body) == 200)
                              {
                                Color backgroundColor = const Color.fromARGB(255, 14, 190, 127);
                                Color textColor = Colors.white;
                                showSnackbar(context, l.resetPasswordCodTrimisCuSucces,backgroundColor, textColor);
                              }
                              else 
                              {

                                Color backgroundColor = Colors.red;
                                Color textColor = Colors.black;
                                showSnackbar(context, l.resetPasswordAAparutOEroareLaExecutiaMetodei,backgroundColor, textColor);

                              }
                            }
                            */
                          },
                          child:
                          Center(
                            child:Text(
                              //'Timite din nou codul', //old IGV
                              l.verificaCodulTrimiteDinNouCodul, 
                              style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontWeight: FontWeight.w300, fontSize: 14))
                          ),
                        ),  
                      ), 
                    ],
                  ),
                ),
                const SizedBox(height: 115),
                SizedBox(
                  width: 160,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () async {
                      final isValidForm = verificaCodulKey.currentState!.validate();
                      if (isValidForm) 
                      { 
                        http.Response? resVerificaPin;

                        resVerificaPin = await verificaCodPinMedic();

                        if(context.mounted)
                        {
                          if (int.parse(resVerificaPin!.body) == 200)
                          {


                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //builder: (context) => const ServiceSelectScreen(),
                                builder: (context) => ParolaNouaScreen(user: widget.user),
                              )
                            );

                          }
                        }
                      }
                      
                      //Navigator.push(
                          //context,
                          //MaterialPageRoute(
                            //builder: (context) => const ServiceSelectScreen(),
                            //builder: (context) => const TestimonialScreen(),
                          //));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 190, 127, 1),
                        minimumSize: const Size.fromHeight(50), // NEW
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    child: Text(
                      //'Verifică', //old IGV
                      l.verificaCodulVerifica,
                      style: GoogleFonts.rubik(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300)),
                  ),
                ),  
                //const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<http.Response?> verificaCodPinMedic() async {

      LocalizationsApp l = LocalizationsApp.of(context)!;

      /*
      http.Response? res = await apiCallFunctions.getContClient(
        pUser: controllerEmail.text,
        pParola: controllerPass.text,
      );
      */

      String textMessage = '';
      Color backgroundColor = Colors.red;
      Color textColor = Colors.black;

      http.Response? resVerificaCodPin = await apiCallFunctions.verificaCodPinMedic(
        pUser: widget.user,
        pCodPIN: currentPIN ?? '1234',
      );

      if (int.parse(resVerificaCodPin!.body) == 200)
      {

        //SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString(pref_keys.userEmail, controllerEmail.text);

        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));


        //if (context.mounted)
        //{

          //textMessage = 'Cod verificat cu succes!'; //old IGV
          textMessage = l.verificaCodulCodVerificatCuSucces;

          backgroundColor = const Color.fromARGB(255, 14, 190, 127);
          textColor = Colors.white;
          //showSnackbar(context, "Cod verificat cu succes!",const Color.fromARGB(255, 14, 190, 127), Colors.white);

        //}

        //return resVerificaCodPin;

      }
      else if (int.parse(resVerificaCodPin.body) == 400)
      {


        //if (context.mounted)
        //{

          //textMessage = 'Apel invalid!'; //old IGV

          textMessage = l.verificaCodulApelInvalid;
          backgroundColor = Colors.red;
          textColor = Colors.black;
          //showSnackbar(context, "Apel invalid!", Colors.red, Colors.black);

        //}

        //return resVerificaCodPin;

      }
      else if (int.parse(resVerificaCodPin.body) == 401)
      {

        //prefs.setString(pref_keys.userEmail, controllerEmail.text);
        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

        //if (context.mounted)
        //{

          //textMessage = 'Eroare! Codul nu a putut fi verificat!'; //old IGV

          textMessage = l.verificaCodulEroareCodulNuAPututFiVerificat;
          backgroundColor = Colors.red;
          textColor = Colors.black;
          //showSnackbar(context, "Eroare! Codul nu a putut fi verificat!", Colors.red, Colors.black);

        //}

        //return resVerificaCodPin;

      }
      else if (int.parse(resVerificaCodPin.body) == 405)
      {

        

        //textMessage = 'Informații insuficiente!'; //old IGV

        textMessage = l.verificaCodulInformatiiInsuficiente;

        backgroundColor = Colors.red;
        textColor = Colors.black;
        //if (context.mounted)
        //{

          //showSnackbar(context, "Informații insuficiente!", Colors.red, Colors.black);

        //}
        
        //return resVerificaCodPin;

      }
      else if (int.parse(resVerificaCodPin.body) == 500)
      {


        //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
        textMessage = l.verificaCodulAAparutOEroareLaExecutiaMetodei;
        backgroundColor = Colors.red;
        textColor = Colors.black;

      }
      
      if (context.mounted)
      {
        showSnackbar(context, textMessage, backgroundColor, textColor);
        return resVerificaCodPin;
      }
      return null;

    }

    



  Future<http.Response?> trimitePinPentruResetareParolaMedic() async {

      
      LocalizationsApp l = LocalizationsApp.of(context)!;

      String textMessage = '';
      Color backgroundColor = Colors.red;
      Color textColor = Colors.black;

      http.Response? resTrimitePinPentruResetareParolaMedic = await apiCallFunctions.trimitePinPentruResetareParolaMedic(
        pUser: widget.user,
      );

      if (int.parse(resTrimitePinPentruResetareParolaMedic!.body) == 200)
      {

        //SharedPreferences prefs = await SharedPreferences.getInstance();
        //prefs.setString(pref_keys.userEmail, controllerEmail.text);

        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));


        //textMessage = 'Cod trimis cu succes!'; //old IGV
        textMessage = l.resetPasswordCodTrimisCuSucces;

        backgroundColor = const Color.fromARGB(255, 14, 190, 127);
        textColor = Colors.white;
        

      }
      else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 400)
      {


        //textMessage = 'Apel invalid!'; //old IGV
        textMessage = l.resetPasswordApelInvalid;
        backgroundColor = Colors.red;
        textColor = Colors.black;

      }
      else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 401)
      {

        //prefs.setString(pref_keys.userEmail, controllerEmail.text);
        //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5(controllerPass.text));

        //textMessage = 'Cont inexistent!'; //old IGV

        textMessage = l.resetPasswordContInexistent;
        backgroundColor = Colors.red;
        textColor = Colors.black;

      }
      else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 405)
      {



        //textMessage = 'Cont existent dar clientul nu are date de contact!'; //old IGV

        textMessage = l.resetPasswordContExistentDarClientulNuAreDateDeContact; //old IGV

        backgroundColor = Colors.red;
        textColor = Colors.black;

      }
      else if (int.parse(resTrimitePinPentruResetareParolaMedic.body) == 500)
      {


        //textMessage = 'A apărut o eroare la execuția metodei!'; //old IGV
        
        textMessage = l.resetPasswordAAparutOEroareLaExecutiaMetodei;
        backgroundColor = Colors.red;
        textColor = Colors.black;

      }

      if (context.mounted)
      {

        showSnackbar(context, textMessage, backgroundColor, textColor);

        return resTrimitePinPentruResetareParolaMedic;

      }
    
      return null;

    }

}