import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sos_bebe_profil_bebe_doctor/localizations/1_localizations.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_call_functions.dart';
import 'package:sos_bebe_profil_bebe_doctor/utils_api/api_config.dart';


class ConsultSetPriceScreen extends StatefulWidget {
  const ConsultSetPriceScreen({super.key});

  @override
  State<ConsultSetPriceScreen> createState() => _ConsultSetPriceScreenState();
}

class _ConsultSetPriceScreenState extends State<ConsultSetPriceScreen> {
  final TextEditingController _videoConsultController = TextEditingController();
  final TextEditingController _answerQuestionController = TextEditingController();
  final TextEditingController _analyzeInterpretController = TextEditingController();

  static const String videoConsultPriceKey = 'videoConsultPrice';
  static const String answerQuestionPriceKey = 'answerQuestionPrice';
  static const String analyzeInterpretPriceKey = 'analyzeInterpretPrice';

  final ApiCallFunctions apiCallFunctions = ApiCallFunctions();

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _videoConsultController.text = prefs.getString(videoConsultPriceKey) ?? '';
      _answerQuestionController.text = prefs.getString(answerQuestionPriceKey) ?? '';
      _analyzeInterpretController.text = prefs.getString(analyzeInterpretPriceKey) ?? '';
    });
  }

  Future<void> _savePrices() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(videoConsultPriceKey, _videoConsultController.text);
    await prefs.setString(answerQuestionPriceKey, _answerQuestionController.text);
    await prefs.setString(analyzeInterpretPriceKey, _analyzeInterpretController.text);
  }

  Future<void> _updatePricesOnServer() async {
    // Assuming you have these credentials stored in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final pUser = prefs.getString('user') ?? '';  // Retrieve username
    final pParolaMD5 = prefs.getString('userPassMD5') ?? ''; // Retrieve password in MD5 format
    const pKey = pCheie; // Replace with the actual API key

    final response = await apiCallFunctions.updateMedicPrices(
      pCheie: pKey,
      pUser: pUser,
      pParolaMD5: pParolaMD5,
      pPretServiciuPrimesteIntrebari: _answerQuestionController.text,
      pPretServiciuInterpreteazaAnalize: _analyzeInterpretController.text,
      pPretServiciuConsultVideo: _videoConsultController.text,
    );

    if (response != null && response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prices updated successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update prices on the server.')),
      );
    }
  }

  bool _isValidInput(String value) {
    if (value.isEmpty) return false;
    final number = int.tryParse(value);
    return number != null && number >= 1;
  }

  Widget _buildPriceField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    hintText: '..............',
                  ),
                  onChanged: (value) {
                    if (!_isValidInput(value)) {
                      controller.clear();
                    }
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'RON',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    LocalizationsApp l = LocalizationsApp.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
        appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: const Color.fromRGBO(30, 214, 158, 1),
          foregroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () async {
              Navigator.pop(context, true);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Preț stabilit',
            style: GoogleFonts.rubik(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 80),
                  _buildPriceField("RASPUNDE LA ÎNTREBARE", _answerQuestionController),

                  const SizedBox(height: 30),
                  _buildPriceField("CONSULTAȚIE VIDEO", _videoConsultController),
                  const SizedBox(height: 30),
                  _buildPriceField("INTERPRETEAZĂ ANALIZE", _analyzeInterpretController),
                  const SizedBox(height: 175),
                  GestureDetector(
                    onTap: () async {
                      if (_isValidInput(_videoConsultController.text) &&
                          _isValidInput(_answerQuestionController.text) &&
                          _isValidInput(_analyzeInterpretController.text)) {
                        await _savePrices();  // Save to SharedPreferences
                        await _updatePricesOnServer();  // Update on server
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter valid prices (>= 1)')),
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(30, 214, 158, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "SALVEAZĂ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
