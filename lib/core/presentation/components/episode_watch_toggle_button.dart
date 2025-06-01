import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_app/tv_shows/selection/episode_selection.dart';
import 'package:movies_app/tv_shows/selection/episode_selection_repository.dart';

class EpisodeWatchToggleButton extends StatefulWidget {
  final String id;
  final String name;
  final int season;
  final int episode;
  final String airDate;

  const EpisodeWatchToggleButton({
    super.key,
    required this.id,
    required this.name,
    required this.season,
    required this.episode,
    required this.airDate,
  });

  @override
  State<EpisodeWatchToggleButton> createState() =>
      _EpisodeWatchToggleButtonState();
}

class _EpisodeWatchToggleButtonState extends State<EpisodeWatchToggleButton> {
  bool isWatched = false;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList('watched_episodes') ?? [];
    setState(() {
      isWatched = watched.contains(widget.id);
    });
  }

  Future<void> _toggleWatch() async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList('watched_episodes') ?? [];

    final repo = EpisodeSelectionRepository();

    if (watched.contains(widget.id)) {
      watched.remove(widget.id);
      await repo.removeEpisode(widget.id);
      isWatched = false;
    } else {
      watched.add(widget.id);
      final ep = EpisodeSelection(
        id: widget.id,
        name: widget.name,
        season: widget.season,
        episode: widget.episode,
        airDate: widget.airDate,
      );
      await repo.addEpisode(ep);
      isWatched = true;
    }

    await prefs.setStringList('watched_episodes', watched);
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isWatched
            ? 'Bölüm izlendi olarak işaretlendi'
            : 'İzlenmedi olarak işaretlendi'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isWatched ? Icons.check_circle : Icons.add_circle_outline,
        color: isWatched ? Colors.green : Colors.grey,
      ),
      onPressed: _toggleWatch,
    );
  }
}
