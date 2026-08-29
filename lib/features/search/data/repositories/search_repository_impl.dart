import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/search/domain/repositories/search_repository.dart';
import 'package:mdiscover/features/search/data/datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<MovieEntity>>> searchMovies(String query, {int page = 1}) async {
    try {
      final models = await remoteDataSource.searchMovies(query, page: page);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }
}
