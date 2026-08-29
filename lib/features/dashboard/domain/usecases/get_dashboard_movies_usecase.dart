import '../../../../core/network/error_handler.dart';
import '../entities/movie_entity.dart';
import '../repositories/dashboard_repository.dart';

class DashboardData {
  final List<MovieEntity> previews;
  final List<MovieEntity> continueWatching;
  final List<MovieEntity> popular;
  final List<MovieEntity> trending;
  final List<MovieEntity> top10;
  final List<MovieEntity> myList;
  final List<MovieEntity> africanMovies;
  final List<MovieEntity> nollywood;
  final List<MovieEntity> netflixOriginals;
  final List<MovieEntity> watchItAgain;
  final List<MovieEntity> newReleases;
  final List<MovieEntity> tvThrillers;
  final List<MovieEntity> usTvShows;

  const DashboardData({
    required this.previews,
    required this.continueWatching,
    required this.popular,
    required this.trending,
    required this.top10,
    required this.myList,
    required this.africanMovies,
    required this.nollywood,
    required this.netflixOriginals,
    required this.watchItAgain,
    required this.newReleases,
    required this.tvThrillers,
    required this.usTvShows,
  });
}

class GetDashboardMoviesUseCase {
  final DashboardRepository repository;

  GetDashboardMoviesUseCase({required this.repository});

  Future<DataState<DashboardData>> execute() async {
    try {
      final results = await Future.wait([
        repository.getTrendingMovies(page: 1),       // [0]
        repository.getPopularMovies(page: 1),        // [1]
        repository.getNowPlayingMovies(page: 1),     // [2]
        repository.getTopRatedMovies(page: 1),       // [3]
        repository.getUpcomingMovies(page: 1),       // [4]
        repository.getPopularMovies(page: 2),        // [5]
        repository.getTopRatedMovies(page: 2),       // [6]
        repository.getUpcomingMovies(page: 2),       // [7]
        repository.getNowPlayingMovies(page: 2),     // [8]
        repository.getTrendingMovies(page: 2),       // [9]
        repository.getPopularMovies(page: 3),        // [10]
        repository.getTopRatedMovies(page: 3),       // [11]
      ]);

      final trending1 = results[0].data ?? [];
      final popular1 = results[1].data ?? [];
      final nowPlaying1 = results[2].data ?? [];
      final topRated1 = results[3].data ?? [];
      final upcoming1 = results[4].data ?? [];
      final popular2 = results[5].data ?? [];
      final topRated2 = results[6].data ?? [];
      final upcoming2 = results[7].data ?? [];
      final nowPlaying2 = results[8].data ?? [];
      final trending2 = results[9].data ?? [];
      final popular3 = results[10].data ?? [];
      final topRated3 = results[11].data ?? [];

      return DataSuccess(
        DashboardData(
          previews: trending1.take(6).toList(),
          continueWatching: nowPlaying1.take(4).toList(),
          popular: popular1,
          trending: trending1,
          top10: topRated1.take(10).toList(),
          myList: upcoming1,
          africanMovies: popular2,
          nollywood: topRated2,
          netflixOriginals: upcoming2,
          watchItAgain: nowPlaying2,
          newReleases: trending2,
          tvThrillers: popular3,
          usTvShows: topRated3,
        ),
      );
    } catch (e) {
      return DataFailed(NetworkException('Failed to load dashboard data: ${e.toString()}'));
    }
  }
}
