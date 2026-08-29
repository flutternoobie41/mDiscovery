import '../../domain/entities/movie_entity.dart';
import '../../../../core/constants/api_constants.dart';

/// Data model for Movie with TMDB JSON deserialization.
class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    super.genres,
    super.runtime,
    super.status,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    // Parse rating safely
    double parsedRating = 0.0;
    if (json['vote_average'] != null) {
      parsedRating = (json['vote_average'] as num).toDouble();
    }

    // Parse genre names if provided
    List<String> parsedGenres = [];
    if (json['genres'] != null && json['genres'] is List) {
      parsedGenres = (json['genres'] as List)
          .map((g) => (g is Map && g['name'] != null) ? g['name'].toString() : '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return MovieModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? json['name'] as String? ?? 'Untitled',
      overview: json['overview'] as String? ?? 'No overview available.',
      posterPath: ApiConstants.getPosterUrl(json['poster_path'] as String?),
      backdropPath: ApiConstants.getBackdropUrl(json['backdrop_path'] as String?),
      voteAverage: parsedRating,
      releaseDate: json['release_date'] as String? ?? json['first_air_date'] as String? ?? 'TBA',
      genres: parsedGenres,
      runtime: json['runtime'] as int?,
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genres': genres,
      'runtime': runtime,
      'status': status,
    };
  }
}
