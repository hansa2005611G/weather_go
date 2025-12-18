class HourlyForecast {
  final int dt;
  final double temp;
  final String icon;

  HourlyForecast({
    required this.dt,
    required this.temp,
    required this.icon,
  });
}

class DailyForecast {
  final int dt;
  final double min;
  final double max;
  final String icon;

  DailyForecast({
    required this.dt,
    required this.min,
    required this.max,
    required this.icon,
  });
}
