import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/weather_alert.dart';

final alertsProvider =
    StateNotifierProvider<AlertsNotifier, List<WeatherAlert>>(
  (ref) => AlertsNotifier(),
);

final alertHistoryProvider =
    StateNotifierProvider<AlertHistoryNotifier, List<String>>(
  (ref) => AlertHistoryNotifier(),
);

class AlertsNotifier extends StateNotifier<List<WeatherAlert>> {
  AlertsNotifier() : super([]);

  // CREATE
  void addAlert(WeatherAlert alert) {
    state = [...state, alert];
  }

  // UPDATE (toggle)
  void toggleAlert(int index, bool value) {
    final list = [...state];
    list[index].enabled = value;
    state = list;
  }

  // UPDATE (edit)
  void updateAlert(int index, WeatherAlert updated) {
    final list = [...state];
    list[index] = updated;
    state = list;
  }

  // DELETE
  void removeAlert(int index) {
    final list = [...state]..removeAt(index);
    state = list;
  }
}

class AlertHistoryNotifier extends StateNotifier<List<String>> {
  AlertHistoryNotifier()
      : super([
          '2 hours ago: Temperature exceeded 30°C in New York',
          'Yesterday 3:00 PM: Thunderstorm warning in London',
        ]);
}
