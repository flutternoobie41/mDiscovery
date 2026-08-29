import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetTrendingMoviesUseCase {
  final DashboardRepository repository;

  GetTrendingMoviesUseCase({required this.repository});

  Future<DataState<List<MovieEntity>>> execute({int page = 1}) {
    return repository.getTrendingMovies(page: page);
  }
}
