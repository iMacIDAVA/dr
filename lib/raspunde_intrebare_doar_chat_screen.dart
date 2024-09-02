import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//import 'package:flutter_chat_ui/flutter_chat_ui.dart';
//import 'package:auto_size_text/auto_size_text.dart';
//import 'package:sos_bebe_profil_bebe_doctor/utils/utils_widgets.dart';
import 'package:open_filex/open_filex.dart';
//import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import './utils/chat.dart' as chat;
import './utils/chat_l10n.dart' as chat_l10n;
import './utils/chat_theme.dart' as chat_theme;
import './utils/typing_indicator.dart' as typing_indicator;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;

import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';

ApiCallFunctions apiCallFunctions = ApiCallFunctions();

List<ConversatieMobile> listaConversatii = [];

class RaspundeIntrebareDoarChatScreen extends StatefulWidget {

  final String textNume;
  final String textIntrebare;
  final String textRaspuns;

  final int idClient;
  final int idMedic;
  final String iconPathPacient;
  final String numePacient;
  final bool onlineStatus;


  RaspundeIntrebareDoarChatScreen({

    super.key, required this.textNume, required this.textIntrebare, required this.textRaspuns, required this.idClient, required this.idMedic, required this.iconPathPacient,
    required this.numePacient, required this.onlineStatus,

  });

  @override
  State<RaspundeIntrebareDoarChatScreen> createState() => _RaspundeIntrebareDoarChatScreenState();

}

class _RaspundeIntrebareDoarChatScreenState extends State<RaspundeIntrebareDoarChatScreen> {

  String textNume = '';
  String textIntrebare = '';
  String textRaspuns = '';

  List<types.Message> _messages = [];

  List<types.TextMessage> newMessages = [];

  types.User _user = const types.User(
    id: '-1',
  );


/*
  List<types.Message> _messages = [];

  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );
*/

  //final _user = const types.User(id: '12345', imageUrl: 'https://i.pravatar.cc/300', firstName: 'Test', lastName: 'Test');

  @override
  initState(){

    super.initState();

    /* //de completat IGV

    _user = types.User(
      id: widget.contMedicMobile.id.toString(),
    );
    */

    //textNume = '';
    //textIntrebare = '';
    //textRaspuns = '';
    
    
    getListaConversatii();

    Timer.periodic(new Duration(seconds: 5), (timer) {

      _loadMessagesFromList();
      if (_messages.length != newMessages.length)
      {
        setState(() {
          _messages = newMessages;
        });
      }

    });

    //_loadMessages();

  }

  

  void getListaConversatii() async
  {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

    String user = prefs.getString('user')??'';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5)??'';

    //prefs.setString(pref_keys.userPassMD5, apiCallFunctions.generateMd5('123456')); //old IGV

    //String? userPassMD5 = prefs.getString(pref_keys.userPassMD5);

    /*
    String? user = 'george.iordache@gmail.com';

    String? userPassMD5 = apiCallFunctions.generateMd5('123456');
    */
    
    //SharedPreferences prefs = await SharedPreferences.getInstance(); 
    
    //String user = prefs.getString('user')??'';
    //String userPassMD5 = prefs.getString(pref_keys.userPassMD5)??'';

    listaConversatii = await apiCallFunctions.getListaConversatii(
      pUser: user,
      pParola: userPassMD5,
    )?? [];

    print('listaConversatii length: ${listaConversatii.length} ${listaConversatii[0].idDestinatar} ${listaConversatii[0].idExpeditor} ${listaConversatii[0].id.toString()}');
    //print('listaConversatii  id medic: ${widget.medic.id} id client: ${widget.contClientMobile.id}');

  }

  

  void _loadMessagesFromList() async {

    print('_loadMessagesFromList Aici');
    
    List<MesajConversatieMobile> listaMesaje = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //prefs.setString(pref_keys.userPassMD5, controllerEmail.text);

    String user = prefs.getString('user')??'';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5)??'';

    //String? user = 'george.iordache@gmail.com';

    //String? userPassMD5 = apiCallFunctions.generateMd5('123456');

    listaConversatii.retainWhere((element) {
     //do something when textType == "birth"
        return ((element.idExpeditor == widget.idMedic) && (element.idExpeditor == widget.idClient));
      }
    );

    if (listaConversatii.isNotEmpty)
    {

      listaMesaje = await apiCallFunctions.getListaMesajePeConversatie(
        pUser: user,
        pParola: userPassMD5,
        pIdConversatie: listaConversatii[0].id.toString(),
      )?? [];

    
      //final response = await rootBundle.loadString('./assets/messages.json');

      //print('test');

      /*
      final messages = listaMesaje
          .map((e) => types.TextMessage(id:e.id.toString(), author:types.User(id:e.idExpeditor.toString() == _user.id.toString()?_user.id:e.idExpeditor.toString()), text:e.comentariu, createdAt:e.dataMesaj.millisecondsSinceEpoch))
          .toList();
      */
      newMessages = listaMesaje
          .map((e) => types.TextMessage(id:e.id.toString(), author:types.User(id:e.idExpeditor.toString() == widget.idMedic.toString() ? widget.idMedic.toString() : e.idExpeditor.toString()), text:e.comentariu, createdAt:e.dataMesaj.millisecondsSinceEpoch))
          .toList();
    }

  }


  void _addMessage(types.Message message) {

    setState(() {
      _messages.insert(0, message);
    });

  }

  /* 
  void _handleAttachmentPressed() {
    
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Imagine'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Fișier'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Anulează'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } 
  */

  /*
  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }
  */

  /*
  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);

    }
  }
  */

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {

          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  )
  {

    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });

  }

  void _handleSendPressed(types.PartialText message) {
    
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);

  }

  void _loadMessages() async {

    final response = await rootBundle.loadString('./assets/messages.json');

    print('test');

    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  void callbackTextIntrebare(String newTextIntrebare) {
    setState(() {

      textIntrebare = newTextIntrebare;

      // ignore: avoid_print
      //print('is checked alergic: ' + isAlergic.toString());

    });
  }
  
  void callbackTextRaspuns(String newTextRaspuns) {
    setState(() {
      textRaspuns = newTextRaspuns;

      // ignore: avoid_print
      //print('is checked alergic: ' + isAlergic.toString());

    });
  }

Future<http.Response?> adaugaMesajDinContMedic(String mesaj) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

        
    /*
    String user = prefs.getString('user')??'';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5)??'';
    */

    
    String? user = 'george.iordache@gmail.com';

    String? userPassMD5 = apiCallFunctions.generateMd5('123456');

    /*
    String textMessage = '';
    Color backgroundColor = Colors.red;
    Color textColor = Colors.black;
    */
    
    http.Response? resAdaugaMesaj = await apiCallFunctions.adaugaMesajDinContMedic(
      pUser: user,
      pParola: userPassMD5,
      pIdClient: widget.idClient.toString(),
      pMesaj: mesaj,
    );


    print('adaugaMesajDinContMedic resAdaugaMesaj.body ${resAdaugaMesaj!.body}');


    if (int.parse(resAdaugaMesaj!.body) == 200)
    {

/*
      setState(() {

        feedbackCorect = true;
        showButonTrimiteTestimonial = false;

      });
*/

      print('Mesaj adăugat cu succes!');

    }
    else if (int.parse(resAdaugaMesaj.body) == 400)
    {

      /*
      setState(() {

        feedbackCorect = false;
        showButonTrimiteTestimonial = true;

      });
      */

      print('Apel invalid');

      /*
      textMessage = 'Apel invalid!';
      backgroundColor = Colors.red;
      textColor = Colors.black;
      */

    }
    else if (int.parse(resAdaugaMesaj!.body) == 401)
    {
      
      print('Eroare la adăugare mesaj!');
      /*
      setState(() {

        feedbackCorect = false;
        showButonTrimiteTestimonial = true;

      });
      
      textMessage = 'Feedback-ul nu a fost trimis!';
      backgroundColor = Colors.red;
      textColor = Colors.black;
      */

    }
    else if (int.parse(resAdaugaMesaj!.body) == 405)
    {

      print('Informatii insuficiente');

      /*
      setState(() {

        feedbackCorect = false;
        showButonTrimiteTestimonial = true;

      });

      print('Informații insuficiente');
    
      
      textMessage = 'Informații insuficiente!';
      backgroundColor = Colors.red;
      textColor = Colors.black;
      */

    }
    else if (int.parse(resAdaugaMesaj!.body) == 500)
    {


      print('A apărut o eroare la execuția metodei');

      /*
        setState(() {

          feedbackCorect = false;
          showButonTrimiteTestimonial = true;

        });

        print('A apărut o eroare la execuția metodei');
        
        textMessage = 'A apărut o eroare la execuția metodei!';
        backgroundColor = Colors.red;
        textColor = Colors.black;
      */

    }

    /*
    if (context.mounted)
    {

      showSnackbar(context, textMessage, backgroundColor, textColor);

      return resAdaugaFeedback;

    }
    */
    
    return null;

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        title: const RaspundeIntrebareTopIconsTextWidget(iconPath: './assets/images/raspunde_intrebare_pacienta.png', textNume: 'Nume pacienta',),
      ),
      body:
      //const RaspundeIntrebareTopIconsTextWidget(iconPath: './assets/images/raspunde_intrebare_pacienta.png', textNume: 'Nume pacienta',),
      chat.Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        //onAttachmentPressed: _handleAttachmentPressed,
        onMessageTap: _handleMessageTap,
        onPreviewDataFetched: _handlePreviewDataFetched,
        showUserAvatars: true,
        showUserNames: true,
        typingIndicatorOptions : const typing_indicator.TypingIndicatorOptions(),
        //l10n: const ChatL10nRo().toChatL10n,
        l10n: const chat_l10n.ChatL10nRo(),
        theme: const chat_theme.DefaultChatTheme(
          inputBackgroundColor: Color.fromRGBO(255, 255, 255, 1), // Color.fromRGBO(30, 214, 158, 1),
          inputTextColor: Color.fromRGBO(103, 114, 148, 1), // Color.fromRGBO(30, 214, 158, 1),
          //backgroundColor: Color.fromRGBO(14, 190, 127, 1), 
          primaryColor: Color.fromRGBO(14, 190, 127, 1),
                     
        ),
      ),
      //Column( 
      //  children: [
          //const RaspundeIntrebareTopIconsTextWidget(iconPath: './assets/images/raspunde_intrebare_pacienta.png', textNume: 'Nume pacienta',),
      //    const InkWell(
      //      child: ChatWidget(),
      //      ),  
      //    ),  
      //  ],
      //),
    );
  }
}

// ignore: must_be_immutable
class RaspundeIntrebareTopIconsTextWidget extends StatelessWidget {
  
  final String iconPath;
  final String textNume;
    
  const RaspundeIntrebareTopIconsTextWidget({super.key, required this.iconPath, required this.textNume});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            IconButton(
              onPressed: () => Navigator.pop(context), 
              icon: Image.asset('./assets/images/inapoi_chat_icon.png'),
              color: const Color.fromRGBO(103, 114, 148, 1),
            ),
            const SizedBox(width: 5),
            CircleAvatar(foregroundImage: AssetImage(iconPath), radius: 25),
            const SizedBox(width: 15),
            Text(textNume, style: GoogleFonts.rubik(color: const Color.fromRGBO(14, 190, 127, 1), fontSize: 12, fontWeight: FontWeight.w500)),
            //const SizedBox(width: 160),
          ],
        ),
      ],
    );
  }
}