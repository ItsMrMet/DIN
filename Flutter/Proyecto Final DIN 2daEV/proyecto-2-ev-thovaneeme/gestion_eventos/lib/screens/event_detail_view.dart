import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventDetailView extends StatelessWidget {
  final String eventId;

  const EventDetailView({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final event = Provider.of<EventProvider>(context).getEventById(eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Evento no encontrado")),
        body: Center(child: Text('El evento no existe')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/edit', arguments: event).then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailView(eventId: event.id),
                  ),
                );
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () => _showDeleteConfirmationDialog(context, event),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(event.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Fecha: ${DateFormat('dd/MM/yyyy').format(event.date)}',
                style: TextStyle(fontSize: 16)),
            Text('Precio: \$${event.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            event.imagePath != null
                ? Image.asset(event.imagePath!,
                    height: 200, width: double.infinity, fit: BoxFit.cover)
                : Text('No hay imagen disponible',
                    style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _toggleFavorite(context, event),
              child: Text(event.isFavorite
                  ? 'Eliminar de Favoritos'
                  : 'Marcar como Favorito'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este evento?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Provider.of<EventProvider>(context, listen: false)
                    .deleteEvent(event.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Evento eliminado con éxito')),
                );
                Navigator.pop(context); // Cerrar el diálogo
                Navigator.pop(context); // Volver a la vista de listado
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, Event event) {
    Provider.of<EventProvider>(context, listen: false).toggleFavorite(event);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(event.isFavorite
            ? 'Marcado como favorito'
            : 'Eliminado de favoritos'),
      ),
    );
  }
}
