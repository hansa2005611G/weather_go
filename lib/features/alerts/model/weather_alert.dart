enum AlertType { temperature, rain, wind }

class WeatherAlert {
  String city;
  AlertType type;
  String condition;
  bool enabled;
  DateTime createdAt;

  WeatherAlert({
    required this.city,
    required this.type,
    required this.condition,
    this.enabled = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
