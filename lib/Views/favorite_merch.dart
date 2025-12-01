import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMerch {
  static final FavoriteMerch _instance = FavoriteMerch._internal();
  factory FavoriteMerch() => _instance;
  FavoriteMerch._internal();

  static const String _favoritesKey = 'favoriteMerch';
  Set<String> _favoriteIds = {};
  bool _initialized = false;

  Future<void> _init() async {
    if (!_initialized) {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_favoritesKey);
      if (jsonStr != null) {
        final List<dynamic> list = json.decode(jsonStr);
        _favoriteIds = list.map((e) => e.toString()).toSet();
      }
      _initialized = true;
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(_favoriteIds.toList()));
  }

  Future<bool> isFavorite(String id) async {
    await _init();
    return _favoriteIds.contains(id);
  }

  Future<void> add(String id) async {
    await _init();
    _favoriteIds.add(id);
    await _save();
  }

  Future<void> remove(String id) async {
    await _init();
    _favoriteIds.remove(id);
    await _save();
  }

  Future<void> toggle(String id) async {
    await _init();
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await _save();
  }

  Future<List<String>> getFavorites() async {
    await _init();
    return List.from(_favoriteIds);
  }
}
