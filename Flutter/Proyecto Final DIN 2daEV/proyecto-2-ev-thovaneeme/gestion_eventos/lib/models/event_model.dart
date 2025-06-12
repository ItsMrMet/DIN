class Event {
  String id;
  String title;
  String description;
  DateTime date;
  double price;
  String? imagePath;
  bool isFavorite;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.price,
    this.imagePath,
    this.isFavorite = false,
  }) {
    if (title.isEmpty) throw ArgumentError('El título no puede estar vacío');
    if (price < 0) throw ArgumentError('El precio no puede ser negativo');
  }

  // Método para cambiar el estado de favorito
  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  // Método para verificar si el evento ya ha pasado
  bool isPastEvent() {
    return date.isBefore(DateTime.now());
  }

  // Método para convertir un objeto Event a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(), // Convertir DateTime a String
      'price': price,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
    };
  }

  // Método para crear un objeto Event a partir de un mapa JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']), // Convertir String a DateTime
      price: json['price'],
      imagePath: json['imagePath'],
      isFavorite:
          json['isFavorite'] ?? false, // Usar un valor por defecto si es null
    );
  }
}
