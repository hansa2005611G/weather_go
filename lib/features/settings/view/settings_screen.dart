import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ───────── GENERAL ─────────
          _sectionTitle('GENERAL'),

          Card(
            child: ListTile(
              title: const Text('Temperature Unit'),
              subtitle: const Text('Select temperature unit'),
              trailing: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('°C'),
                    selected: settings.tempUnit ==
                        TemperatureUnit.celsius,
                    onSelected: (_) {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleTempUnit(
                              TemperatureUnit.celsius);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('°F'),
                    selected: settings.tempUnit ==
                        TemperatureUnit.fahrenheit,
                    onSelected: (_) {
                      ref
                          .read(settingsProvider.notifier)
                          .toggleTempUnit(
                              TemperatureUnit.fahrenheit);
                    },
                  ),
                ],
              ),
            ),
          ),

          Card(
            child: SwitchListTile(
              title: const Text('Dark Theme'),
              subtitle: const Text('Enable dark mode'),
              value: settings.darkMode,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .toggleDarkMode(value);
              },
            ),
          ),

          const SizedBox(height: 24),

          // ───────── ABOUT ─────────
          _sectionTitle('ABOUT'),

          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              trailing: const Text('1.0.0'),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: const Text('Weather API'),
              subtitle: const Text('OpenWeatherMap'),
            ),
          ),
        ],
      ),
    );
  }

  // ───────── Helper ─────────
  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
