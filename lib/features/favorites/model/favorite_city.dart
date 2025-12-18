class FavoriteCity {
  final String name;
  final double temp;
  final String condition;

  FavoriteCity({
    required this.name,
    required this.temp,
    required this.condition,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'temp': temp,
        'condition': condition,
      };

  // Convert from JSON
  factory FavoriteCity.fromJson(Map<String, dynamic> json) {
    return FavoriteCity(
      name: json['name'],
      temp: (json['temp'] as num).toDouble(),
      condition: json['condition'],
    );
  }
}
