import 'package:mdiscover/core/constants/api_constants.dart';
import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/network/dio_client.dart';
import 'package:mdiscover/features/dashboard/data/models/movie_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<MovieModel>> searchMovies(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final response = await dioClient.get(
        ApiConstants.searchMovies,
        queryParameters: {'query': query},
      );
      if (response.statusCode == 200 && response.data != null) {
        final List results = response.data['results'] as List? ?? [];
        return results
            .map((json) => MovieModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return _mockFilter(query);
    } catch (_) {
      return _mockFilter(query);
    }
  }

  List<MovieModel> _mockFilter(String query) {
    return MockData.sampleMovies
        .where((m) => m.title.toLowerCase().contains(query.toLowerCase()) ||
            m.genres.any((g) => g.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }
}
