import '../../../../core/network/error_handler.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DataState<List<MovieEntity>>> getTrendingMovies() async {
    try {
      final models = await remoteDataSource.getTrendingMovies();
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getPopularMovies() async {
    try {
      final models = await remoteDataSource.getPopularMovies();
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getNowPlayingMovies() async {
    try {
      final models = await remoteDataSource.getNowPlayingMovies();
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }

  @override
  Future<DataState<List<MovieEntity>>> getTopRatedMovies() async {
    try {
      final models = await remoteDataSource.getTopRatedMovies();
      return DataSuccess(models);
    } catch (e) {
      return DataFailed(NetworkException(e.toString()));
    }
  }
}
