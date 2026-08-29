import '../../../../core/network/error_handler.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<MovieEntity>>> getTrendingMovies({int page = 1}) async {
    try {
      final models = await remoteDataSource.getTrendingMovies(page: page);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getPopularMovies({int page = 1}) async {
    try {
      final models = await remoteDataSource.getPopularMovies(page: page);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getNowPlayingMovies({int page = 1}) async {
    try {
      final models = await remoteDataSource.getNowPlayingMovies(page: page);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getTopRatedMovies({int page = 1}) async {
    try {
      final models = await remoteDataSource.getTopRatedMovies(page: page);
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

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
