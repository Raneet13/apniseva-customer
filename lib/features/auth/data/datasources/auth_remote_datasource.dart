import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_endpoints.dart';

class AuthRemoteDataSource {
  Future<Map<String, dynamic>> loginWithOtp(String mobile) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.loginOtp),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contact": mobile,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyUser(String mobile) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.verifyOtp),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contact": mobile,
      }),
    );

    return jsonDecode(response.body);
  }
}
