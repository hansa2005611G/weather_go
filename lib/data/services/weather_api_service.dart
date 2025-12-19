import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class WeatherApiService {
  final Dio _dio = Dio();

  // Current weather by city 
  Future<Response> getWeatherByCity(String city) {
    return _dio.get(
      '${ApiConstants.baseUrl}/weather',
      queryParameters: {
        'q': city,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
      },
    );
  }

  // Current weather by location 
  Future<Response> getWeatherByLocation(double lat, double lon) {
    return _dio.get(
      '${ApiConstants.baseUrl}/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
      },
    );
  }

  // 5-day / 3-hour forecast 
  Future<Response> get5DayForecast(double lat, double lon) {
    return _dio.get(
      '${ApiConstants.baseUrl}/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': ApiConstants.apiKey,
        'units': 'metric',
      },
    );
  }
}
