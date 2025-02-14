import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static Future<void> saveLastSyncedTime(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String timestamp = DateTime.now().toString();
    await prefs.setString(key, timestamp);
  }

  static Future<String?> getLastSyncedTime(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "Never";
  }

  // Save API response data
  static Future<void> saveApiData(String key, dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(data);
    await prefs.setString('${key}_data', jsonData);
  }

  // Get API response data
  static Future<dynamic> getApiData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('${key}_data');
    return jsonData != null ? jsonDecode(jsonData) : null;
  }
}
