import 'package:equatable/equatable.dart';
import 'package:movies_app/tv_shows/domain/entities/episode.dart';

class SeasonDetails extends Equatable {
  const SeasonDetails({
    required this.episodes,
    required this.seriesTitle,
  });

  final List<Episode> episodes;
  final String seriesTitle;

  @override
  List<Object?> get props => [
        episodes,
      ];
}
