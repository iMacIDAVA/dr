import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/chat/chat_bubble.dart';
import 'package:sos_bebe_profil_bebe_doctor/chat/chat_textfield.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart'
    as pref_keys;
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';

class ChatDoctorScreen extends StatefulWidget {
  final ContMedicMobile medic;
  final ContClientMobile client;
  final int tipServiciu;

  const ChatDoctorScreen(
      {super.key,
      required this.medic,
      required this.tipServiciu,
      required this.client});

  @override
  State<ChatDoctorScreen> createState() => _ChatDoctorScreenState();
}

class _ChatDoctorScreenState extends State<ChatDoctorScreen> {
  bool isFirstEnterPage = true;
  ScrollController _controller = ScrollController();
  final ValueNotifier<bool> aRaspunsDoctorulNotifier = ValueNotifier(false);
  //!chat controller
  final TextEditingController _messageController = TextEditingController();
  List<ConversatieMobile> listaConversatii = [];
  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  ConversatieMobile? conversatiaMeaMobile;
  bool isDoneLoading = false;
  bool aRaspunsDoctorul = false;
  //! send function
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('user') ?? '';
      String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
      await apiCallFunctions.adaugaMesajDinContMedic(
        pUser: user,
        pParola: userPassMD5,
        pIdClient: widget.client.id.toString(),
        pMesaj: _messageController.text,
      );
      _messageController.clear();
    }
    isFirstEnterPage = false;
    setState(() {});
  }

  void getListaConversatii() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    listaConversatii = await apiCallFunctions.getListaConversatii(
          pUser: user,
          pParola: userPassMD5,
        ) ??
        [];
    listaConversatii.forEach((element) {
      if (widget.medic.id == element.idDestinatar &&
          element.idExpeditor == widget.client.id) {
        conversatiaMeaMobile = element;
      }
    });
    isDoneLoading = true;
    setState(() {});
  }

  Stream<List<MesajConversatieMobile>> streamListaMesaje() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    List<MesajConversatieMobile> mesajeConversatie = [];

    // Initial fetch of messages
    mesajeConversatie = await apiCallFunctions.getListaMesajePeConversatie(
          pUser: user,
          pParola: userPassMD5,
          pIdConversatie: widget.medic.id.toString(),
        ) ??
        [];
    yield mesajeConversatie;
    // Subsequent updates
    while (true) {
      await Future.delayed(Duration(seconds: 5));

      // Fetch messages excluding the user's own messages
      List<MesajConversatieMobile> messages =
          await apiCallFunctions.getListaMesajePeConversatie(
                pUser: user,
                pParola: userPassMD5,
                pIdConversatie: widget.medic.id.toString(),
              ) ??
              [];

      // Yield only if there are new messages from other users
      if (messages.isNotEmpty) {
        if (isFirstEnterPage == false) {
          if (messages[messages.length - 1].idExpeditor == widget.medic.id) {
            aRaspunsDoctorulNotifier.value = true;
            //!adauga pentru doctor
            // Future.delayed(Duration(seconds: 60), () async {
            //   // FacturaClientMobile? utlimaFactura;

            //   SharedPreferences prefs = await SharedPreferences.getInstance();

            //   String user = prefs.getString('user') ?? '';
            //   String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
            //   utlimaFactura = await apiCallFunctions.getUltimaFactura(
            //       pUser: user, pParola: userPassMD5);
            //   Navigator.push(context, MaterialPageRoute(builder: (context) {
            //     return FacturaScreen(
            //       facturaDetalii: utlimaFactura!,
            //       user: user,
            //       isFromChat: true,
            //     );
            //   }));
            // });
          }
        }

        yield messages;
      }
    }
  }


  @override
  void initState() {
    super.initState();
    getListaConversatii();
  }

  //! timer
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   leading: GestureDetector(
        //     onTap: () => Navigator.pop(context),
        //     child: const Icon(
        //       Icons.arrow_back,
        //       size: 28,
        //       color: Color(0xffCDD3DF),
        //     ),
        //   ),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: GestureDetector(
        //         onTap: () => print('ceva'),
        //         child: Container(
        //           height: 45,
        //           width: 45,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: const Color(0xff0EBE7F).withOpacity(0.1),
        //           ),
        //           child: const Center(
        //             child: Icon(
        //               Icons.money,
        //               color: Color(0xff0EBE7F),
        //               size: 20,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: GestureDetector(
        //         onTap: () => print('ceva'),
        //         child: Container(
        //           height: 45,
        //           width: 45,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: const Color(0xff0EBE7F).withOpacity(0.1),
        //           ),
        //           child: const Center(
        //             child: Icon(
        //               Icons.call,
        //               color: Color(0xff0EBE7F),
        //               size: 20,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: isDoneLoading
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      //display name & photo
                      _topAppBar(),
                      const SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: _buildMessageBuilder(),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder(
                        valueListenable: aRaspunsDoctorulNotifier,
                        builder: (context, value, child) {
                          if (value == true) {
                            return _maiPuneIntrbeare();
                          } else {
                            return _buildMessageInput();
                          }
                        },
                      ),
                      // _maiPuneIntrbeare(),

                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()));
  }

  Widget _buildMessageBuilder() {
    return StreamBuilder(
      stream: streamListaMesaje(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Eroare ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Se incarca..');
        }
        // return Text(snapshot.data!.length.toString());
        return ListView.builder(
          controller: _controller,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _controller.jumpTo(_controller.position.maxScrollExtent);
            });
            return _buildMessageItem(snapshot.data![index]);
          },
        );
        // return ListView.builder(
        //     itemCount: snapshot.data!.length + 1, // 3 elemente : index ==  2
        //     itemBuilder: (context, index) {
        //       if (index == snapshot.data!.length) {
        //         if (snapshot.data![index - 1].senderId == "2") {
        //           return _maiPuneIntrbeare();
        //         } else {
        //           return Container();
        //         }
        //       }
        //       return _buildMessageItem(snapshot.data![index]);
        //     });
      },
    );
  }

  Widget _maiPuneIntrbeare() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Mai doriti o intrebare?",
            style: TextStyle(
                color: Color(0xff0EBE7F),
                fontSize: 24,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async {
                  // FacturaClientMobile? utlimaFactura;

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // utlimaFactura = await apiCallFunctions.getUltimaFactura(
                  //     pUser: user, pParola: userPassMD5);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return FacturaScreen(
                  //     facturaDetalii: utlimaFactura!,
                  //     user: user,
                  //     isFromChat: true,
                  //   );
                  // }));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 64,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: Colors.grey[300]!)),
                  child: Column(
                    children: [
                      Text(
                        "NU",
                        style: TextStyle(
                            color: Colors.grey[500]!,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Va multumesc!",
                        style: TextStyle(
                            color: Colors.grey[500]!,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) {
                  //     return ConfirmareServiciiScreen(
                  //         pret: widget.pret,
                  //         tipServiciu: widget.tipServiciu,
                  //         contClientMobile: widget.contClientMobile,
                  //         medicDetalii: widget.medic);
                  //   },
                  // ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xff0EBE7F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        "DA",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Mai doresc o intrebare",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Widget _trimiteAtasament() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              _updatePhotoDialog();
            },
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 46,
                width: 45,
                decoration: BoxDecoration(
                    color: const Color(0xff0EBE7F),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 25,
                    color: Colors.white,
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: SizedBox(
              height: 45,
              child: MyTextField(
                textEditingController: _messageController,
                hintText: 'Enter message',
                obscureText: false,
              ),
            ),
          ),
          //send button

          GestureDetector(
            onTap: sendMessage,
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 46,
                width: 45,
                decoration: BoxDecoration(
                    color: const Color(0xff0EBE7F),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Icon(
                    Icons.send,
                    size: 25,
                    color: Colors.white,
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    MesajConversatieMobile message,
  ) {
    //align the message bubble based on who sent it
    var alignment = (message.idExpeditor == widget.medic.id)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: (message.idExpeditor == widget.medic.id)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisAlignment: (message.idExpeditor == widget.medic.id)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          ChatBubble(
            message: message.comentariu,
            sentByCurrentUser: (message.idExpeditor == widget.medic.id),
          )
        ],
      ),
    );
  }

  Widget _topAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.grey[400]),
              child: conversatiaMeaMobile!.linkPozaProfil.isNotEmpty
                  ? Image.network(conversatiaMeaMobile!.linkPozaProfil)
                  : Image.asset(
                      './assets/images/user_fara_poza.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
              //! to implement
              // child: Image.network(""),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 15,
                width: 15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff0EBE7F),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        //! display nume doctor + iconita

        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${conversatiaMeaMobile!.titulaturaDestinatar} ${conversatiaMeaMobile!.identitateDestinatar}",
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff0EBE7F),
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                conversatiaMeaMobile!.locDeMunca,
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff677294),
                    fontWeight: FontWeight.w700),
              ),
              Text(
                conversatiaMeaMobile!.specializarea,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff677294),
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  File _selectedImage = File('');

  Future<void> _takePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() async {
        _selectedImage = File(photo.path);

        // await apiCallFunctions.adaugaMesajCuAtasamentDinContClient(
        //   pExtensie: '.jpg',
        //   pUser: user,
        //   pParola: userPassMD5,
        //   pIdMedic: widget.medic.id.toString(),
        //   denumireFisier: _selectedImage.path,
        //   mesaj: _messageController.text,
        //   pBitiDocument: _selectedImageBytes.toString(),
        // );
      });
      _messageController.clear();
      setState(() {});
    }
  }

  Future<void> _chooseFromGallery() async {
    Uint8List? _selectedImageBytes;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      final bytes = await photo.readAsBytes();
      setState(() async {
        _selectedImage = File(photo.path);
        _selectedImageBytes = Uint8List.fromList(bytes);

        // await apiCallFunctions.adaugaMesajCuAtasamentDinContClient(
        //   pExtensie: '.jpg',
        //   pUser: user,
        //   pParola: userPassMD5,
        //   pIdMedic: widget.medic.id.toString(),
        //   denumireFisier: _selectedImage.path,
        //   mesaj: _messageController.text,
        //   pBitiDocument: _selectedImageBytes.toString(),
        // );
      });
      _messageController.clear();
      setState(() {});
    }
  }

  _updatePhotoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Trimite atașament"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galerie'),
                  onTap: () {
                    Navigator.pop(context);
                    _chooseFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
