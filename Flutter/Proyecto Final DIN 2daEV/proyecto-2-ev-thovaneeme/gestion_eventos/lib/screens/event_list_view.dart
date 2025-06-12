import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../models/event_model.dart';
import '../screens/event_detail_view.dart';

class EventListView extends StatefulWidget {
  const EventListView({super.key});

  @override
  _EventListViewState createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {
  bool showPastEvents = false;
  bool showFavoritesOnly = false;
  bool sortByDate = false;
  bool sortByPrice = false;

  @override
  void initState() {
    super.initState();
    // Cargar eventos al iniciar la vista
    Provider.of<EventProvider>(context, listen: false).loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Listado de Eventos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/create');
            },
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventsProvider, child) {
          if (eventsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (eventsProvider.error != null) {
            return Center(
              child: Text(
                eventsProvider.error!,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (eventsProvider.events.isEmpty) {
            return Center(child: Text('No hay eventos disponibles'));
          }

          // Filtrar eventos según los filtros activos
          List<Event> filteredEvents = eventsProvider.events.where((event) {
            // Filtrar por favoritos
            if (showFavoritesOnly && !event.isFavorite) return false;

            // Filtrar por eventos pasados
            if (!showPastEvents && event.isPastEvent()) return false;

            return true;
          }).toList();

          // Ordenar eventos
          if (sortByDate) {
            filteredEvents.sort((a, b) => a.date.compareTo(b.date));
          } else if (sortByPrice) {
            filteredEvents.sort((a, b) => a.price.compareTo(b.price));
          }

          return Column(
            children: [
              // Controles para ordenar y filtrar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                          showFavoritesOnly
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: const Color.fromARGB(255, 255, 0, 0)),
                      onPressed: () {
                        setState(() {
                          showFavoritesOnly = !showFavoritesOnly;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          sortByDate
                              ? Icons.date_range
                              : Icons.date_range_outlined,
                          color: const Color.fromARGB(255, 212, 0, 255)),
                      onPressed: () {
                        setState(() {
                          sortByDate = !sortByDate;
                          sortByPrice = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          sortByPrice
                              ? Icons.attach_money
                              : Icons.attach_money_outlined,
                          color: const Color.fromARGB(255, 9, 151, 4)),
                      onPressed: () {
                        setState(() {
                          sortByPrice = !sortByPrice;
                          sortByDate = false;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          showPastEvents
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          showPastEvents = !showPastEvents;
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Número de columnas
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detail',
                          arguments: event,
                        );
                      },
                      child: EventCard(event: event),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
