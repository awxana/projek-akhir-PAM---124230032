import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteTiers {
  static final FavoriteTiers _instance = FavoriteTiers._internal();
  factory FavoriteTiers() => _instance;
  FavoriteTiers._internal();

  static const String _favoritesKey = 'favoriteTiers';
  List<dynamic> _favoriteTiers = [];
  bool _isInitialized = false;

  Future<void> _init() async {
    if (!_isInitialized) {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString(_favoritesKey);
      if (favoritesJson != null) {
        _favoriteTiers = json.decode(favoritesJson);
      }
      _isInitialized = true;
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String favoritesJson = json.encode(_favoriteTiers);
    await prefs.setString(_favoritesKey, favoritesJson);
  }

  Future<void> addToFavorites(dynamic tier) async {
    await _init();
    // Gunakan tierName sebagai identifier unik
    if (!_favoriteTiers
        .any((favTier) => favTier['tierName'] == tier['tierName'])) {
      _favoriteTiers.add(tier);
      await _saveFavorites();
    }
  }

  Future<void> removeFromFavorites(dynamic tier) async {
    await _init();
    _favoriteTiers
        .removeWhere((favTier) => favTier['tierName'] == tier['tierName']);
    await _saveFavorites();
  }

  Future<bool> isFavorite(dynamic tier) async {
    await _init();
    return _favoriteTiers
        .any((favTier) => favTier['tierName'] == tier['tierName']);
  }

  Future<List<dynamic>> getFavorites() async {
    await _init();
    return List.from(_favoriteTiers);
  }
}
