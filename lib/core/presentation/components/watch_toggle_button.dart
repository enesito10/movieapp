import 'package:flutter/material.dart';
import 'package:movies_app/movies/selection/movie_selection_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../movies/selection/movie_selection.dart';

class WatchToggleButton extends StatefulWidget {
  final String movieId;
  final String title;
  final List<String> genres;
  final double voteAverage;

  const WatchToggleButton({
    required this.movieId,
    required this.title,
    required this.genres,
    required this.voteAverage,
    super.key,
  });

  @override
  State<WatchToggleButton> createState() => _WatchToggleButtonState();
}

class _WatchToggleButtonState extends State<WatchToggleButton> {
  bool isWatched = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final watchedMovies = prefs.getStringList('watched_movies') ?? [];
    setState(() {
      isWatched = watchedMovies.contains(widget.movieId);
    });
  }

  Future<void> _toggleWatch() async {
    final prefs = await SharedPreferences.getInstance();
    final watchedMovies = prefs.getStringList('watched_movies') ?? [];

    final repo = MovieSelectionRepository();

    if (watchedMovies.contains(widget.movieId)) {
      watchedMovies.remove(widget.movieId);

      setState(() {
        isWatched = false;
      });

      await repo.removeMovie(widget.movieId);
    } else {
      watchedMovies.add(widget.movieId);

      setState(() {
        isWatched = true;
      });

      final movie = MovieSelection(
        id: widget.movieId,
        title: widget.title,
        genres: widget.genres,
        voteAverage: widget.voteAverage,
      );
      await repo.addMovie(movie);
    }

    await prefs.setStringList('watched_movies', watchedMovies);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isWatched ? 'İzlendi olarak işaretlendi' : 'İzlenmedi olarak işaretlendi',
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleWatch,
      child: Icon(
        isWatched ? Icons.check_circle : Icons.add_circle_outline,
        size: 20, // Bookmark ikonu ile birebir aynı boyut
        color: isWatched ? Colors.green : Colors.grey,
      ),
    );
  }
}
