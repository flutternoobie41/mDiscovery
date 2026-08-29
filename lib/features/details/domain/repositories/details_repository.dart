import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';

abstract class DetailsRepository {
  Future<DataState<MovieEntity>> getMovieDetails(int movieId);
  Future<DataState<List<MovieEntity>>> getSimilarMovies(int movieId);
}
