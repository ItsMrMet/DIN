import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventEditView extends StatefulWidget {
  final Event event;

  const EventEditView({super.key, required this.event});

  @override
  _EventEditViewState createState() => _EventEditViewState();
}

class _EventEditViewState extends State<EventEditView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late DateTime _selectedDate;
  String? _imagePath;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _priceController =
        TextEditingController(text: widget.event.price.toString());
    _selectedDate = widget.event.date;
    _imagePath = widget.event.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showDiscardDialog,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edición de ${widget.event.title}',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: _hasChanges
                  ? _saveChanges
                  : null, // Solo activo si hay cambios
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
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
                  onChanged: (_) => _setChanges(),
                ),
                SizedBox(height: 16),

                // Descripción del evento
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                  maxLength: 255,
                  onChanged: (_) => _setChanges(),
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
                  onChanged: (_) => _setChanges(),
                ),
                SizedBox(height: 16),

                // Selector de fecha
                ListTile(
                  title: Text(
                      "Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}"), // Formatea la fecha sin la hora
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                        ); // Asegúrate de que no se incluya la hora
                        _setChanges();
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

                // Botones de Guardar y Volver
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _hasChanges
                          ? _saveChanges
                          : null, // Solo activo si hay cambios
                      child: Text('Guardar'),
                    ),
                    ElevatedButton(
                      onPressed: _showDiscardConfirmationDialog,
                      child: Text('Volver'),
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
        _setChanges();
      });
    }
  }

  // Eliminar la imagen seleccionada
  void _removeImage() {
    setState(() {
      _imagePath = null;
      _setChanges();
    });
  }

  // Guardar los cambios
  void _saveChanges() {
    if (_titleController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      return;
    }

    final updatedEvent = Event(
      id: widget.event.id,
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedDate,
      price: double.parse(_priceController.text),
      imagePath: _imagePath,
    );

    Provider.of<EventProvider>(context, listen: false)
        .updateEvent(updatedEvent);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Evento actualizado con éxito')),
    );
    Navigator.pop(context); // Volver al listado
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
          title: Text('Cambios sin guardar'),
          content: Text('¿Deseas guardar los cambios antes de salir?'),
          actions: [
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                _saveChanges();
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Descartar'),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.pop(context); // Volver al listado sin guardar
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
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
          title: Text('Cambios sin guardar'),
          content: Text('¿Deseas guardar los cambios antes de salir?'),
          actions: [
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                _saveChanges();
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Descartar'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  // Marcar que hay cambios sin guardar
  void _setChanges() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }
}
