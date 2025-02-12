import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://49.207.44.107/mvas";

  Future<Map<String, dynamic>?> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print("PoSTING request");
      print("$baseUrl$endpoint");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Request Failed: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getRequest(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: {"Content-Type": "application/json"},
      );
      print("GETTING request");
      print("$baseUrl$endpoint");
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Request Failed: $e");
      return null;
    }
  }
}
