import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/event_model.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final String _baseUrl = 'http://localhost:3000/eventos'; // URL del servidor

  EventProvider() {
    loadEvents(); // Cargar eventos al iniciar
  }

  // Cargar eventos desde el servidor
  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _events = data.map((json) => Event.fromJson(json)).toList();
      } else {
        _error = 'Error al cargar los eventos: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error al cargar los eventos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener un evento por ID
  Event? getEventById(String id) {
    try {
      return _events.firstWhere((event) => event.id == id);
    } catch (e) {
      debugPrint('Evento no encontrado: $e');
      return null;
    }
  }

  // Agregar un evento al servidor
  Future<void> addEvent(Event event) async {
    if (event.title.isEmpty || event.date.isBefore(DateTime.now())) {
      throw Exception('Datos del evento no válidos');
    }
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.toJson()),
      );
      if (response.statusCode == 201) {
        _events.add(event);
        notifyListeners();
      } else {
        throw Exception('Error al agregar el evento: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al agregar el evento: $e');
      throw Exception('Error al agregar el evento');
    }
  }

  // Eliminar un evento del servidor
  Future<void> deleteEvent(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/$id'));
      if (response.statusCode == 200) {
        _events.removeWhere((event) => event.id == id);
        notifyListeners();
      } else {
        throw Exception('Error al eliminar el evento: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al eliminar el evento: $e');
      throw Exception('Error al eliminar el evento');
    }
  }

  // Cambiar el estado de favorito de un evento
  Future<void> toggleFavorite(Event event) async {
    event.isFavorite = !event.isFavorite;
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${event.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(event.toJson()),
      );
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw Exception(
            'Error al actualizar favoritos: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al actualizar favoritos: $e');
      throw Exception('Error al actualizar favoritos');
    }
  }

  // Actualizar un evento en el servidor
  Future<void> updateEvent(Event updatedEvent) async {
    if (updatedEvent.title.isEmpty ||
        updatedEvent.date.isBefore(DateTime.now())) {
      throw Exception('Datos del evento no válidos');
    }
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/${updatedEvent.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedEvent.toJson()),
      );
      if (response.statusCode == 200) {
        final index =
            _events.indexWhere((event) => event.id == updatedEvent.id);
        if (index != -1) {
          _events[index] = updatedEvent;
          notifyListeners();
        }
      } else {
        throw Exception(
            'Error al actualizar el evento: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error al actualizar el evento: $e');
      throw Exception('Error al actualizar el evento');
    }
  }
}
