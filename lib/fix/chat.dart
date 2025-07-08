import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:sos_bebe_profil_bebe_doctor/fix/servises%20/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chestionar_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../intro/intro_screen.dart';
import 'dart:async'; // Added for Timer

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
  Timer? _autoCloseTimer; // Timer for auto-closing chat
  bool _hasSentMessage = false; // Track if doctor has sent at least one message
  bool _showExitButton = false; // Track if patient has left to show Exit button

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

  DateTime? _sessionCompletionTime; // Cache completion time
  final ValueNotifier<String> _timerText = ValueNotifier<String>(''); // Manage timer display

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
    _checkForPatientExit();
    //_listenForPayment();
    _listenForConversationCompletion(); // New method to listen to conversationCompleted
  }

  void _listenForConversationCompletion() {
    _firestore
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && mounted) {
        final isCompleted = snapshot.data()?['conversationCompleted'] ?? false;
        setState(() {
          _showExitButton = isCompleted && widget.isDoctor; // Update _showExitButton for doctor
        });
      }
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.isDoctor) {
  //     currentUserId = widget.doctorId;
  //     currentUserName = widget.doctorName;
  //     otherUserId = widget.patientId;
  //     otherUserName = widget.patientName;
  //   } else {
  //     currentUserId = widget.patientId;
  //     currentUserName = widget.patientName;
  //     otherUserId = widget.doctorId;
  //     otherUserName = widget.doctorName;
  //   }
  //
  //   _initializeChatRoom();
  //   _checkForPatientExit();
  //   _listenForPayment();
  // }

  Future<void> _initializeChatRoom() async {
    try {
      final chatRoomRef = _firestore.collection('chat_rooms').doc(widget.chatRoomId);
      final chatRoomSnapshot = await chatRoomRef.get();
      if (!chatRoomSnapshot.exists) {
        await chatRoomRef.set({
          'createdAt': FieldValue.serverTimestamp(),
          'participants': [widget.doctorId, widget.patientId],
          'conversationCompleted': false, // Ensure this is set
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Update existing document to ensure conversationCompleted exists
        await chatRoomRef.set({
          'conversationCompleted': false, // Default value if not present
        }, SetOptions(merge: true));
      }
      final messagesSnapshot = await _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .where('senderId', isEqualTo: widget.doctorId)
          .get();
      if (messagesSnapshot.docs.isNotEmpty) {
        setState(() {
          _hasSentMessage = true;
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
  void _checkForPatientExit() {
    _firestore
        .collection('chat_rooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .where('message', isEqualTo: 'The patient has left the chat.')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty && mounted) {
        setState(() {
          _showExitButton = true;
        });
      }
    });
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
      'messageStatus': 'sent',
      'completionTimestamp': 0,
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
        if (widget.isDoctor) {
          _hasSentMessage = true;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    }
  }

  Future<void> _markSessionCompleted() async {
    if (!_hasSentMessage) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trebuie să trimiți cel puțin un mesaj înainte de a încheia sesiunea')),
        );
      }
      return;
    }
    try {
      // Add the completion message without serverTimestamp initially
      final messageRef = await _firestore
          .collection('chat_rooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'senderName': currentUserName,
        'type': 'text',
        'message': 'Medicul a încheiat sesiunea 🩺. Poți ieși din chat 🚪 sau face o plată 💳 dacă vrei să pui o altă întrebare',
        'messageStatus': 'completed',
        'completionTimestamp': 0,
      });

      // Update the document with serverTimestamp
      final completionTimestamp = FieldValue.serverTimestamp();
      await messageRef.update({
        'timestamp': completionTimestamp,
        'completionTimestamp': completionTimestamp,
      });

      // Update chat room status with single timestamp
      await _firestore.collection('chat_rooms').doc(widget.chatRoomId).update({
        'conversationCompleted': true,
        'timestamp': completionTimestamp,
      });

      // Update consultation status
 //     await _consultationService.updateConsultationStatus(widget.sessionID, 'callEnded');

      // Fetch the actual timestamp after update
      final snap = await messageRef.get();
      final actualCompletionTime = (snap.data()!['completionTimestamp'] as Timestamp).toDate();
      _startVisibleTimer(actualCompletionTime);




      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session marked as completed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing session: $e')),
        );
      }
    }
  }

  void _startVisibleTimer(DateTime completionTime) {
    _autoCloseTimer?.cancel();
    _sessionCompletionTime = completionTime; // Cache the completion time
    _timerText.value = '01:00'; // Initial timer value
    _autoCloseTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final now = DateTime.now().toUtc();
      final endTime = _sessionCompletionTime!.add(const Duration(minutes: 1));
      final timeDifference = endTime.difference(now);
      final remainingSeconds = timeDifference.inSeconds.clamp(0, 60);

      if (timeDifference.isNegative) {
        bool isCompleted = (await _firestore.collection('chat_rooms').doc(widget.chatRoomId).get()).data()?['conversationCompleted'] ?? false;
        if(isCompleted == false )
          return;

        timer.cancel();
        _timerText.value = '00:00';
        if (mounted) {
          await _consultationService.updateConsultationStatus(widget.sessionID, 'callEnded');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
                (Route<dynamic> route) => false,
          );
        }
      } else {
        final minutes = remainingSeconds ~/ 60;
        final seconds = remainingSeconds % 60;
        _timerText.value = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      }
    });
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
      String user = "dr@d.com";
      String userPassMD5 = "e10adc3949ba59abbe56e057f20f883e";
      String idClient = "9";

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

      setState(() {
        _isLoading = false;
        if (fileUrl != null) {
          fileUrl = fileUrl!.trim();
          fileUrl = Uri.encodeFull(fileUrl!);
          _uploadedFileUrl = fileUrl;
          _errorMessage = null;
          _sendMessage(fileUrl: fileUrl, fileName: '$_fileName$_fileExtension');
        } else {
          _errorMessage = 'Upload failed - no URL returned';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error uploading file: $e';
      });
    }
  }

  Future<void> _openFile(String? url, String fileName, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('File: $fileName'),
        content: const Text('Would you like to view or download the file?'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final cleanUrl = url?.trim() ?? url ?? '';
              final uri = Uri.parse(cleanUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open file')),
                  );
                }
              }
            },
            child: const Text('View'),
          ),
          TextButton(
            onPressed: () async {
              // Implement download logic if needed
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
    final fileUrl = message['fileUrl'] as String?;

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
              if (fileUrl != null) {
                final cleanUrl = fileUrl.trim();
                final uri = Uri.parse(cleanUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open file')),
                    );
                  }
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Image.asset('assets/img.png', height: 150),
                const SizedBox(width: 8),
                Icon(
                  Icons.download,
                  color: isMe ? Colors.white : Colors.blue,
                  size: 24.0,
                ),
                const SizedBox(width: 8),
              ],
            ),
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF62CD9C),
        title: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            
            children: [
              Text(
                widget.isDoctor ? widget.patientName : widget.doctorName,
                style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              
               SizedBox(width: 16),
              if (widget.isDoctor) ...[
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('chat_rooms')
                      .doc(widget.chatRoomId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return SizedBox.shrink(); // Hide until data is available
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                    final isCompleted = data['conversationCompleted'] as bool? ?? false;
                    // if (isCompleted) {
                    //   return _showExitButton
                    //       ? SizedBox(
                    //     width: 100,
                    //     child: ElevatedButton(
                    //       onPressed: () async {
                    //         try {
                    //           _messageController.text =
                    //           'Doctorul a părăsit chat-ul. Vă rugăm să salvați orice document înainte de a părăsi.';
                    //           // await _sendMessage();
                    //           await _consultationService
                    //               .updateConsultationStatus(widget.sessionID, 'callEnded');
                    //           if (mounted) {
                    //             Navigator.pushAndRemoveUntil(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => const IntroScreen()),
                    //                   (Route<dynamic> route) => false,
                    //             );
                    //           }
                    //         } catch (e) {
                    //           if (mounted) {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                   content: Text(
                    //                       'Eroare la încheierea chat-ului: $e')),
                    //             );
                    //           }
                    //         }
                    //       },
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.redAccent,
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 4, vertical: 4),
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         elevation: 2,
                    //       ),
                    //       child: Text(
                    //         'Ieși din chat',
                    //         style: GoogleFonts.rubik(
                    //           fontSize: 12,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //         overflow: TextOverflow.ellipsis,
                    //       ),
                    //     ),
                    //   )
                    //       : SizedBox.shrink();
                    // }
                    if(isCompleted)
                      return SizedBox() ;
                     return  TextButton.icon(
                       onPressed: _markSessionCompleted,
                       icon: const Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF62CD9C)),
                       label: Text(
                         'Finalizează sesiunea',
                         style: GoogleFonts.rubik(
                           fontSize: 13,
                           fontWeight: FontWeight.w500,
                           color: Color(0xFF62CD9C),
                         ),
                         overflow: TextOverflow.ellipsis,
                       ),
                       style: TextButton.styleFrom(
                         foregroundColor: Colors.white,
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                         backgroundColor: Colors.white,
                       ),
                     );
                    //    SizedBox(
                    //   width: 150,
                    //   child: ElevatedButton(
                    //     onPressed: _markSessionCompleted,
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.blueAccent,
                    //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       elevation: 2,
                    //     ),
                    //     child: Text(
                    //       'Complete Session',
                    //       style: GoogleFonts.rubik(
                    //         fontSize: 12,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ],
          ),
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
          // Always show the timer once session is completed

          /// HERE ......
          ///

          StreamBuilder<DocumentSnapshot>(
            stream: _firestore.collection('chat_rooms').doc(widget.chatRoomId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData || !snapshot.data!.exists) {
                return const SizedBox.shrink(); // Show nothing while loading or if no data
              }
              final isCompleted = snapshot.data?.data() != null
                  ? (snapshot.data!.data() as Map<String, dynamic>)['conversationCompleted'] as bool? ?? false
                  : false;
              if (!isCompleted) {
                return const SizedBox.shrink(); // Show nothing if conversationCompleted is false
              }
              return ValueListenableBuilder<String>(
                valueListenable: _timerText,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Visibility(
                      visible: _sessionCompletionTime != null && value.isNotEmpty,
                      child: Text(
                        value.isEmpty ? 'Calculating...' : 'Time remaining: $value',
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // ValueListenableBuilder<String>(
          //   valueListenable: _timerText,
          //   builder: (context, value, child) {
          //     return Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Visibility(
          //         visible: _sessionCompletionTime != null && value.isNotEmpty,
          //         child: Text(
          //           value.isEmpty ? 'Calculating...' : 'Time remaining: $value',
          //           style: TextStyle(fontSize: 16, color: Colors.red),
          //         ),
          //       ),
          //     );
          //   },
          // ),
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
                    minLines: 1, // Minimum lines to start with
                    maxLines: null, // Allows it to grow vertically
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
    _autoCloseTimer?.cancel();
    _timerText.dispose(); // Dispose of ValueNotifier
    super.dispose();
  }
}