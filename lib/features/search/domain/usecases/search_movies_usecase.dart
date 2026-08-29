import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/search/domain/repositories/search_repository.dart';

class SearchMoviesUseCase {
  final SearchRepository repository;

  SearchMoviesUseCase({required this.repository});

  Future<DataState<List<MovieEntity>>> execute(String query, {int page = 1}) {
    return repository.searchMovies(query, page: page);
  }
}
