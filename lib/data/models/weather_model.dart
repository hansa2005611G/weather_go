class WeatherModel {
  final String city;
  final double temp;
  final int humidity;
  final double wind;
  final int visibility;
  final int sunrise;
  final String condition;


  final double lat;
  final double lon;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.visibility,
    required this.sunrise,
    required this.condition,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      wind: json['wind']['speed'].toDouble(),
      visibility: json['visibility'],
      sunrise: json['sys']['sunrise'],
      condition: json['weather'][0]['main'],


      lat: json['coord']['lat'].toDouble(),
      lon: json['coord']['lon'].toDouble(),
    );
  }
}
