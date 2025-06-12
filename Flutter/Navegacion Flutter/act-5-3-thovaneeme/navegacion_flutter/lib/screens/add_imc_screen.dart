import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imc_provider.dart';

class AddIMCScreen extends StatefulWidget {
  @override
  _AddIMCScreenState createState() => _AddIMCScreenState();
}

class _AddIMCScreenState extends State<AddIMCScreen> {
  final _formKey = GlobalKey<FormState>();
  double _height = 0.0;
  double _weight = 0.0;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<IMCProvider>(context, listen: false)
          .addRecord(_height, _weight);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Altura (m)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty ||
                              double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Introduce una altura válida';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _height = double.parse(value!);
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Peso (kg)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty ||
                              double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Introduce un peso válido';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _weight = double.parse(value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Guardar', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
