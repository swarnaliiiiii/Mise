import 'package:dio/dio.dart';

class ExpenseProvider {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000", // Standard Android Emulator URL for localhost
    connectTimeout: const Duration(seconds: 5),
  ));

  Future<Response> postExpense(Map<String, dynamic> data) async {
    try {
      // Calls the @app.post("/expense") endpoint defined in main.py
      return await _dio.post("/expense", data: data);
    } on DioException catch (e) {
      throw e.message ?? "Failed to save expense";
    }
  }
}