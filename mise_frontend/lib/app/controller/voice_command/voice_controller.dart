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
    // 1. Show the loading overlay
    Get.showOverlay(
      asyncFunction: () async {
        // 2. Make the request inside the asyncFunction
        final response = await _dio.post(
          '$baseUrl/voice-expense', 
          data: {"text": text},
        );

        // 3. Move your logic INSIDE here where 'response' exists
        if (response.statusCode == 200) {
          final String type = response.data['type'];
          final Map data = response.data['data'];

          if (type == "personal") {
            Get.find<HomeController>().fetchExpenses();
            _showSuccessSnackbar("Added \$${data['amount']} to ${data['category']}");
          } else if (type == "split") {
            Get.find<SharedController>().fetchSharedDebts();
            _showSuccessSnackbar("Split \$${data['amount']} with ${data['name']}");
          }
        }
      },
      loadingWidget: const Center(child: CircularProgressIndicator(color: Color(0xFFB4F59E))),
    );
  } on DioException catch (e) {
    // 4. Extract the helpful error message from your FastAPI detail
    String errorMessage = e.response?.data['detail'] ?? "Could not understand voice command.";
    Get.snackbar("Command Error", errorMessage);
  } catch (e) {
    Get.snackbar("Error", "An unexpected error occurred.");
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