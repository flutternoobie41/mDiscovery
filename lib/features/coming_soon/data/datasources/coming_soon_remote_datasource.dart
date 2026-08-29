import 'package:mdiscover/core/constants/api_constants.dart';
import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/network/dio_client.dart';
import 'package:mdiscover/features/dashboard/data/models/movie_model.dart';

abstract class ComingSoonRemoteDataSource {
  Future<List<MovieModel>> getUpcomingMovies({int page = 1});
}

class ComingSoonRemoteDataSourceImpl implements ComingSoonRemoteDataSource {
  final DioClient dioClient;

  ComingSoonRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MovieModel>> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await dioClient.get(
        ApiConstants.upcomingMovies,
        queryParameters: {'page': page},
      );
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] as List? ?? [];
        return results
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return MockData.upcomingMovies;
    } catch (_) {
      return MockData.upcomingMovies;
    }
  }
}
