import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService api;

  WeatherRepository(this.api);

  // Current weather by city
  Future<WeatherModel> fetchByCity(String city) async {
    final response = await api.getWeatherByCity(city);
    return WeatherModel.fromJson(response.data);
  }

  // Current weather by location
  Future<WeatherModel> fetchByLocation(double lat, double lon) async {
    final response = await api.getWeatherByLocation(lat, lon);
    return WeatherModel.fromJson(response.data);
  }

  // Forecast using FREE /forecast API
  Future<Map<String, dynamic>> fetchForecast(
      double lat, double lon) async {
    final response = await api.get5DayForecast(lat, lon);
    final List list = response.data['list'];

    // Hourly forecast (next 24h ≈ 8 items)
    final List<HourlyForecast> hourly = list.take(8).map((e) {
      return HourlyForecast(
        dt: e['dt'],
        temp: (e['main']['temp'] as num).toDouble(),
        icon: e['weather'][0]['icon'],
      );
    }).toList();

    // Daily forecast (grouped by date)
    final Map<String, DailyForecast> dailyMap = {};

    for (final e in list) {
      final date =
          DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000);
      final key = '${date.year}-${date.month}-${date.day}';

      dailyMap.putIfAbsent(
        key,
        () => DailyForecast(
          dt: e['dt'],
          min: (e['main']['temp_min'] as num).toDouble(),
          max: (e['main']['temp_max'] as num).toDouble(),
          icon: e['weather'][0]['icon'],
        ),
      );
    }

    return {
      'hourly': hourly,
      'daily': dailyMap.values.take(7).toList(),
    };
  }
}
