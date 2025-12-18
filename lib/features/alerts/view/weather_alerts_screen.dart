import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/alerts_provider.dart';
import '../model/weather_alert.dart';

class WeatherAlertsScreen extends ConsumerWidget {
  const WeatherAlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);
    final history = ref.watch(alertHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A90E2),
        child: const Icon(Icons.add_alert),
        onPressed: () => _showCreateAlertSheet(context, ref),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 🔔 ACTIVE ALERTS
          Text(
            'Active Alerts (${alerts.length})',
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...alerts.asMap().entries.map((entry) {
            final index = entry.key;
            final alert = entry.value;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  _iconForType(alert.type),
                  color: _colorForType(alert.type),
                ),
                title: Text(
                  '${_typeText(alert.type)} Alert',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${alert.city}\n${alert.condition}',
                ),
                isThreeLine: true,
                trailing: Column(
                  children: [
                    Switch(
                      value: alert.enabled,
                      onChanged: (val) {
                        ref
                            .read(alertsProvider.notifier)
                            .toggleAlert(index, val);
                      },
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'delete') {
                          ref
                              .read(alertsProvider.notifier)
                              .removeAlert(index);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          /// 🕘 HISTORY
          const Text(
            'Recent Notifications',
            style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...history.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(item),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── CREATE ALERT BOTTOM SHEET ─────────

  void _showCreateAlertSheet(BuildContext context, WidgetRef ref) {
    String city = 'New York';
    AlertType type = AlertType.temperature;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Create Weather Alert',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              /// CITY
              DropdownButtonFormField<String>(
                value: city,
                items: const [
                  DropdownMenuItem(value: 'New York', child: Text('New York')),
                  DropdownMenuItem(value: 'London', child: Text('London')),
                  DropdownMenuItem(value: 'Colombo', child: Text('Colombo')),
                ],
                onChanged: (value) => city = value!,
                decoration:
                    const InputDecoration(labelText: 'Select City'),
              ),

              const SizedBox(height: 12),

              /// TYPE
              Wrap(
                spacing: 8,
                children: AlertType.values.map((t) {
                  return ChoiceChip(
                    label: Text(_typeText(t)),
                    selected: type == t,
                    onSelected: (_) => type = t,
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              /// ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(alertsProvider.notifier).addAlert(
                            WeatherAlert(
                              city: city,
                              type: type,
                              condition:
                                  'Condition set for ${_typeText(type)}',
                            ),
                          );
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── HELPERS ─────────

  static IconData _iconForType(AlertType type) {
    switch (type) {
      case AlertType.rain:
        return Icons.cloud;
      case AlertType.wind:
        return Icons.air;
      case AlertType.temperature:
      default:
        return Icons.thermostat;
    }
  }

  static Color _colorForType(AlertType type) {
    switch (type) {
      case AlertType.rain:
        return Colors.blue;
      case AlertType.wind:
        return Colors.green;
      case AlertType.temperature:
      default:
        return Colors.orange;
    }
  }

  static String _typeText(AlertType type) {
    switch (type) {
      case AlertType.rain:
        return 'Rain';
      case AlertType.wind:
        return 'Wind';
      case AlertType.temperature:
      default:
        return 'Temperature';
    }
  }
}
