import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'movie_selection.dart';

class MovieSelectionRepository {
  static const String _key = 'selected_movies';

  Future<List<MovieSelection>> getSelectedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List decoded = json.decode(jsonString);
    return decoded.map((e) => MovieSelection.fromJson(e)).toList();
  }

  Future<void> addMovie(MovieSelection movie) async {
    final movies = await getSelectedMovies();
    final updated = [...movies.where((m) => m.id != movie.id), movie];
    await _saveMovies(updated);
  }

  Future<void> removeMovie(String id) async {
    final movies = await getSelectedMovies();
    final updated = movies.where((m) => m.id != id).toList();
    await _saveMovies(updated);
  }

  Future<void> _saveMovies(List<MovieSelection> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
    json.encode(movies.map((m) => m.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<bool> isSelected(String id) async {
    final movies = await getSelectedMovies();
    return movies.any((m) => m.id == id);
  }
}
