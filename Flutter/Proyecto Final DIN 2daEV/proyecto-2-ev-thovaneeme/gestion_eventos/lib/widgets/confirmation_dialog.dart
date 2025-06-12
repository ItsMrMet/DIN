import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onConfirm;

  const ConfirmationDialog(
      {super.key, required this.message, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmación'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: Text('Confirmar'),
        ),
      ],
    );
  }
}
