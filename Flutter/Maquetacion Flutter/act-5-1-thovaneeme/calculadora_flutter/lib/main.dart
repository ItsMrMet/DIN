import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: Row(
        children: [
          // Historial
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[300],
                  child: Text(
                    'Historial',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(8.0),
                    children: [
                      ListTile(
                        title: Text('3 + 5'),
                        subtitle: Text('8'),
                      ),
                      ListTile(
                        title: Text('10 - 2'),
                        subtitle: Text('8'),
                      ),
                      ListTile(
                        title: Text('6 * 7'),
                        subtitle: Text('42'),
                      ),
                      ListTile(
                        title: Text('49 / 7'),
                        subtitle: Text('7'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          VerticalDivider(width: 1, color: Colors.grey),

          // Calculadora
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[200],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Operación: 2 + 3',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Resultado: 5',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Botones
                Expanded(
                  flex: 2,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: 16, // Botones de ejemplo
                    itemBuilder: (context, index) {
                      final buttonText = index < 10
                          ? index.toString()
                          : ['+', '-', '*', '/', '=', 'C'][index - 10];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
