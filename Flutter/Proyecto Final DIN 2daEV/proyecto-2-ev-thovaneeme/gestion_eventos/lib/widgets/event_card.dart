import 'package:flutter/material.dart';
import 'package:gestion_eventos/providers/event_provider.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del evento
          event.imagePath != null
              ? Image.asset(
                  event.imagePath!,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: 120,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 11, 194, 169),
                  child: Center(
                    child: Icon(
                      Icons.calendar_today, // Ícono de calendario
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

          // Detalles del evento
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título del evento
                Text(
                  event.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1, // Limitar a una línea
                  overflow: TextOverflow
                      .ellipsis, // Mostrar puntos suspensivos si es demasiado largo
                ),
                SizedBox(height: 4),

                // Descripción del evento
                Text(
                  event.description,
                  maxLines: 2, // Limitar a dos líneas
                  overflow: TextOverflow
                      .ellipsis, // Mostrar puntos suspensivos si es demasiado largo
                ),
                SizedBox(height: 4),

                // Fecha del evento
                Text(
                  'Fecha: ${DateFormat('dd/MM/yyyy').format(event.date)}',
                  style: TextStyle(fontSize: 14),
                ),

                // Precio del evento
                Text(
                  'Precio: \$${event.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          // Botón de favorito
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                event.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border_outlined,
                color: const Color.fromARGB(255, 255, 0, 0),
              ),
              onPressed: () {
                // Marcar como favorito
                Provider.of<EventProvider>(context, listen: false)
                    .toggleFavorite(event);
              },
            ),
          ),
        ],
      ),
    );
  }
}
