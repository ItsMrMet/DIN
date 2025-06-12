import 'package:flutter/material.dart';

void main() {
  runApp(EstadosFlutter());
}

class EstadosFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ButtonStateManager(),
    );
  }
}

class ButtonStateManager extends StatefulWidget {
  @override
  _ButtonStateManagerState createState() => _ButtonStateManagerState();
}

class _ButtonStateManagerState extends State<ButtonStateManager> {
  Color _iconColor = Colors.grey; // Initial color of the icon
  int _selectedButton = -1; // No button selected initially

  // Define the colors for the buttons
  final List<Color> _buttonColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  void _onButtonPressed(int index) {
    setState(() {
      _selectedButton = index;
      _iconColor = _buttonColors[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Estados en Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_reaction,
              color: _iconColor,
              size: 100.0,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_buttonColors.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () => _onButtonPressed(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedButton == index
                          ? _buttonColors[index]
                          : Colors.grey[300],
                    ),
                    child: Text('Botón ${index + 1}'),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
