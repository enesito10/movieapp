import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/entities/media_details.dart';
import 'package:movies_app/core/presentation/components/circle_dot.dart';
import '../../../core/presentation/components/watch_toggle_button.dart';

class MovieCardDetails extends StatelessWidget {
  const MovieCardDetails({
    super.key,
    required this.movieDetails,
  });

  final MediaDetails movieDetails;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (movieDetails.releaseDate.isNotEmpty &&
        movieDetails.genres.isNotEmpty &&
        movieDetails.runtime!.isNotEmpty) {
      return Row(
        children: [
          if (movieDetails.releaseDate.isNotEmpty) ...[
            Text(
              movieDetails.releaseDate.split(',')[1],
              style: textTheme.bodyLarge,
            ),
            const CircleDot(),
          ],
          if (movieDetails.genres.isNotEmpty) ...[
            Text(
              movieDetails.genres,
              style: textTheme.bodyLarge,
            ),
            const CircleDot(),
          ] else ...[
            if (movieDetails.runtime!.isNotEmpty) ...[
              const CircleDot(),
            ]
          ],
          Text(
            movieDetails.runtime!,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          WatchToggleButton(movieId: movieDetails.tmdbID.toString()),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
