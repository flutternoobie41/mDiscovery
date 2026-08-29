import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';

abstract class ComingSoonRepository {
  Future<DataState<List<MovieEntity>>> getUpcomingMovies();
}
