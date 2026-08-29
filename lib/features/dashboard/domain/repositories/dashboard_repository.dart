import '../../../../core/network/error_handler.dart';
import '../entities/movie_entity.dart';

abstract class DashboardRepository {
  Future<DataState<List<MovieEntity>>> getTrendingMovies();
  Future<DataState<List<MovieEntity>>> getPopularMovies();
  Future<DataState<List<MovieEntity>>> getNowPlayingMovies();
  Future<DataState<List<MovieEntity>>> getTopRatedMovies();
}
