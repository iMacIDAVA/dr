import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/servises%20/services.dart';
import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;


import '../fix/screens/requeste_screen.dart';
import '../notification_confirm_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with WidgetsBindingObserver {
  ApiCallFunctions apiCallFunctions = ApiCallFunctions();
  ConsultationService consultationService = ConsultationService();
  String oneSignalId = '';
  TotaluriMedic? totaluriMedic;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initOneSignal();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkActiveSession();
    }
  }

  Future<void> initOneSignal() async {
    await getUserData();
  }

  Future<bool> _checkActiveSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    if (user.isEmpty || userPassMD5.isEmpty) return false;

    try {
      ContMedicMobile? contMedic = await apiCallFunctions.getContMedic(
        pUser: user,
        pParola: userPassMD5,
        pDeviceToken: prefs.getString('deviceToken') ?? '',
        pTipDispozitiv: Platform.isAndroid ? '1' : '2',
        pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
        pTokenVoip: '',
      );

      if (contMedic == null) return false;

      int doctorId = contMedic.id;
      final response = await consultationService.getCurrentConsultation(doctorId);

      print("debug fro DR $doctorId ${response}  >> ${response['has_active_session']}");

      if (response['has_active_session'] == true) {
        _pollingTimer?.cancel();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ConsultationScreen(doctorId: doctorId),
            ),
                (route) => false,
          );
          print("Navigated to ConsultationScreen");
        }
        return true;
      }
    } catch (e) {
      print('Error checking active session: $e');
    }
    return false;
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (await _checkActiveSession()) {
        timer.cancel(); // Stop polling after navigation
      }
    });
  }

  Future<void> saveNotificationData(OSNotification notification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(pref_keys.notificationTitle, notification.title ?? 'Fără Titlu');
    await prefs.setString(pref_keys.notificationBody, notification.body ?? 'Fără corp');
    await prefs.setString(pref_keys.notificationData, notification.additionalData?.toString() ?? 'Fără date');

    String? alertMessage = notification.body;
    if (alertMessage != null &&
        (alertMessage.toLowerCase().contains('apel') ||
            alertMessage.toLowerCase().contains('recomandare') ||
            alertMessage.toLowerCase().contains('întrebare'))) {
      await _checkActiveSession();
    }
  }

  Future<void> navigateToNotificationScreen(BuildContext context, String page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceToken = prefs.getString('deviceToken') ?? '';

    TotaluriMedic? resGetTotaluriDashboardMedic = await apiCallFunctions.getTotaluriDashboardMedic(
      pUser: user,
      pParola: userPassMD5,
    );

    ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
      pUser: user,
      pParola: userPassMD5,
      pDeviceToken: deviceToken,
      pTipDispozitiv: Platform.isAndroid ? '1' : '2',
      pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
      pTokenVoip: '',
    );

    if (resGetCont != null && resGetTotaluriDashboardMedic != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailsScreen(
            totaluriMedic: resGetTotaluriDashboardMedic,
            contMedicMobile: resGetCont,
            page: page,
          ),
        ),
            (route) => false,
      );
    }
  }

  Future<TotaluriMedic?> getTotaluriDashboardMedic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';

    return await apiCallFunctions.getTotaluriDashboardMedic(
      pUser: user,
      pParola: userPassMD5,
    );
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user') ?? '';
    String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
    String deviceToken = prefs.getString('deviceToken') ?? '';

    try {
      if (user.isNotEmpty) {
        TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();
        ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
          pUser: user,
          pParola: userPassMD5,
          pDeviceToken: deviceToken,
          pTipDispozitiv: Platform.isAndroid ? '1' : '2',
          pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
          pTokenVoip: '',
        );

        if (resGetCont == null) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginMedicScreen(),
              ),
            );
          }
          return;
        }

        // Check for active session before starting polling or navigating to Dashboard
        bool hasActiveSession = await _checkActiveSession();
        if (hasActiveSession) return; // Skip further navigation if session found

        _startPolling(); // Start polling only if no session is found

        if (resGetTotaluriDashboardMedic != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                contMedicMobile: resGetCont,
                totaluriMedic: resGetTotaluriDashboardMedic,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginMedicScreen(),
            ),
          );
        }
      }
    } catch (e) {
      print('Error in getUserData: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('./assets/images/Sos_Bebe_logo.png', height: 198, width: 158)),
    );
  }
}

/// FIRST FIX

// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
// import 'package:sos_bebe_profil_bebe_doctor/fix/servises%20/services.dart';
// import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/agora_call_service.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;
//
//
// import '../fix/screens/requeste_screen.dart';
// import '../notification_confirm_screen.dart';
//
// class IntroScreen extends StatefulWidget {
//   const IntroScreen({super.key});
//
//   @override
//   State<IntroScreen> createState() => _IntroScreenState();
// }
//
// class _IntroScreenState extends State<IntroScreen> with WidgetsBindingObserver {
//   ApiCallFunctions apiCallFunctions = ApiCallFunctions();
//   ConsultationService consultationService = ConsultationService(); // Added for session checks
//   String oneSignalId = '';
//   TotaluriMedic? totaluriMedic;
//   Timer? _pollingTimer; // Added for polling
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
//     initOneSignal();
//   }
//
//   @override
//   void dispose() {
//     _pollingTimer?.cancel(); // Cancel polling timer
//     WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _checkActiveSession(); // Recheck session when app resumes
//     }
//   }
//
//   Future<void> initOneSignal() async {
//     await getUserData();
//   }
//
//   Future<void> _checkActiveSession() async {
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//
//
//     if (user.isEmpty || userPassMD5.isEmpty) return; // Skip if no user
//
//     try {
//       ContMedicMobile? contMedic = await apiCallFunctions.getContMedic(
//         pUser: user,
//         pParola: userPassMD5,
//         pDeviceToken: prefs.getString('deviceToken') ?? '',
//         pTipDispozitiv: Platform.isAndroid ? '1' : '2',
//         pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
//         pTokenVoip: '',
//       );
//
//       if (contMedic == null) return; // Skip if no doctor data
//
//       int doctorId = contMedic.id; // Assuming ContMedicMobile has id field
//       final response = await consultationService.getCurrentConsultation(doctorId);
//
//       print("debug fro DR $doctorId ${response}  >> ${response['has_active_session']} ");
//       if (response['has_active_session']) {
//
//         _pollingTimer?.cancel(); // Stop polling if session found
//
//
//
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ConsultationScreen(doctorId: doctorId),
//           ),
//               (route) => false,
//         );
//         print("DEBUS !)!") ;
//       }
//     } catch (e) {
//       print('Error checking active session: $e'); // Log error, continue default flow
//     }
//   }
//
//   void _startPolling() {
//     _pollingTimer?.cancel(); // Cancel any existing timer
//     _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
//       await _checkActiveSession();
//     });
//   }
//
//   Future<void> navigateToNotificationScreen(BuildContext context, String page) async {
//     ApiCallFunctions apiCallFunctions = ApiCallFunctions();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//     String deviceToken = prefs.getString('deviceToken') ?? '';
//
//     TotaluriMedic? resGetTotaluriDashboardMedic = await apiCallFunctions.getTotaluriDashboardMedic(
//       pUser: user,
//       pParola: userPassMD5,
//     );
//
//     ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
//       pUser: user,
//       pParola: userPassMD5,
//       pDeviceToken: deviceToken,
//       pTipDispozitiv: Platform.isAndroid ? '1' : '2',
//       pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
//       pTokenVoip: '',
//     );
//
//     if (resGetCont != null && resGetTotaluriDashboardMedic != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => NotificationDetailsScreen(
//             totaluriMedic: resGetTotaluriDashboardMedic,
//             contMedicMobile: resGetCont,
//             page: page,
//           ),
//         ),
//             (route) => false,
//       );
//     }
//   }
//
//   Future<void> saveNotificationData(OSNotification notification) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString(pref_keys.notificationTitle, notification.title ?? 'Fără Titlu');
//     await prefs.setString(pref_keys.notificationBody, notification.body ?? 'Fără corp');
//     await prefs.setString(pref_keys.notificationData, notification.additionalData?.toString() ?? 'Fără date');
//
//     String? alertMessage = notification.body;
//     if (alertMessage != null) {
//       if (alertMessage.toLowerCase().contains('apel') ||
//           alertMessage.toLowerCase().contains('recomandare') ||
//           alertMessage.toLowerCase().contains('întrebare')) {
//         await _checkActiveSession(); // Check session on relevant notifications
//       }
//     }
//   }
//
//   Future<TotaluriMedic?> getTotaluriDashboardMedic() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//
//     totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedic(
//       pUser: user,
//       pParola: userPassMD5,
//     );
//
//     return totaluriMedic;
//   }
//
//   Future<void> getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//     String deviceToken = prefs.getString('deviceToken') ?? '';
//
//     try {
//       if (user.isNotEmpty) {
//         TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();
//
//         ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
//           pUser: user,
//           pParola: userPassMD5,
//           pDeviceToken: deviceToken,
//           pTipDispozitiv: Platform.isAndroid ? '1' : '2',
//           pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
//           pTokenVoip: '',
//         );
//
//         if (resGetCont == null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const LoginMedicScreen(),
//             ),
//           );
//           return;
//         }
//
//         _startPolling(); // Start polling after user data is confirmed
//         await _checkActiveSession(); // Initial session check
//
//         if (resGetTotaluriDashboardMedic != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DashboardScreen(
//                 contMedicMobile: resGetCont,
//                 totaluriMedic: resGetTotaluriDashboardMedic,
//               ),
//             ),
//           );
//         }
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const LoginMedicScreen(),
//           ),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(child: Image.asset('./assets/images/Sos_Bebe_logo.png', height: 198, width: 158)),
//     );
//   }
// }

/// ORIGINAL SHIT CODE ////////////////////////////
// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sos_bebe_profil_bebe_doctor/dashboard_screen.dart';
// import 'package:sos_bebe_profil_bebe_doctor/login_screen.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/agora_call_service.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/classes.dart';
// import 'package:sos_bebe_profil_bebe_doctor/utils_api/shared_pref_keys.dart' as pref_keys;
//
// import '../notification_confirm_screen.dart';
//
// class IntroScreen extends StatefulWidget {
//   const
//   IntroScreen({super.key});
//
//   @override
//   State<IntroScreen> createState() => _IntroScreenState();
// }
//
// class _IntroScreenState extends State<IntroScreen> {
//   ApiCallFunctions apiCallFunctions = ApiCallFunctions();
//   String oneSignalId = '';
//   TotaluriMedic? totaluriMedic;
//   // CallService callService = CallService();
//
//   Future<void> initOneSignal() async {
//     // await ensureDeviceToken();
//     await getUserData();
//
//     // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
//     //   saveNotificationData(event.notification);
//     // });
//     // OneSignal.Notifications.addClickListener((event) {
//     //   saveNotificationData(event.notification);
//     // });
//   }
//
//   Future<void> navigateToNotificationScreen(BuildContext context, String page) async {
//     ApiCallFunctions apiCallFunctions = ApiCallFunctions();
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//     String deviceToken = prefs.getString('deviceToken') ?? '';
//
//     TotaluriMedic? resGetTotaluriDashboardMedic = await apiCallFunctions.getTotaluriDashboardMedic(
//       pUser: user,
//       pParola: userPassMD5,
//     );
//
//     ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
//       pUser: user,
//       pParola: userPassMD5,
//       pDeviceToken: deviceToken,
//       pTipDispozitiv: Platform.isAndroid ? '1' : '2',
//       pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
//       pTokenVoip: '',
//     );
//
//     if (resGetCont != null && resGetTotaluriDashboardMedic != null) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (context) => NotificationDetailsScreen(
//             totaluriMedic: resGetTotaluriDashboardMedic,
//             contMedicMobile: resGetCont,
//             page: page,
//           ),
//         ),
//             (route) => false,
//       );
//     }
//   }
//
//
//   Future<void> saveNotificationData(OSNotification notification) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString(pref_keys.notificationTitle, notification.title ?? 'Fără Titlu');
//     await prefs.setString(pref_keys.notificationBody, notification.body ?? 'Fără corp');
//     await prefs.setString(pref_keys.notificationData, notification.additionalData?.toString() ?? 'Fără date');
//
//     String? alertMessage = notification.body;
//     if (alertMessage != null) {
//       if (alertMessage.toLowerCase().contains('apel')) {
//         navigateToNotificationScreen(context, 'apel');
//       } else if (alertMessage.toLowerCase().contains('recomandare')) {
//         navigateToNotificationScreen(context, 'recomandare');
//       } else if (alertMessage.toLowerCase().contains('întrebare')) {
//         navigateToNotificationScreen(context, 'întrebare');
//       }
//     }
//   }
//
//
//   // Future<void> ensureDeviceToken() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //
//   //   String? deviceToken = prefs.getString('deviceToken');
//   //
//   //   if (deviceToken == null || deviceToken.isEmpty) {
//   //     final String? newToken = OneSignal.User.pushSubscription.id;
//   //
//   //     if (newToken != null) {
//   //       await prefs.setString('deviceToken', newToken);
//   //     } else {}
//   //   } else {}
//   // }
//
//   aa()async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String? deviceToken = prefs.getString('deviceToken');
//
//     print('bbbb : ${deviceToken}');
//   }
//
//   Future<TotaluriMedic?> getTotaluriDashboardMedic() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//
//     totaluriMedic = await apiCallFunctions.getTotaluriDashboardMedic(
//       pUser: user,
//       pParola: userPassMD5,
//     );
//
//     return totaluriMedic;
//   }
//
//   Future<void> getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     String user = prefs.getString('user') ?? '';
//     String userPassMD5 = prefs.getString(pref_keys.userPassMD5) ?? '';
//     String deviceToken = prefs.getString('deviceToken') ?? '';
//
//     try {
//       if (user.isNotEmpty) {
//         TotaluriMedic? resGetTotaluriDashboardMedic = await getTotaluriDashboardMedic();
//
//         ContMedicMobile? resGetCont = await apiCallFunctions.getContMedic(
//           pUser: user,
//           pParola: userPassMD5,
//           pDeviceToken: deviceToken,
//           pTipDispozitiv: Platform.isAndroid ? '1' : '2',
//           pModelDispozitiv: await apiCallFunctions.getDeviceInfo(),
//           pTokenVoip: '',
//         );
//
//         if (resGetCont == null) {}
//
//         if (resGetTotaluriDashboardMedic != null) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => DashboardScreen(
//                 contMedicMobile: resGetCont!,
//                 totaluriMedic: resGetTotaluriDashboardMedic,
//               ),
//             ),
//           );
//         }
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const LoginMedicScreen(),
//           ),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initOneSignal();
//
//     // aa();
//   }
//
//   @override
//   void dispose() {
//     // callService.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(child: Image.asset('./assets/images/Sos_Bebe_logo.png', height: 198, width: 158)),
//     );
//   }
// }
