import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/coming_soon/domain/repositories/coming_soon_repository.dart';
import 'package:mdiscover/features/coming_soon/data/datasources/coming_soon_remote_datasource.dart';

class ComingSoonRepositoryImpl implements ComingSoonRepository {
  final ComingSoonRemoteDataSource remoteDataSource;

  ComingSoonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<MovieEntity>>> getUpcomingMovies({int page = 1}) async {
    try {
      final models = await remoteDataSource.getUpcomingMovies(page: page);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }
}
