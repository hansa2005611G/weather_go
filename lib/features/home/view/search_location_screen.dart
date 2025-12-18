import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodel/home_viewmodel.dart';

class SearchLocationScreen extends ConsumerStatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  ConsumerState<SearchLocationScreen> createState() =>
      _SearchLocationScreenState();
}

class _SearchLocationScreenState
    extends ConsumerState<SearchLocationScreen> {
  final TextEditingController _controller =
      TextEditingController();

  final List<String> popularCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Matara',
    'Kurunegala',
    'Anuradhapura',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SEARCH FIELD (THEME SAFE)
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search city...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                _searchCity(context, value);
              },
            ),

            const SizedBox(height: 24),

            // RECENT SEARCHES (OPTIONAL UI)
            Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Colombo'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Kandy'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Galle'),
            ),

            const SizedBox(height: 24),

            // POPULAR CITIES
            Text(
              'Popular Cities',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: popularCities.map((city) {
                return ChoiceChip(
                  label: Text(city),
                  selected: false,
                  onSelected: (_) {
                    _searchCity(context, city);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _searchCity(BuildContext context, String city) {
    if (city.trim().isEmpty) return;

    ref
        .read(homeProvider.notifier)
        .loadByCity(city.trim());

    Navigator.pop(context);
  }
}
