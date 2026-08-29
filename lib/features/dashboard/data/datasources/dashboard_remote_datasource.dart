import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/mock_data.dart';
import '../../../../core/network/dio_client.dart';
import '../models/movie_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies({int page = 1});
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1});
  Future<List<MovieModel>> getTopRatedMovies({int page = 1});
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient dioClient;

  DashboardRemoteDataSourceImpl({required this.dioClient});

  Future<List<MovieModel>> _fetchMovieList(
    String path, {
    int page = 1,
    List<MovieModel>? fallback,
  }) async {
    try {
      final response = await dioClient.get(
        path,
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] as List? ?? [];
        return results
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return fallback ?? MockData.sampleMovies;
    } catch (_) {
      // Fallback to sample movies if API key limit or network fails
      return fallback ?? MockData.sampleMovies;
    }
  }

  @override
  Future<List<MovieModel>> getTrendingMovies({int page = 1}) =>
      _fetchMovieList(ApiConstants.trendingWeek, page: page);

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) =>
      _fetchMovieList(ApiConstants.popularMovies, page: page);

  @override
  Future<List<MovieModel>> getNowPlayingMovies({int page = 1}) =>
      _fetchMovieList(ApiConstants.nowPlayingMovies, page: page);

  @override
  Future<List<MovieModel>> getTopRatedMovies({int page = 1}) =>
      _fetchMovieList(ApiConstants.topRatedMovies, page: page);

  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) =>
      _fetchMovieList(
        ApiConstants.upcomingMovies,
        page: page,
        fallback: MockData.upcomingMovies,
      );
}
