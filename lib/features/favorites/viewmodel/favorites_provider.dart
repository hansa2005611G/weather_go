import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/favorite_city.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteCity>>(
  (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<FavoriteCity>> {
  static const String _key = 'favorite_cities';

  FavoritesNotifier() : super([]) {
    // _loadFavorites();
    print('Loaded favorites: ${state.length}');
  }

  // LOAD from phone
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);
      state = decoded
          .map((e) => FavoriteCity.fromJson(e))
          .toList();
    }
  }

  // SAVE to phone
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  //  ADD
  void addCity(FavoriteCity city) {
    if (state.any((c) => c.name == city.name)) return;
    state = [...state, city];
    _saveFavorites();
  }

  //  UPDATE
  void updateCity(int index, FavoriteCity city) {
    final updated = [...state];
    updated[index] = city;
    state = updated;
    _saveFavorites();
  }

  //  DELETE
  void removeCity(FavoriteCity city) {
    state = state.where((c) => c.name != city.name).toList();
    _saveFavorites();
  }
}
