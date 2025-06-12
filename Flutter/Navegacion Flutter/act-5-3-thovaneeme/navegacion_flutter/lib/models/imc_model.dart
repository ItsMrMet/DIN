class IMCRecord {
  final double height;
  final double weight;
  final double imc;
  final String interpretation;

  IMCRecord({
    required this.height,
    required this.weight,
  })  : imc = weight / (height * height),
        interpretation = _interpretIMC(weight / (height * height));

  static String _interpretIMC(double imc) {
    if (imc < 18.5) {
      return 'Delgadez';
    } else if (imc >= 18.5 && imc <= 24.9) {
      return 'Saludable';
    } else if (imc >= 25.0 && imc <= 29.9) {
      return 'Sobrepeso';
    } else {
      return 'Obesidad';
    }
  }
}
