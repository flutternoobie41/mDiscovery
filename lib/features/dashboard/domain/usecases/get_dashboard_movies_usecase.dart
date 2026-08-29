import '../../../../core/network/error_handler.dart';
import '../entities/movie_entity.dart';
import '../repositories/dashboard_repository.dart';

class DashboardData {
  final List<MovieEntity> trending;
  final List<MovieEntity> popular;
  final List<MovieEntity> nowPlaying;
  final List<MovieEntity> topRated;

  const DashboardData({
    required this.trending,
    required this.popular,
    required this.nowPlaying,
    required this.topRated,
  });
}

class GetDashboardMoviesUseCase {
  final DashboardRepository repository;

  GetDashboardMoviesUseCase({required this.repository});

  Future<DataState<DashboardData>> execute() async {
    try {
      final results = await Future.wait([
        repository.getTrendingMovies(),
        repository.getPopularMovies(),
        repository.getNowPlayingMovies(),
        repository.getTopRatedMovies(),
      ]);

      final trending = results[0].data ?? [];
      final popular = results[1].data ?? [];
      final nowPlaying = results[2].data ?? [];
      final topRated = results[3].data ?? [];

      return DataSuccess(
        DashboardData(
          trending: trending,
          popular: popular,
          nowPlaying: nowPlaying,
          topRated: topRated,
        ),
      );
    } catch (e) {
      return DataFailed(NetworkException('Failed to load dashboard data: ${e.toString()}'));
    }
  }
}
