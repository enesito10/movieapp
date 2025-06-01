class EpisodeSelection {
  final String id; // örn: "s1e3"
  final String name;
  final int season;
  final int episode;
  final String airDate;

  EpisodeSelection({
    required this.id,
    required this.name,
    required this.season,
    required this.episode,
    required this.airDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'season': season,
    'episode': episode,
    'airDate': airDate,
  };

  factory EpisodeSelection.fromJson(Map<String, dynamic> json) {
    return EpisodeSelection(
      id: json['id'],
      name: json['name'],
      season: json['season'],
      episode: json['episode'],
      airDate: json['airDate'],
    );
  }
}
