import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveEvent(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      print("Error al guardar el evento: $e");
      throw Exception('Error al guardar el evento: $e');
    }
  }

  static Future<String?> getEvent(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print("Error al obtener el evento: $e");
      throw Exception('Error al obtener el evento: $e');
    }
  }
}
