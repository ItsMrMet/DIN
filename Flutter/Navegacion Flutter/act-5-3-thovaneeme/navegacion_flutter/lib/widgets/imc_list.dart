import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/imc_provider.dart';

class IMCList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imcProvider = Provider.of<IMCProvider>(context);
    final records = imcProvider.records;

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (ctx, index) {
        final record = records[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(
              'Altura: ${record.height}m, Peso: ${record.weight}kg',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'IMC: ${record.imc.toStringAsFixed(2)} - ${record.interpretation}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        );
      },
    );
  }
}
