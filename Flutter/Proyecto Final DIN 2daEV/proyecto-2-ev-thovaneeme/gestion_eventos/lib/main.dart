import 'package:flutter/material.dart';
import 'package:gestion_eventos/models/event_model.dart';
import 'package:gestion_eventos/screens/event_edit_view.dart';
import 'package:provider/provider.dart';
import 'providers/event_provider.dart';
import 'screens/event_list_view.dart';
import 'screens/event_create_view.dart';
import 'screens/event_detail_view.dart';

void main() {
  runApp(MyApp());
}

class AppRoutes {
  static const String home = '/';
  static const String create = '/create';
  static const String edit = '/edit';
  static const String detail = '/detail';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Eventos',
        theme: _buildTheme(),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => EventListView(),
          AppRoutes.create: (context) => EventCreateView(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.edit) {
            final event = settings.arguments as Event;
            return MaterialPageRoute(
              builder: (context) => EventEditView(event: event),
            );
          } else if (settings.name == AppRoutes.detail) {
            final event = settings.arguments as Event;
            return MaterialPageRoute(
              builder: (context) => EventDetailView(eventId: event.id),
            );
          }
          // Ruta por defecto para rutas no definidas
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(
                child: Text('Ruta no encontrada'),
              ),
            ),
          );
        },
      ),
    );
  }

  // Define tu tema personalizado
  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color.fromARGB(255, 206, 206, 206),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        elevation: 4,
        toolbarTextStyle: TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).bodyMedium,
        titleTextStyle: TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).titleLarge,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        labelStyle: TextStyle(color: Colors.blue),
      ),
    );
  }
}
