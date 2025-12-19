import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:weather_go/features/favorites/view/favorites_screen.dart';
import 'package:weather_go/features/home/view/detailed_forecast_screen.dart';
import 'package:weather_go/features/home/view/search_location_screen.dart';
import 'package:weather_go/features/alerts/view/weather_alerts_screen.dart';
import 'package:weather_go/features/settings/view/settings_screen.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/temperature_utils.dart';

import '../viewmodel/home_viewmodel.dart';
import '../../favorites/viewmodel/favorites_provider.dart';
import '../../favorites/model/favorite_city.dart';
import '../../settings/viewmodel/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeProvider);
    final settings = ref.watch(settingsProvider);

    return state.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text(e.toString())),
      ),
      data: (data) {
        final weather = data.weather;

        // 🌡 Temperature handling
        final unitSymbol =
            settings.tempUnit == TemperatureUnit.celsius
                ? '°C'
                : '°F';

        double convert(double c) =>
            settings.tempUnit == TemperatureUnit.celsius
                ? c
                : toFahrenheit(c);

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientEnd,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(homeProvider.notifier)
                      .loadByCity(weather.city);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weather updated'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🔝 TOP BAR
                      ListTile(
                        leading: IconButton(
                          icon: const Icon(Icons.search,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SearchLocationScreen(),
                              ),
                            );
                          },
                        ),

                        title: Text(
                          weather.city,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // ⭐ Favorite
                            IconButton(
                              icon: const Icon(Icons.star_border,
                                  color: Colors.white),
                              onPressed: () {
                                ref
                                    .read(favoritesProvider.notifier)
                                    .addCity(
                                      FavoriteCity(
                                        name: weather.city,
                                        temp: weather.temp,
                                        condition:
                                            weather.condition,
                                      ),
                                    );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${weather.city} added to favorites'),
                                    duration:
                                        const Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const FavoritesScreen(),
                                  ),
                                );
                              },
                            ),

                            // 🔔 Alerts
                            IconButton(
                              icon: const Icon(Icons.notifications,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const WeatherAlertsScreen(),
                                  ),
                                );
                              },
                            ),

                            // ⚙️ Settings
                            IconButton(
                              icon: const Icon(Icons.settings,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      /// 🌡 HERO SECTION
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          '${convert(weather.temp).toStringAsFixed(1)}$unitSymbol',
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          weather.condition,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      /// 🕒 HOURLY FORECAST
                      _sectionTitle('Hourly Forecast'),
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.hourly.length,
                          itemBuilder: (context, index) {
                            final hour = data.hourly[index];
                            final time =
                                DateTime.fromMillisecondsSinceEpoch(
                                    hour.dt * 1000);

                            return _hourlyCard(
                              time.hour,
                              convert(hour.temp),
                              unitSymbol,
                              hour.icon,
                            );
                          },
                        ),
                      ),

                      /// 📅 7-DAY FORECAST
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailedForecastScreen(
                                city: weather.city,
                                hourly: data.hourly,
                                daily: data.daily,
                              ),
                            ),
                          );
                        },
                        child: _sectionTitle(
                            '7-Day Forecast (Tap for details)'),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: data.daily.length,
                        itemBuilder: (context, index) {
                          final day = data.daily[index];
                          final date =
                              DateTime.fromMillisecondsSinceEpoch(
                                  day.dt * 1000);

                          return _dailyCard(
                            date,
                            convert(day.max),
                            convert(day.min),
                            unitSymbol,
                            day.icon,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────── HELPERS ─────────

  static Widget _sectionTitle(String title) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _hourlyCard(
      int hour, double temp, String unit, String iconCode) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$hour:00',
                style:
                    const TextStyle(fontWeight: FontWeight.bold)),
            Image.network(
              weatherIconUrl(iconCode),
              width: 40,
              height: 40,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.cloud, size: 32),
            ),
            Text('${temp.toStringAsFixed(1)}$unit'),
          ],
        ),
      ),
    );
  }

  static Widget _dailyCard(
      DateTime date,
      double max,
      double min,
      String unit,
      String iconCode) {
    return Card(
      elevation: 4,
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Image.network(
          weatherIconUrl(iconCode),
          width: 40,
          height: 40,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.cloud, color: Colors.grey),
        ),
        title: Text(
          _weekday(date.weekday),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '${max.toStringAsFixed(1)}$unit / ${min.toStringAsFixed(1)}$unit',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  static String _weekday(int day) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    return days[day - 1];
  }
}

/// 🌦 OpenWeather icon helper
String weatherIconUrl(String iconCode) {
  return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
