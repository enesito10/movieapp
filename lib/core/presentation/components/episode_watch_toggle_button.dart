import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EpisodeWatchToggleButton extends StatefulWidget {
  final String episodeId;

  const EpisodeWatchToggleButton({required this.episodeId, super.key});

  @override
  State<EpisodeWatchToggleButton> createState() => _EpisodeWatchToggleButtonState();
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
    final watchedEpisodes = prefs.getStringList('watched_episodes') ?? [];
    setState(() {
      isWatched = watchedEpisodes.contains(widget.episodeId);
    });
  }

  Future<void> _toggleWatch() async {
    final prefs = await SharedPreferences.getInstance();
    final watchedEpisodes = prefs.getStringList('watched_episodes') ?? [];

    setState(() {
      if (watchedEpisodes.contains(widget.episodeId)) {
        watchedEpisodes.remove(widget.episodeId);
        isWatched = false;
      } else {
        watchedEpisodes.add(widget.episodeId);
        isWatched = true;
      }
    });

    await prefs.setStringList('watched_episodes', watchedEpisodes);

    // Ekrana bildirim
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isWatched ? 'İzlendi olarak işaretlendi' : 'İzlenmedi olarak işaretlendi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            isWatched ? Icons.check_circle : Icons.add_circle_outline,
            color: isWatched ? Colors.green : Colors.grey,
          ),
          onPressed: _toggleWatch,
        ),
        Text(
          isWatched ? "İzlendi" : "İzlenmedi",
          style: Theme.of(context).textTheme.labelSmall,
        )
      ],
    );
  }
}
