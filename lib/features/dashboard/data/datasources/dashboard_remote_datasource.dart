import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/mock_data.dart';
import '../../../../core/network/dio_client.dart';
import '../models/movie_model.dart';

abstract class DashboardRemoteDataSource {
  Future<List<MovieModel>> getTrendingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getTopRatedMovies();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient dioClient;

  DashboardRemoteDataSourceImpl({required this.dioClient});

  Future<List<MovieModel>> _fetchMovieList(String path) async {
    try {
      final response = await dioClient.get(path);
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] as List? ?? [];
        return results
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return MockData.sampleMovies;
    } catch (_) {
      // Fallback to sample movies if API key limit or network fails
      return MockData.sampleMovies;
    }
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() => _fetchMovieList(ApiConstants.trendingWeek);

  @override
  Future<List<MovieModel>> getPopularMovies() => _fetchMovieList(ApiConstants.popularMovies);

  @override
  Future<List<MovieModel>> getNowPlayingMovies() => _fetchMovieList(ApiConstants.nowPlayingMovies);

  @override
  Future<List<MovieModel>> getTopRatedMovies() => _fetchMovieList(ApiConstants.topRatedMovies);
}
