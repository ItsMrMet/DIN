import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class EventStorageService {
  static const String _keyEvents = 'events';

  // Cargar eventos desde SharedPreferences
  Future<List<Event>> loadEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? eventsJson = prefs.getString(_keyEvents);

      if (eventsJson != null) {
        List<dynamic> decodedEvents = json.decode(eventsJson);
        return decodedEvents.map((e) => Event.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error al cargar los eventos: $e");
      throw Exception('Error al cargar los eventos: $e');
    }
    return [];
  }

  // Guardar eventos en SharedPreferences
  Future<void> saveEvents(List<Event> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String eventsJson = json.encode(events.map((e) => e.toJson()).toList());

      // Solo guardamos si la lista ha cambiado
      if (prefs.getString(_keyEvents) != eventsJson) {
        await prefs.setString(_keyEvents, eventsJson);
      }
    } catch (e) {
      print("Error al guardar los eventos: $e");
      throw Exception('Error al guardar los eventos: $e');
    }
  }
}
