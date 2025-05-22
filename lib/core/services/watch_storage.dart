import 'package:shared_preferences/shared_preferences.dart';

class WatchStorage {
  static const _watchedMoviesKey = 'watched_movies';
  static const _watchedEpisodesKey = 'watched_episodes';

  static Future<Set<String>> _getStringSet(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key)?.toSet() ?? {};
  }

  static Future<void> _saveStringSet(String key, Set<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, values.toList());
  }

  // MOVIE METHODS
  static Future<bool> isMovieWatched(String movieId) async {
    final movies = await _getStringSet(_watchedMoviesKey);
    return movies.contains(movieId);
  }

  static Future<void> toggleMovieWatched(String movieId) async {
    final movies = await _getStringSet(_watchedMoviesKey);
    if (movies.contains(movieId)) {
      movies.remove(movieId);
    } else {
      movies.add(movieId);
    }
    await _saveStringSet(_watchedMoviesKey, movies);
  }

  // EPISODE METHODS
  static Future<bool> isEpisodeWatched(String episodeId) async {
    final episodes = await _getStringSet(_watchedEpisodesKey);
    return episodes.contains(episodeId);
  }

  static Future<void> toggleEpisodeWatched(String episodeId) async {
    final episodes = await _getStringSet(_watchedEpisodesKey);
    if (episodes.contains(episodeId)) {
      episodes.remove(episodeId);
    } else {
      episodes.add(episodeId);
    }
    await _saveStringSet(_watchedEpisodesKey, episodes);
  }
}
