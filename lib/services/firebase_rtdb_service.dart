import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FirebaseRtdbService {
  static const String _databaseUrl = 'https://mehrab-5f85d-default-rtdb.firebaseio.com/.json';

  /// Fetch all lecture/lesson records from Firebase Realtime Database
  static Future<List<Map<String, dynamic>>> fetchAllLectures() async {
    try {
      final response = await http.get(Uri.parse(_databaseUrl));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<Map<String, dynamic>> items = [];

        if (decoded is List) {
          for (var item in decoded) {
            if (item != null && item is Map) {
              items.add(Map<String, dynamic>.from(item));
            }
          }
        } else if (decoded is Map) {
          decoded.forEach((key, value) {
            if (value is Map) {
              items.add(Map<String, dynamic>.from(value));
            } else if (value is List) {
              for (var item in value) {
                if (item != null && item is Map) {
                  items.add(Map<String, dynamic>.from(item));
                }
              }
            }
          });
        }
        return items;
      } else {
        debugPrint('Firebase RTDB HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Firebase RTDB error: $e');
    }
    return [];
  }
}
