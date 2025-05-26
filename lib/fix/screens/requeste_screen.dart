import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../servises /services.dart'; // Added for Rubik font



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
      if (_currentConsultation != null) {
        _loadCurrentConsultation();
      }
    });
  }
  // void _startPolling() {
  //   _pollingTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
  //     if (_currentConsultation != null) {
  //       _loadCurrentConsultation();
  //     }
  //   });
  // }

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
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }
  Future<void> _loadCurrentConsultation() async {
    try {
      final response = await _consultationService.getCurrentConsultation(widget.doctorId);

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

  // Future<void> _loadCurrentConsultation() async {
  //   try {
  //     final response = await _consultationService.getCurrentConsultation(widget.doctorId);
  //
  //     if (response['has_active_session']) {
  //       setState(() {
  //         _currentConsultation = response['data'];
  //         _isLoading = false;
  //       });
  //       if (_currentConsultation!['status'] == 'Requested') {
  //         _startTimer(); // Start timer for new requests
  //       }
  //     } else {
  //       setState(() {
  //         _currentConsultation = null;
  //         _isLoading = false;
  //       });
  //       _countdownTimer?.cancel(); // Stop timer if no active consultation
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _error = e.toString();
  //       _isLoading = false;
  //     });
  //   }
  // }

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
        icon = Icons.help;
    }
    return Icon(
      icon,
      size: 80,
      color: Colors.white,
    );
  }

  Widget _buildRequestedScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 88.0),
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
                const SizedBox(height: 50),
                _getRequestIcon(_currentConsultation!['session_type']),
                const SizedBox(height: 20),
                Text(
                  'New ${_currentConsultation!['session_type']} request',
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Payment Pending',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text(
            'Waiting for patient to complete payment',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentAcceptedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Payment Accepted',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Waiting for patient to submit form',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormPendingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Form Pending',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          const Text(
            'Waiting for patient to complete and submit the form',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormSubmittedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Form Submitted',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _updateStatus('callReady'),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Text(
          'Errorxxx: $_error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (_currentConsultation == null) {
      return const Center(
        child: Text('No active consultations'),
      );
    }

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
      default:
        return Center(
          child: Text('Unknown status: ${_currentConsultation!['status']}'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1), // Green background
          appBar: AppBar(
            title: Text(
              'Confirmare',
              style: GoogleFonts.rubik(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
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

