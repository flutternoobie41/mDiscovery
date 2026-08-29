import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/coming_soon/domain/repositories/coming_soon_repository.dart';

class GetUpcomingMoviesUseCase {
  final ComingSoonRepository repository;

  GetUpcomingMoviesUseCase({required this.repository});

  Future<DataState<List<MovieEntity>>> execute({int page = 1}) {
    return repository.getUpcomingMovies(page: page);
  }
}
