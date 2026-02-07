import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Added
import 'package:mise_frontend/app/controller/expenses/list_controller.dart';
import 'package:mise_frontend/app/controller/split_share/shared_controller.dart';

class VoiceController extends GetxController {
  final SpeechToText _speech = SpeechToText();
  final Dio _dio = Dio();
  
  var isListening = false.obs;
  var recognizedText = "Listening...".obs;

  // Use 10.0.2.2 for Android Emulator, or your PC IP for physical devices
  final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  void toggleListening() async {
    if (isListening.value) {
      _speech.stop();
      isListening.value = false;
    } else {
      bool available = await _speech.initialize(
        onError: (val) => print('Error: $val'),
        onStatus: (val) => print('Status: $val'),
      );
      
      if (available) {
        isListening.value = true;
        recognizedText.value = "Say something...";
        
        _speech.listen(
          onResult: (result) {
            recognizedText.value = result.recognizedWords;
            if (result.finalResult) {
              isListening.value = false;
              _processVoiceCommand(result.recognizedWords);
            }
          },
        );
      }
    }
  }

  Future<void> _processVoiceCommand(String text) async {
    try {
      Get.showOverlay(
        asyncFunction: () async {
          final response = await _dio.post('$baseUrl/voice-expense', data: {"text": text});
          
          if (response.statusCode == 200) {
            final type = response.data['type'];
            final data = response.data['data'];

            if (type == "personal") {
              // REFRESH: Tells the Home/List controller to fetch new data from DB
              Get.find<HomeController>().fetchExpenses();
              _showSuccessSnackbar("Added ₦${data['amount']} to ${data['category']}");
            } 
            else if (type == "split") {
              // REFRESH: Tells the Shared controller to fetch updated debts
              Get.find<SharedController>().fetchSharedDebts();
              _showSuccessSnackbar("Split ₦${data['amount']} with ${data['name']}");
            }
          }
        },
        loadingWidget: const Center(child: CircularProgressIndicator(color: Color(0xFFB4F59E))),
      );
    } catch (e) {
      Get.snackbar("Command Error", "Could not understand voice command.");
    }
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar("Success", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFB4F59E),
        colorText: Colors.black,
        duration: const Duration(seconds: 3));
  }
}