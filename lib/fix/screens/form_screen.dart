import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sos_bebe_profil_bebe_doctor/fix/appConfig.dart';
import 'package:sos_bebe_profil_bebe_doctor/fix/servises%20/services.dart';

class Form_Screen extends StatefulWidget {
  final int sessionId;
  final ConsultationService _consultationService = ConsultationService();
  Form_Screen({required this.sessionId});

  @override
  _Form_ScreenState createState() => _Form_ScreenState();
}

class _Form_ScreenState extends State<Form_Screen> {
  // Use the session ID passed to the widget
  late Map<String, dynamic> _currentConsultation;

  @override
  void initState() {
    super.initState();
    _currentConsultation = {'id': widget.sessionId};
  }

  // Define text styles to match the image's design
  final titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black);
  final headerStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]);
  final labelStyle = TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500);
  final valueStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  // Fetch questionnaire data for a specific consultation session
  Future<Map<String, dynamic>> getQuestionnaire(int sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl2}/consultation/$sessionId/questionnaire/'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error ?? 'Failed to get questionnaire');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Calculate age from birth date in years and months
  String calculateAge(String birthDateStr) {
    final birthDate = DateTime.parse(birthDateStr);
    final now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    return '$years ani și $months luni';
  }

  // Build a row for patient information
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: labelStyle),
          Spacer(),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }

  // Build symptom rows with labels and checkboxes
  List<Widget> buildSymptomRows(Map<String, dynamic> data) {
    final symptomLabels = {
      'febra': 'Febră',
      'tuse': 'Tuse',
      'dificultati_respiratorii': 'Dificultăți respiratorii',
      'astenie': 'Astenie',
      'cefalee': 'Cefalee',
      'dureri_in_gat': 'Dureri în gât',
      'greturi_varsaturi': 'Greturi/Vărsături',
      'diaree_constipatie': 'Diaree/Constipație',
      'refuzul_alimentatie': 'Refuzul alimentație',
      'iritatii_piele': 'Iritații piele',
      'nas_infundat': 'Nas înfundat',
      'rinoree': 'Rinoree',
    };
    List<Widget> symptomWidgets = [];
    for (var entry in symptomLabels.entries) {
      final key = entry.key;
      final label = entry.value;
      final isChecked = data[key] == true;
      symptomWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(label, style: labelStyle),
              Spacer(),
              isChecked
                  ? Icon(Icons.radio_button_checked, color: Color(0xFF1ED69E))
                  : Icon(Icons.radio_button_unchecked, color: Colors.grey),
            ],
          ),
        ),
      );
      if (entry != symptomLabels.entries.last) {
        symptomWidgets.add(Divider(color: Colors.grey[300]));
      }
    }
    return symptomWidgets;
  }

  // Placeholder function to update consultation status
  Future<void> _updateStatus(String status) async {
    // Replace with actual implementation, e.g., API call to update status
    await widget._consultationService.updateConsultationStatus(widget.sessionId, status);
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildFormSubmittedScreen(),
      ),
    );
  }

  // Redesigned widget to match the image layout with dividers
  Widget _buildFormSubmittedScreen() {
    return FutureBuilder<Map<String, dynamic>>(
      future: getQuestionnaire(_currentConsultation['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        } else {
          final data = snapshot.data!['data'];
          final age = calculateAge(data['data_nastere']);
          final isAllergic = data['alergic_la_vreun_medicament'] == true;

          // Patient information widgets with dividers
          List<Widget> patientInfoWidgets = [
            buildInfoRow('Nume și Prenume Pacient:', data['nume_si_prenume']),
            Divider(color: Colors.grey[300]),
            buildInfoRow('Vârsta:', age),
            Divider(color: Colors.grey[300]),
            buildInfoRow('Greutate:', '${data['greutate']} kg'),
            Divider(color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Text('Alergic la Paracetamol:', style: labelStyle),
                  Spacer(),
                  isAllergic
                      ? Icon(Icons.radio_button_checked, color: Color(0xFF1ED69E))
                      : Icon(Icons.radio_button_unchecked, color: Colors.grey),
                ],
              ),
            ),
          ];

          // Symptoms widgets with dividers
          List<Widget> symptomWidgets = buildSymptomRows(data);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text('Chestionar', style: titleStyle),
                  SizedBox(height: 20),

                  // Patient Information Section with dividers
                  ...patientInfoWidgets,
                  Divider(color: Colors.grey[300], thickness: 2), // Section separator

                  // Symptoms Section
                  Text('Simptome Pacient', style: headerStyle),
                  SizedBox(height: 10),
                  ...symptomWidgets,
                  SizedBox(height: 20),

                  // Action Button
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () => _updateStatus('callReady'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'CONTINUA CU APEL VIDEO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

