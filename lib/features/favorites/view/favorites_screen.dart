import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/favorite_city.dart';
import '../viewmodel/favorites_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends ConsumerState<FavoritesScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);

    final filtered = favorites
        .where((c) =>
            c.name.toLowerCase().contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),

      body: Column(
        children: [

          // 🔍 SEARCH
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search favorite city...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // LIST
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No favorite cities'),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final city = filtered[index];

                      return ListTile(
                        leading:
                            const Icon(Icons.location_city),
                        title: Text(city.name),
                        subtitle: Text(
                            '${city.temp.toStringAsFixed(1)}° • ${city.condition}'),

                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _editCityDialog(
                                  context, index, city);
                            } else if (value == 'delete') {
                                ref.read(favoritesProvider.notifier).removeCity(city);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${city.name} removed from favorites'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),

                        // NAVIGATE BACK TO HOME
                        onTap: () {
                          Navigator.pop(context, city.name);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // EDIT DIALOG
  void _editCityDialog(
    BuildContext context,
    int index,
    FavoriteCity city,
  ) {
    final controller =
        TextEditingController(text: city.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit City'),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(hintText: 'City name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(favoritesProvider.notifier)
                  .updateCity(
                    index,
                    FavoriteCity(
                      name: controller.text,
                      temp: city.temp,
                      condition: city.condition,
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
