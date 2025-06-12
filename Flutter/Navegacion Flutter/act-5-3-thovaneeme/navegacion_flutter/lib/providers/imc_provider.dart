import 'package:flutter/material.dart';
import '../models/imc_model.dart';

class IMCProvider with ChangeNotifier {
  final List<IMCRecord> _records = [];

  List<IMCRecord> get records => _records;

  void addRecord(double height, double weight) {
    _records.add(IMCRecord(height: height, weight: weight));
    notifyListeners();
  }
}
