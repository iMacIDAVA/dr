import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/fix/appConfig.dart';

class ConsultationService {
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; //10.0.2.2
  static const String baseUrl = ApiConfig.baseUrl;

  // Get current consultation for doctor
  Future<Map<String, dynamic>> getCurrentConsultation(int doctorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/consultation/current/doctor/$doctorId/'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get current consultation');
      }
    } catch (e) {
      print(e);
      throw Exception('Errowwßr: $e');
    }
  }

  // Update consultation status
  Future<Map<String, dynamic>> updateConsultationStatus(
      int consultationId,
      String action,
      ) async
  {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/consultation/$consultationId/$action/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update consultation status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }



    // Get questionnaire for a specific consultation
    Future<Map<String, dynamic>> getQuestionnaire(int sessionId) async {
      try {
        //http://127.0.0.1:8000/consultation/19/questionnaire/
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/consultation/19/questionnaire/'),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print(response.body);
          return json.decode(response.body);
        } else {
          final error = json.decode(response.body);
          throw Exception(error ?? 'Failed to get questionnaire');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    }


}