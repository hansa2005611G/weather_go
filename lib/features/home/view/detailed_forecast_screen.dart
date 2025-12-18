import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../data/models/forecast_model.dart';

class DetailedForecastScreen extends StatefulWidget {
  final String city;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;

  const DetailedForecastScreen({
    super.key,
    required this.city,
    required this.hourly,
    required this.daily,
  });

  @override
  State<DetailedForecastScreen> createState() =>
      _DetailedForecastScreenState();
}

class _DetailedForecastScreenState
    extends State<DetailedForecastScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Week'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _todayView(),
          _weekView(),
        ],
      ),
    );
  }

  // ───────────── TODAY TAB ─────────────

  Widget _todayView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _temperatureChart(widget.hourly),

          const SizedBox(height: 16),

          const Text(
            'Hourly Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          ...widget.hourly.map(_hourlyExpansionCard),
        ],
      ),
    );
  }

  // ───────────── WEEK TAB ─────────────

  Widget _weekView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.daily.length,
      itemBuilder: (context, index) {
        final day = widget.daily[index];
        final date = DateTime.fromMillisecondsSinceEpoch(day.dt * 1000);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _weekday(date.weekday),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _dailySummaryCard(day),
            ],
          ),
        );
      },
    );
  }

  // ───────────── CHART ─────────────

  Widget _temperatureChart(List<HourlyForecast> data) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
              ),
              barWidth: 3,
              dotData: FlDotData(show: false),
              spots: List.generate(
                data.length,
                (i) => FlSpot(
                  i.toDouble(),
                  data[i].temp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────── HOURLY CARD ─────────────

  Widget _hourlyExpansionCard(HourlyForecast hour) {
    final time =
        DateTime.fromMillisecondsSinceEpoch(hour.dt * 1000);

    return Card(
      elevation: 3,
      child: ExpansionTile(
        leading: Image.network(
          _iconUrl(hour.icon),
          width: 32,
          height: 32,
        ),
        title: Text(
          '${_time(time)} • ${hour.temp.toStringAsFixed(1)}°C',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: const [
          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text('Humidity information available'),
          ),
          ListTile(
            leading: Icon(Icons.air),
            title: Text('Wind information available'),
          ),
        ],
      ),
    );
  }

  // ───────────── DAILY CARD ─────────────

  Widget _dailySummaryCard(DailyForecast day) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Image.network(
          _iconUrl(day.icon),
          width: 40,
          height: 40,
        ),
        title: Text(
          'Max ${day.max.toStringAsFixed(1)}°C',
        ),
        subtitle: Text(
          'Min ${day.min.toStringAsFixed(1)}°C',
        ),
      ),
    );
  }

  // ───────────── HELPERS ─────────────

  String _iconUrl(String code) =>
      'https://openweathermap.org/img/wn/$code@2x.png';

  String _weekday(int day) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];

  String _time(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:00';
}
