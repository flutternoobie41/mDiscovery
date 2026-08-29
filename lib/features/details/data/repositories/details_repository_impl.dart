import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/details/domain/repositories/details_repository.dart';
import 'package:mdiscover/features/details/data/datasources/details_remote_datasource.dart';

class DetailsRepositoryImpl implements DetailsRepository {
  final DetailsRemoteDataSource remoteDataSource;

  DetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<MovieEntity>> getMovieDetails(int movieId) async {
    try {
      final model = await remoteDataSource.getMovieDetails(movieId);
      return DataSuccess(model);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getSimilarMovies(int movieId) async {
    try {
      final models = await remoteDataSource.getSimilarMovies(movieId);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }
}
