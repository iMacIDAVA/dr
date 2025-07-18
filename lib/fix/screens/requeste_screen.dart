import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/CountdownWrapper.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/screens/form_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/screens/videoCallScreen.dart';
import 'package:sos_bebe_profil_bebe_doctor/intro/intro_screen.dart';
import '../chat.dart';
import '../servises /services.dart'; // Added for Rubik font
import 'package:http/http.dart' as http;


class ConsultationScreen extends StatefulWidget {
  final int doctorId;
  const ConsultationScreen({Key? key, required this.doctorId}) : super(key: key);

  @override
  _ConsultationScreenState createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  static const int _initialTime = 180; // Constant for timer durationfaile
  final ConsultationService _consultationService = ConsultationService();
  Map<String, dynamic>? _currentConsultation;
  bool _isLoading = true;
  String? _error;
  Timer? _pollingTimer;
  Timer? _countdownTimer;
  final ValueNotifier<int> _remainingTimeNotifier = ValueNotifier(_initialTime);


  @override
  void initState() {
    super.initState();
    _loadCurrentConsultation();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    _remainingTimeNotifier.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      print('_startPolling ... IS CALLED ') ;
      _loadCurrentConsultation();

      if (_currentConsultation != null ) {

        // if(_currentConsultation!['status'] ==  'FormSubmitted')
        //   return ;
    //    _loadCurrentConsultation();

      }
    });
  }


  void _startTimer() {
    _countdownTimer?.cancel(); // Cancel any existing timer
    _remainingTimeNotifier.value = _initialTime;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeNotifier.value > 0) {
        _remainingTimeNotifier.value--;
      } else {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  Future<void> _handleTimeout() async {
    if (_currentConsultation == null) return;
    try {
      await _consultationService.updateConsultationStatus(
        _currentConsultation!['id'],
        'reject',
      );
      setState(() {
        _currentConsultation = null; // Clear consultation after timeout
      });
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const IntroScreen()),
              (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }
  Future<void> _loadCurrentConsultation() async {
    try {
      print("_loadCurrentConsultation ... is called ");
      final response = await _consultationService.getCurrentConsultation(widget.doctorId);
      print("response090");
      print(response);

      if (response['has_active_session']) {
        final newStatus = response['data']['status'];
        final oldStatus = _currentConsultation?['status'];

        setState(() {
          _currentConsultation = response['data'];
          _isLoading = false;
        });

        // Only start timer if we just received a new 'Requested' status
        if (newStatus == 'Requested' && oldStatus != 'Requested') {
          _startTimer();
        }
      } else {
        setState(() {
          _currentConsultation = null;
          _isLoading = false;
        });
        _countdownTimer?.cancel(); // Stop timer if no active consultation
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(String action) async {

    if (_currentConsultation == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await _consultationService.updateConsultationStatus(
        _currentConsultation!['id'],
        action,
      );
      if (mounted) {
        setState(() {
          _currentConsultation = response['data'];
          _isLoading = false;
        });
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
                (route) => false,
          );
        }
      }
      if (action == 'reject') {
        _countdownTimer?.cancel();
        setState(() {
          _currentConsultation = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }

    }
  }

  Widget _getRequestIcon(String sessionType) {
    IconData icon;
    switch (sessionType.toLowerCase()) {
      case 'întrebare':
        icon = Icons.chat_rounded;
        break;
      case 'recomandare':
        icon = Icons.analytics;
        break;
      case 'apel':
        icon = Icons.phone;
        break;
      default:
        icon = Icons.add_alert;
    }
    return Icon(
      icon,
      size: 80,
      color: Colors.white,
    );
  }

  Widget _buildRequestedScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(30, 214, 158, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 150),
                _getRequestIcon(_currentConsultation!['session_type']),
                const SizedBox(height: 20),
                Text(
                  'Ai o nouă cerere de ${_currentConsultation!['session_type']} ',
                  style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 130),
                GestureDetector(
                  onTap: () => _updateStatus('accept'),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "ACCEPTĂ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(30, 214, 158, 1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 27),
                GestureDetector(
                  onTap: () => _updateStatus('reject'),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "REFUZĂ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 98.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ValueListenableBuilder<int>(
                          valueListenable: _remainingTimeNotifier,
                          builder: (context, remainingTime, _) {
                            return Text(
                              "${remainingTime ~/ 60}:${(remainingTime % 60).toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.timer,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentPendingScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Plată în așteptare',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0EBE7F),
                letterSpacing: 0.5,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EBE7F)),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Se așteaptă finalizarea plății de către pacient',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0EBE7F),
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPaymentPendingScreen() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           'Payment Pending',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 20),
  //         const CircularProgressIndicator(),
  //         const SizedBox(height: 20),
  //         const Text(
  //           'Waiting for patient to complete payment',
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPaymentAcceptedScreen() {
    return Center(
      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,

        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Plată acceptată',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0EBE7F),
                  letterSpacing: 0.5,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EBE7F)),
                strokeWidth: 3,
              ),
              const SizedBox(height: 20),
              Text(
                'Se așteaptă trimiterea formularului de către pacient',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF0EBE7F),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget _buildPaymentAcceptedScreen() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           'Payment Accepted',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 20),
  //         const Text(
  //           'Waiting for patient to submit form',
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFormPendingScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Formular în așteptare',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0EBE7F),
                letterSpacing: 0.5,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EBE7F)),
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              'Se așteaptă completarea și trimiterea formularului de către pacient',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0EBE7F),
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFormPendingScreen() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Text(
  //           'Form Pendingxx',
  //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //         ),
  //         const SizedBox(height: 20),
  //         const CircularProgressIndicator(),
  //         const SizedBox(height: 20),
  //         const Text(
  //           'Waiting for patient to complete and submit the form',
  //           textAlign: TextAlign.center,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFormSubmittedScreen() {
    return Form_Screen(sessionId: _currentConsultation!['id'] ) ;

  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'A apărut o eroare:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadCurrentConsultation();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Reîncearcă"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    //
    // if (_error != null) {
    //   return Center(
    //     child: Text(
    //       'Errorxxx: $_error',
    //       style: const TextStyle(color: Colors.red),
    //     ),
    //   );
    // }

    if (_currentConsultation == null) {

      return Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const IntroScreen()),
                  (route) => false,
            );
          },
          child: const Text("Go Back" , style: TextStyle(color: Color.fromRGBO(30, 214, 158, 1,),
        ),
      )));


    }
    print('Unknown status: ${_currentConsultation!['status']}');

    switch (_currentConsultation!['status']) {
      case 'Requested':
        return _buildRequestedScreen();
      case 'PaymentPending':
        return _buildPaymentPendingScreen();
      case 'PaymentCompleted':
        return _buildPaymentAcceptedScreen();
      case 'FormPending':
        return _buildFormPendingScreen();
      case 'FormSubmitted':
        return _buildFormSubmittedScreen();

      case 'CallReady':
        return  _buildSessionScreen() ;

        case 'Accepted':
        return   acceptedScreen() ;


      default:
        return Center(
          child: Text('Unknown status: ${_currentConsultation!['status']}'),
        );
    }
  }

  /// Swich screen
  Widget _buildSessionScreen() {
    switch (_currentConsultation!['session_type']) {
      case 'Call':
        return _buildCallReadyScreen();
      case 'Chat' || 'Recommendation' :
        return _buildChatScreen();

      default:
        return const Center(child: Text('Unknown Status'));
    }
  }



  /// Navigate to Chat screen
  Widget _buildChatScreen() {
    return Scaffold(
      backgroundColor: Color(0xFF0EBE7F), // Matches the dark background of _buildCallReadyScreen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),

            const Icon(
              Icons.chat_bubble,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Gata să începi chat-ul',
              style: GoogleFonts.rubik(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pacientul te așteaptă acum în chat',
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) =>  ChatScreen(
                    isDoctor: true,
                        doctorId: _currentConsultation!['doctor_id'].toString(),
                        patientId: _currentConsultation!['patient_id'].toString(),
                        doctorName: _currentConsultation!['doctor_name'],
                        patientName: _currentConsultation!['patient_name'],
                        chatRoomId: _currentConsultation!['channel_name'],
                        sessionID: _currentConsultation!['id']

                )), (Route<dynamic> route) => false,  );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ChatScreen(
                //       isDoctor: true,
                //       doctorId: _currentConsultation!['doctor_id'].toString(),
                //       patientId: _currentConsultation!['patient_id'].toString(),
                //       doctorName: _currentConsultation!['doctor_name'],
                //       patientName: _currentConsultation!['patient_name'],
                //       chatRoomId: _currentConsultation!['channel_name'],
                //       sessionID: _currentConsultation!['id']
                //     ),
                //   ),
                // );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Intră în chat',
                style: GoogleFonts.rubik(
                  fontSize: 16,
                  color: const Color(0xFF0EBE7F),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Atenție, doctorule:\nNu apăsa „Am răspuns” până nu ai terminat complet de scris. '
                              'Poți trimite mai multe mesaje și fișiere înainte de a marca conversația ca finalizată. '
                              'După ce apeși, începe un cronometru de 1 minut. În acest timp, pacientul poate fie să plătească pentru o nouă întrebare, fie să închidă chatul. '
                              'Vei fi notificat în ambele cazuri – așa că relaxează-te și lasă procesul să-și urmeze cursul.',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'AM RĂSPUNS',
                          style: GoogleFonts.rubik(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }


  Widget _buildCallReadyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            size: 80,
            color: Color(0xFF0EBE7F),
          ),
          const SizedBox(height: 24),
          Text(
            'Gata să te alături',
            style: GoogleFonts.rubik(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0EBE7F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Pacientul este gata să înceapă consultația',
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // print('_currentConsultation!');
              // print(_currentConsultation);
              // // Navigate to call screen
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => TestVideoCallScreen(isDoctor: true  , channelName: _currentConsultation!['channel_name']  ,)),
              // ).then((value) async {
              //   try {
              //     // This is the specific line that ends the call
              //     await _consultationService.updateConsultationStatus(_currentConsultation!['id'], 'callEnded');
              //
              //     if (mounted) {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(content: Text('Call ended successfully')),
              //       );
              //
              //     }
              //   } catch (e) {
              //     if (mounted) {
              //       print('Error ending call: ${e.toString()}');
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         SnackBar(content: Text('Error ending call: ${e.toString()}')),
              //       );
              //     }
              //   }
              // });

              // Navigate to call screen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TestVideoCallScreen(
                    isDoctor: true,
                    channelName: _currentConsultation!['channel_name'],
                    sessionId: _currentConsultation!['id'],
                  ),
                ),
                    (route) => false, // Remove all routes
              ).then((value) async {
                try {
                  // This is the specific line that ends the call
                  await _consultationService.updateConsultationStatus(_currentConsultation!['id'], 'callEnded');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Call ended successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    print('Error ending call: ${e.toString()}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error ending call: ${e.toString()}')),
                    );
                  }
                }
              });

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0EBE7F),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Intră în sesiune',
              style: GoogleFonts.rubik(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white, // Green background
          body: WillPopScope(
            onWillPop: () async => false, // Prevent back navigation
            child: _buildContent(),
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

}

class acceptedScreen extends StatelessWidget {
  //final ConsultationService _consultationService = ConsultationService();

  const acceptedScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CountdownWrapper(
      onTimeout: (){

        // await _consultationService.updateConsultationStatus(
        //   _currentConsultation!['id'],
        //   'callEnded',
        // );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Cererea a fost acceptată și așteptăm finalizarea plății.",
                style: TextStyle(
                  color: Color(0xFF0EBE7F),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0EBE7F)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

