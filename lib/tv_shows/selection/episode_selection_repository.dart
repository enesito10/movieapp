import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'episode_selection.dart';

class EpisodeSelectionRepository {
  static const String _key = 'selected_episodes';

  Future<List<EpisodeSelection>> getSelectedEpisodes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List decoded = json.decode(jsonString);
    return decoded.map((e) => EpisodeSelection.fromJson(e)).toList();
  }

  Future<void> addEpisode(EpisodeSelection episode) async {
    final episodes = await getSelectedEpisodes();
    final updated = [...episodes.where((e) => e.id != episode.id), episode];
    await _saveEpisodes(updated);
  }

  Future<void> removeEpisode(String id) async {
    final episodes = await getSelectedEpisodes();
    final updated = episodes.where((e) => e.id != id).toList();
    await _saveEpisodes(updated);
  }

  Future<void> _saveEpisodes(List<EpisodeSelection> episodes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
    json.encode(episodes.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<bool> isSelected(String id) async {
    final episodes = await getSelectedEpisodes();
    return episodes.any((e) => e.id == id);
  }
}
