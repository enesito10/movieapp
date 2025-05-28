class MovieSelection {
  final String id; // API'deki film ID'si
  final String title;
  final List<String> genres;
  final double voteAverage;

  MovieSelection({
    required this.id,
    required this.title,
    required this.genres,
    required this.voteAverage,
  });

  // SharedPreferences için JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genres': genres,
      'voteAverage': voteAverage,
    };
  }

  // SharedPreferences'tan geri alma
  factory MovieSelection.fromJson(Map<String, dynamic> json) {
    return MovieSelection(
      id: json['id'],
      title: json['title'],
      genres: List<String>.from(json['genres']),
      voteAverage: (json['voteAverage'] as num).toDouble(),
    );
  }
}


//final genres = allSelectedMovies.expand((e) => e.genres).toSet().toList();
// final titles = allSelectedMovies.map((e) => e.title).toList();
//
// final prompt = '''
// Kullanıcı daha önce şu türlerde filmler izledi: ${genres.join(', ')}.
// İzlediği bazı filmler şunlar: ${titles.join(', ')}.
//
// Lütfen bundan sonra "film öner" dendiğinde, bu zevklere benzer filmler öner.
// Kullanıcıya ne tür sevdiğini sorma.
// ''';