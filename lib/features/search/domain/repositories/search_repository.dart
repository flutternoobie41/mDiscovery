import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';

abstract class SearchRepository {
  Future<DataState<List<MovieEntity>>> searchMovies(String query, {int page = 1});
}
