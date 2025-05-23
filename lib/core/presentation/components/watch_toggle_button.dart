import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WatchToggleButton extends StatefulWidget {
  final String movieId;

  const WatchToggleButton({required this.movieId, super.key});

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

    setState(() {
      if (watchedMovies.contains(widget.movieId)) {
        watchedMovies.remove(widget.movieId);
        isWatched = false;
      } else {
        watchedMovies.add(widget.movieId);
        isWatched = true;
      }
    });

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
