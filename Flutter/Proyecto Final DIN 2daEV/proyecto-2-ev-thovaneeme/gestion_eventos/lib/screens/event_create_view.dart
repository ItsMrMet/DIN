import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventCreateView extends StatefulWidget {
  const EventCreateView({super.key});

  @override
  _EventCreateViewState createState() => _EventCreateViewState();
}

class _EventCreateViewState extends State<EventCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  DateTime _selectedDate = DateTime.now();
  String? _imagePath;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showDiscardDialog,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Evento', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: _saveEvent,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Título del evento
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length < 5 ||
                        value.length > 50) {
                      return 'El título es obligatorio y debe tener entre 5 y 50 caracteres';
                    }
                    return null;
                  },
                  onChanged: (_) => _hasChanges = true,
                ),
                SizedBox(height: 16),

                // Descripción del evento
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  maxLength: 255,
                  onChanged: (_) => _hasChanges = true,
                ),
                SizedBox(height: 16),

                // Precio del evento
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null ||
                        double.parse(value) < 0) {
                      return 'Debe ingresar un precio válido (no negativo)';
                    }
                    return null;
                  },
                  onChanged: (_) => _hasChanges = true,
                ),
                SizedBox(height: 16),

                // Selector de fecha
                ListTile(
                  title: Text("Fecha: ${_selectedDate.toLocal()}"),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _hasChanges = true;
                      });
                    }
                  },
                ),
                SizedBox(height: 16),

                // Selector de imagen
                if (_imagePath != null)
                  Column(
                    children: [
                      Image.asset(_imagePath!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _removeImage,
                        child: Text('Eliminar Imagen'),
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Seleccionar Imagen'),
                ),
                SizedBox(height: 20),

                // Botones de Crear y Descartar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _saveEvent,
                      child: Text('Crear Evento'),
                    ),
                    ElevatedButton(
                      onPressed: _showDiscardConfirmationDialog,
                      child: Text('Descartar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Seleccionar una imagen
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _hasChanges = true;
      });
    }
  }

  // Eliminar la imagen seleccionada
  void _removeImage() {
    setState(() {
      _imagePath = null;
      _hasChanges = true;
    });
  }

  // Guardar el evento
  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      final newEvent = Event(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        date: _selectedDate,
        price: double.parse(_priceController.text),
        imagePath: _imagePath,
      );

      Provider.of<EventProvider>(context, listen: false).addEvent(newEvent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Evento creado con éxito')),
      );
      Navigator.pop(context);
    }
  }

  // Mostrar diálogo de confirmación para descartar cambios
  Future<void> _showDiscardConfirmationDialog() async {
    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Descartar cambios'),
          content: Text('¿Estás seguro de que deseas descartar los cambios?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Descartar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      Navigator.pop(context);
    }
  }

  // Mostrar diálogo de confirmación al intentar salir sin guardar
  Future<bool> _showDiscardDialog() async {
    if (!_hasChanges) return true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Descartar cambios'),
          content: Text(
              '¿Estás seguro de que deseas salir sin guardar los cambios?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Salir'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }
}
