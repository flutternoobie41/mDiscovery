import 'package:mdiscover/core/constants/api_constants.dart';
import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/network/dio_client.dart';
import 'package:mdiscover/features/dashboard/data/models/movie_model.dart';

abstract class DetailsRemoteDataSource {
  Future<MovieModel> getMovieDetails(int movieId);
  Future<List<MovieModel>> getSimilarMovies(int movieId);
}

class DetailsRemoteDataSourceImpl implements DetailsRemoteDataSource {
  final DioClient dioClient;

  DetailsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      final response = await dioClient.get('${ApiConstants.movieDetails}/$movieId');
      if (response.statusCode == 200 && response.data != null) {
        return MovieModel.fromJson(response.data as Map<String, dynamic>);
      }
      return _findMock(movieId);
    } catch (_) {
      return _findMock(movieId);
    }
  }

  @override
  Future<List<MovieModel>> getSimilarMovies(int movieId) async {
    try {
      final response = await dioClient.get('${ApiConstants.movieDetails}/$movieId/similar');
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] as List? ?? [];
        return results
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return MockData.sampleMovies;
    } catch (_) {
      return MockData.sampleMovies;
    }
  }

  MovieModel _findMock(int movieId) {
    return MockData.sampleMovies.firstWhere(
      (m) => m.id == movieId,
      orElse: () => MockData.sampleMovies.first,
    );
  }
}
