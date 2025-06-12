import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_imc_screen.dart';
import '../providers/imc_provider.dart';
import '../widgets/imc_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imcProvider = Provider.of<IMCProvider>(context);
    final lastRecord =
        imcProvider.records.isNotEmpty ? imcProvider.records.last : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('IMC Manager'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Último IMC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    lastRecord != null
                        ? Column(
                            children: [
                              Text(
                                '${lastRecord.imc.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Estado: ${lastRecord.interpretation}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          )
                        : Text(
                            'No hay registros',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: IMCList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIMCScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
