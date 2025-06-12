import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:sos_bebe_profil_bebe_doctor/fix/servises%20/services.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;
import 'package:shared_preferences/shared_preferences.dart';
import '../chestionar_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../intro/intro_screen.dart';



class ChatScreen extends StatefulWidget {
  final bool isDoctor;
  final String doctorId;
  final String patientId;
  final String doctorName;
  final String patientName;
  final String chatRoomId;
  final int sessionID;


  const ChatScreen({
    Key? key,
    required this.isDoctor,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.patientName,
    required this.chatRoomId,
  required this.sessionID,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConsultationService _consultationService = ConsultationService();


  String? _fileName;
  String? _fileExtension;
  String? _fileBase64;
  String? _uploadedFileUrl;
  bool _isLoading = false;
  String? _errorMessage;

  late String currentUserId;
  late String currentUserName;
  late String otherUserId;
  late String otherUserName;

  @override
  void initState() {
    super.initState();
    if (widget.isDoctor) {
      currentUserId = widget.doctorId;
      currentUserName = widget.doctorName;
      otherUserId = widget.patientId;
      otherUserName = widget.patientName;
    } else {
      currentUserId = widget.patientId;
      currentUserName = widget.patientName;
      otherUserId = widget.doctorId;
      otherUserName = widget.doctorName;
    }

    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    try {
      final chatRoomRef = _firestore.collection('chat_rooms').doc(widget.chatRoomId);
      final chatRoomSnapshot = await chatRoomRef.get();
      if (!chatRoomSnapshot.exists) {
        await chatRoomRef.set({
          'createdAt': FieldValue.serverTimestamp(),
          'participants': [widget.doctorId, widget.patientId],
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing chat room: $e')),
        );
      }
    }
  }

  void _sendMessage({String? fileUrl, String? fileName}) async {
    if (_messageController.text.trim().isEmpty && fileUrl == null) return;

    final message = {
      'senderId': currentUserId,
      'senderName': currentUserName,
      'type': fileUrl != null ? 'file' : 'text',
      'message': fileUrl != null ? (fileName ?? '') : _messageController.text.trim(),
      'fileUrl': fileUrl,
      'fileName': fileName,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add(message);
      _messageController.clear();
      setState(() {
        _uploadedFileUrl = null;
        _fileName = null;
        _fileExtension = null;
        _fileBase64 = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        _fileName = path.basenameWithoutExtension(file.path);
        _fileExtension = path.extension(file.path);

        List<int> fileBytes = await file.readAsBytes();
        _fileBase64 = base64Encode(fileBytes);

        setState(() {
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = 'No file selected';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking file: $e';
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_fileBase64 == null || _fileName == null || _fileExtension == null) {
      setState(() {
        _errorMessage = 'Please select a file first';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user ="dr@d.com";
      String userPassMD5 ="e10adc3949ba59abbe56e057f20f883e";
      String idClient = "9"; // Use dynamic ID

      print("=== Upload Debug Info ===");
      print("User: $user");
      print("Password MD5: $userPassMD5");
      print("Client ID: $idClient");
      print("File Name: $_fileName");
      print("File Extension: $_fileExtension");
      print("File Base64 Length: ${_fileBase64?.length}");
      print("API Key: 6nDjtwV4kPUsIuBtgLhV4bTZNerrxzThPGImSsFa");

      String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
        pCheie: '6nDjtwV4kPUsIuBtgLhV4bTZNerrxzThPGImSsFa',
        pUser: user,
        pParolaMD5: userPassMD5,
        IdClient: idClient,
        pMesaj: "File Attachment: $_fileName$_fileExtension",
        pDenumireFisier: _fileName!,
        pExtensie: _fileExtension!,
        pSirBitiDocument: _fileBase64!,
      );

      print("=== Upload Response ===");
      print("File URL: $fileUrl");

      setState(() {
        _isLoading = false;
        if (fileUrl != null) {
          fileUrl = fileUrl?.trim();
          fileUrl = Uri.encodeFull(fileUrl!);
          _uploadedFileUrl = fileUrl;
          _errorMessage = null;
          _sendMessage(fileUrl: fileUrl, fileName: '$_fileName$_fileExtension');
        } else {
          _errorMessage = 'Upload failed - no URL returned';
        }
      });
    } catch (e) {
      print("=== Upload Error ===");
      print("Error details: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error uploading file: $e';
      });
    }
  }

  Future<void> _openFile(String url, String fileName, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('File: $fileName'),
        content: const Text('Would you like to view or download the file?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final cleanUrl = url.trim();
              final uri = Uri.parse(cleanUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open file')),
                );
              }
            },
            child: const Text('View'),
          ),
          TextButton(
            onPressed: () async {

            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }


  Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
    final timestamp = (message['timestamp'] as Timestamp?)?.toDate();
    final formattedTime = timestamp != null ? DateFormat('HH:mm').format(timestamp) : '';
    final isFile = message['type'] == 'file';

    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isMe ? Color(0xFF62CD9C) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: isFile
              ? GestureDetector(
            onTap: () async {
              String url = message['fileUrl'];
              final cleanUrl = url.trim();
              final uri = Uri.parse(cleanUrl);
              if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
              ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open file')),
              );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Image.asset('assets/img.png' , height: 150,),
                const SizedBox(width: 8),
                Icon(
                  Icons.download,
                  color: isMe ? Colors.white : Colors.blue,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
              ],
            ),
            // child: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     _getFileIcon(message['fileName'] ?? 'file'),
            //     const SizedBox(width: 8),
            //     Flexible(
            //       child: Text(
            //         message['fileName'] ?? 'File',
            //         style: TextStyle(
            //           color: isMe ? Colors.white : Colors.blue,
            //           decoration: TextDecoration.underline,
            //           fontSize: 16.0,
            //         ),
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
          )
              : Text(
            message['message'] ?? '',
            style: TextStyle(
              fontSize: 16.0,
              color: isMe ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            formattedTime,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getFileIcon(String fileName) {
    String extension = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png'].contains(extension)) {
      return Image.network(
        _uploadedFileUrl ?? '',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image,
          color: Colors.white,
          size: 30,
        ),
      );
    }
    IconData icon;
    switch (extension) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        break;
      default:
        icon = Icons.insert_drive_file;
    }
    return Icon(icon, color: Colors.white, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF62CD9C),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isDoctor ? widget.patientName : widget.doctorName,
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Send exit message to Firestore
                  _messageController.text = 'Doctorul a părăsit chat-ul. Vă rugăm să salvați orice document înainte de a părăsi.' ;
                   _sendMessage();
                  await _consultationService.updateConsultationStatus(
                    widget.sessionID,
                    'callEnded',
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chat încheiat cu succes')),
                    );
                  Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const IntroScreen()), (Route<dynamic> route) => false,  );                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Eroare la încheierea chat-ului: ${e.toString()}')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                'Ieși din chat',
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chat_rooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data?.docs ?? [];

                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index].data() as Map<String, dynamic>?;
                    if (message == null) {
                      return SizedBox.shrink();
                    }
                    final isMe = message['senderId'] == currentUserId;
                    return _buildMessage(message, isMe);
                  },
                );
              },
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          if (_errorMessage != null)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF62CD9C)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Color(0xFF62CD9C), width: 2.0),
                      ),
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF62CD9C),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.attach_file, color: Colors.white),
                    onPressed: () async {
                      await _pickFile();
                      if (_fileBase64 != null) {
                        await _uploadFile();
                      }
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF62CD9C),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}



// class ChatScreen extends StatefulWidget {
//   final bool isDoctor;
//
//   const ChatScreen({Key? key, required this.isDoctor}) : super(key: key);
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   String? _fileName;
//   String? _fileExtension;
//   String? _fileBase64;
//   String? _uploadedFileUrl;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   static const String doctorId = 'DOCTOR_12345';
//   static const String doctorName = 'Dr. Smith';
//   static const String patientId = 'PATIENT_67890';
//   static const String patientName = 'John Doe';
//
//
//
//   late String chatRoomId;
//   late String currentUserId;
//   late String currentUserName;
//   late String otherUserId;
//   late String otherUserName;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.isDoctor) {
//       currentUserId = doctorId;
//       currentUserName = doctorName;
//       otherUserId = patientId;
//       otherUserName = patientName;
//     } else {
//       currentUserId = patientId;
//       currentUserName = patientName;
//       otherUserId = doctorId;
//       otherUserName = doctorName;
//     }
//
//     final ids = [currentUserId, otherUserId]..sort();
//     chatRoomId = '${ids[0]}_${ids[1]}';
//
//     _initializeChatRoom();
//   }
//
//   Future<void> _initializeChatRoom() async {
//     try {
//       final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);
//       final chatRoomSnapshot = await chatRoomRef.get();
//       if (!chatRoomSnapshot.exists) {
//         await chatRoomRef.set({
//           'createdAt': FieldValue.serverTimestamp(),
//           'participants': [doctorId, patientId],
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error initializing chat room: $e')),
//         );
//       }
//     }
//   }
//
//   void _sendMessage({String? fileUrl, String? fileName}) async {
//     if (_messageController.text.trim().isEmpty && fileUrl == null) return;
//
//     final message = {
//       'senderId': currentUserId,
//       'senderName': currentUserName,
//       'type': fileUrl != null ? 'file' : 'text',
//       'message': fileUrl != null ? (fileName ?? '') : _messageController.text.trim(),
//       'fileUrl': fileUrl,
//       'fileName': fileName,
//       'timestamp': FieldValue.serverTimestamp(),
//     };
//
//     try {
//       await _firestore
//           .collection('chat_rooms')
//           .doc(chatRoomId)
//           .collection('messages')
//           .add(message);
//       _messageController.clear();
//       setState(() {
//         _uploadedFileUrl = null;
//         _fileName = null;
//         _fileExtension = null;
//         _fileBase64 = null;
//       });
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error sending message: $e')),
//         );
//       }
//     }
//   }
//
//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         File file = File(result.files.single.path!);
//         _fileName = path.basenameWithoutExtension(file.path);
//         _fileExtension = path.extension(file.path);
//
//         List<int> fileBytes = await file.readAsBytes();
//         _fileBase64 = base64Encode(fileBytes);
//
//         setState(() {
//           _errorMessage = null;
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'No file selected';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error picking file: $e';
//       });
//     }
//   }
//
//   Future<void> _uploadFile() async {
//     if (_fileBase64 == null || _fileName == null || _fileExtension == null) {
//       setState(() {
//         _errorMessage = 'Please select a file first';
//       });
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String user = prefs.getString('user') ?? '';
//       String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//       String idClient = prefs.getString(pref_keys.userId) ?? '';
//
//       print("user");
//       print(user);
//       print("userPassMD5");
//       print(userPassMD5);
//       print("idClient");
//       print(idClient);
//
//
//       String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
//         pCheie: '6nDjtwV4kPUsIuBtgLhV4bTZNerrxzThPGImSsFa',
//         pUser: user,
//         pParolaMD5: userPassMD5,
//         IdClient: idClient,
//         pMesaj: "File Attachment: $_fileName$_fileExtension",
//         pDenumireFisier: _fileName!,
//         pExtensie: _fileExtension!,
//         pSirBitiDocument: _fileBase64!,
//       );
//       setState(() {
//         _isLoading = false;
//         if (fileUrl != null) {
//           // Trim and encode the URL
//           fileUrl = fileUrl?.trim(); // Remove trailing/leading spaces
//           fileUrl = Uri.encodeFull(fileUrl!); // Encode spaces and special characters
//           _uploadedFileUrl = fileUrl;
//           _errorMessage = null;
//           // Send file message to Firestore
//           _sendMessage(fileUrl: fileUrl, fileName: '$_fileName$_fileExtension');
//         } else {
//           _errorMessage = 'Upload failed';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _errorMessage = 'Error uploading file: $e';
//       });
//     }
//   }
//
//   Future<void> _openFile(String url, String fileName, BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('File: $fileName'),
//         content: const Text('Would you like to view or download the file?'),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               // Ensure URL is trimmed and valid
//               final cleanUrl = url.trim();
//               final uri = Uri.parse(cleanUrl);
//               if (await canLaunchUrl(uri)) {
//                 await launchUrl(uri, mode: LaunchMode.externalApplication);
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Could not open file')),
//                 );
//               }
//             },
//             child: const Text('View'),
//           ),
//           TextButton(
//             onPressed: () async {
//
//             },
//             child: const Text('Download'),
//           ),
//         ],
//       ),
//     );
//   }
//   // Future<void> _uploadFile() async {
//   //   if (_fileBase64 == null || _fileName == null || _fileExtension == null) {
//   //     setState(() {
//   //       _errorMessage = 'Please select a file first';
//   //     });
//   //     return;
//   //   }
//   //   setState(() {
//   //     _isLoading = true;
//   //     _errorMessage = null;
//   //   });
//   //   try {
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     String user = prefs.getString('user') ?? '';
//   //     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//   //     String idClient = prefs.getString(pref_keys.userId) ?? '';
//   //
//   //     String? fileUrl = await apiCallFunctions.adaugaMesajCuAtasamentDinContMedic(
//   //       pCheie: '6nDjtwV4kPUsIuBtgLhV4bTZNerrxzThPGImSsFa',
//   //       pUser: user,
//   //       pParolaMD5: userPassMD5,
//   //       IdClient: idClient,
//   //       pMesaj: "File Attachment: $_fileName$_fileExtension",
//   //       pDenumireFisier: _fileName!,
//   //       pExtensie: _fileExtension!,
//   //       pSirBitiDocument: _fileBase64!,
//   //     );
//   //     setState(() {
//   //       _isLoading = false;
//   //       if (fileUrl != null) {
//   //         _uploadedFileUrl = fileUrl.trim();
//   //         _errorMessage = null;
//   //         // Send file message to Firestore
//   //         _sendMessage(fileUrl: fileUrl, fileName: '$_fileName$_fileExtension'.trim());
//   //       } else {
//   //         _errorMessage = 'Upload failed';
//   //       }
//   //     });
//   //   } catch (e) {
//   //     setState(() {
//   //       _isLoading = false;
//   //       _errorMessage = 'Error uploading file: $e';
//   //     });
//   //   }
//   // }
//   //
//   // Future<void> _openFile(String url, String fileName, BuildContext context) async {
//   //   showDialog(
//   //     context: context,
//   //     builder: (context) => AlertDialog(
//   //       title: Text('File: $fileName'),
//   //       content: const Text('Would you like to view or download the file?'),
//   //       actions: [
//   //         TextButton(
//   //           onPressed: () async {
//   //             Navigator.pop(context);
//   //             final uri = Uri.parse(url);
//   //             if (await canLaunchUrl(uri)) {
//   //               await launchUrl(uri, mode: LaunchMode.externalApplication);
//   //             } else {
//   //               ScaffoldMessenger.of(context).showSnackBar(
//   //                 const SnackBar(content: Text('Could not open file')),
//   //               );
//   //             }
//   //           },
//   //           child: const Text('View'),
//   //         ),
//   //         TextButton(
//   //           onPressed: () async {
//   //
//   //           },
//   //           child: const Text('Download'),
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//
//
//   Widget _buildMessage(Map<String, dynamic> message, bool isMe) {
//     final timestamp = (message['timestamp'] as Timestamp?)?.toDate();
//     final formattedTime = timestamp != null ? DateFormat('HH:mm').format(timestamp) : '';
//     final isFile = message['type'] == 'file';
//
//     return Column(
//       crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//           padding: EdgeInsets.all(12.0),
//           decoration: BoxDecoration(
//             color: isMe ? Color(0xFF62CD9C) : Colors.grey[200],
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: isFile
//               ? GestureDetector(
//             onTap: () async {
//               String url = message['fileUrl'] ;
//               final cleanUrl = url.trim();
//               final uri = Uri.parse(cleanUrl);
//               if (await canLaunchUrl(uri)) {
//               await launchUrl(uri, mode: LaunchMode.externalApplication);
//               }
//               else {
//               ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Could not open file')),
//               );
//               }
//             } ,
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _getFileIcon(message['fileName'] ?? 'file'),
//                 const SizedBox(width: 8),
//                 Flexible(
//                   child: Text(
//                     message['fileName'] ?? 'File',
//                     style: TextStyle(
//                       color: isMe ? Colors.white : Colors.blue,
//                       decoration: TextDecoration.underline,
//                       fontSize: 16.0,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : Text(
//             message['message'] ?? '',
//             style: TextStyle(
//               fontSize: 16.0,
//               color: isMe ? Colors.white : Colors.black,
//             ),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 8.0),
//           child: Text(
//             formattedTime,
//             style: TextStyle(
//               fontSize: 10.0,
//               color: Colors.grey[600],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _getFileIcon(String fileName) {
//     String extension = fileName.split('.').last.toLowerCase();
//     if (['jpg', 'jpeg', 'png'].contains(extension)) {
//       return Image.network(
//         _uploadedFileUrl ?? '',
//         width: 50,
//         height: 50,
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) => Icon(
//           Icons.image,
//           color: Colors.white,
//           size: 30,
//         ),
//       );
//     }
//     IconData icon;
//     switch (extension) {
//       case 'pdf':
//         icon = Icons.picture_as_pdf;
//         break;
//       default:
//         icon = Icons.insert_drive_file;
//     }
//     return Icon(icon, color: Colors.white, size: 30);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             otherUserName,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//         backgroundColor: Color(0xFF62CD9C),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('chat_rooms')
//                   .doc(chatRoomId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 final messages = snapshot.data?.docs ?? [];
//
//                 if (messages.isEmpty) {
//                   return Center(child: Text('No messages yet.'));
//                 }
//
//                 return ListView.builder(
//                   reverse: true,
//                   padding: EdgeInsets.all(8.0),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index].data() as Map<String, dynamic>?;
//                     if (message == null) {
//                       return SizedBox.shrink();
//                     }
//                     final isMe = message['senderId'] == currentUserId;
//                     return _buildMessage(message, isMe);
//                   },
//                   //physics: NeverScrollableScrollPhysics(),
//                 );
//               },
//             ),
//           ),
//           if (_isLoading) LinearProgressIndicator(),
//           if (_errorMessage != null)
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 _errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide(color: Color(0xFF62CD9C)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                         borderSide: BorderSide(color: Color(0xFF62CD9C), width: 2.0),
//                       ),
//                       hintText: 'Type a message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 16.0,
//                         vertical: 10.0,
//                       ),
//                     ),
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFF62CD9C),
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.attach_file, color: Colors.white),
//                     onPressed: () async {
//                       await _pickFile();
//                       if (_fileBase64 != null) {
//                         await _uploadFile();
//                       }
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 8.0),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFF62CD9C),
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: _sendMessage,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
// }




