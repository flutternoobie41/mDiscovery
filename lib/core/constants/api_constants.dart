/// Centralized API Constants for TheMovieDB (TMDB).
class ApiConstants {
  ApiConstants._();

  /// Base URL for TMDB API v3
  static const String baseUrl = 'https://api.themoviedb.org/3';

  /// TMDB API Key passed via `--dart-define=TMDB_API_KEY=...` or gitignored configuration.
  static String apiKey = const String.fromEnvironment(
    'TMDB_API_KEY',
  );

  /// TMDB Image Base URLs
  static const String imageBaseUrlW500 = 'https://image.tmdb.org/t/p/w500';
  static const String imageBaseUrlOriginal = 'https://image.tmdb.org/t/p/original';

  /// Endpoints
  static const String trendingWeek = '/trending/movie/week';
  static const String popularMovies = '/movie/popular';
  static const String nowPlayingMovies = '/movie/now_playing';
  static const String topRatedMovies = '/movie/top_rated';
  static const String upcomingMovies = '/movie/upcoming';
  static const String searchMovies = '/search/movie';
  static const String movieDetails = '/movie';

  /// Helper to generate full poster image URL
  static String getPosterUrl(String? posterPath) {
    if (posterPath == null || posterPath.isEmpty) {
      return 'https://via.placeholder.com/500x750/1C202C/FFFFFF?text=No+Image';
    }
    if (posterPath.startsWith('http')) return posterPath;
    return '$imageBaseUrlW500$posterPath';
  }

  /// Helper to generate full backdrop image URL
  static String getBackdropUrl(String? backdropPath) {
    if (backdropPath == null || backdropPath.isEmpty) {
      return 'https://via.placeholder.com/1280x720/1C202C/FFFFFF?text=No+Backdrop';
    }
    if (backdropPath.startsWith('http')) return backdropPath;
    return '$imageBaseUrlOriginal$backdropPath';
  }
}
