import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TemperatureUnit { celsius, fahrenheit }

class SettingsState {
  final TemperatureUnit tempUnit;
  final bool darkMode;

  SettingsState({
    required this.tempUnit,
    required this.darkMode,
  });

  SettingsState copyWith({
    TemperatureUnit? tempUnit,
    bool? darkMode,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(
          SettingsState(
            tempUnit: TemperatureUnit.celsius,
            darkMode: false,
          ),
        );

  void toggleTempUnit(TemperatureUnit unit) {
    state = state.copyWith(tempUnit: unit);
  }

  void toggleDarkMode(bool value) {
    state = state.copyWith(darkMode: value);
  }
}
