import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/weather_model.dart';
import '../../../data/models/forecast_model.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/services/weather_api_service.dart';
import '../../../data/services/location_service.dart';

final weatherRepoProvider =
    Provider<WeatherRepository>((ref) {
  return WeatherRepository(WeatherApiService());
});

final locationServiceProvider =
    Provider<LocationService>((ref) {
  return LocationService();
});

final homeProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<HomeState>>(
  (ref) => HomeViewModel(
    ref.read(weatherRepoProvider),
    ref.read(locationServiceProvider),
  ),
);

class HomeState {
  final WeatherModel weather;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  HomeState({
    required this.weather,
    required this.hourly,
    required this.daily,
  });
}

class HomeViewModel extends StateNotifier<AsyncValue<HomeState>> {
  final WeatherRepository repo;
  final LocationService locationService;

  HomeViewModel(this.repo, this.locationService)
      : super(const AsyncLoading()) {
    _loadInitialWeather();
  }

  ///AUTO LOAD LOCATION
  Future<void> _loadInitialWeather() async {
    try {
      final position = await locationService.getCurrentLocation();

      final weather = await repo.fetchByLocation(
        position.latitude,
        position.longitude,
      );

      final forecast = await repo.fetchForecast(
        position.latitude,
        position.longitude,
      );

      state = AsyncData(
        HomeState(
          weather: weather,
          hourly: forecast['hourly'],
          daily: forecast['daily'],
        ),
      );
    } catch (e) {
      await loadByCity('Colombo');
    }
  }

  /// Load by city
  Future<void> loadByCity(String city) async {
    try {
      state = const AsyncLoading();

      final weather = await repo.fetchByCity(city);
      final forecast =
          await repo.fetchForecast(weather.lat, weather.lon);

      state = AsyncData(
        HomeState(
          weather: weather,
          hourly: forecast['hourly'],
          daily: forecast['daily'],
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
