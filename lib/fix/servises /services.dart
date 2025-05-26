import 'dart:convert';
import 'package:http/http.dart' as http;

class ConsultationService {
  static const String baseUrl = 'http://10.0.2.2:8000/api'; //10.0.2.2

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
      ) async {
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
}