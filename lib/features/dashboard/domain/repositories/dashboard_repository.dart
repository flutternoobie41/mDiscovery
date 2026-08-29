import '../../../../core/network/error_handler.dart';
import '../entities/movie_entity.dart';

abstract class DashboardRepository {
  Future<DataState<List<MovieEntity>>> getTrendingMovies({int page = 1});
  Future<DataState<List<MovieEntity>>> getPopularMovies({int page = 1});
  Future<DataState<List<MovieEntity>>> getNowPlayingMovies({int page = 1});
  Future<DataState<List<MovieEntity>>> getTopRatedMovies({int page = 1});
  Future<DataState<List<MovieEntity>>> getUpcomingMovies({int page = 1});
}
