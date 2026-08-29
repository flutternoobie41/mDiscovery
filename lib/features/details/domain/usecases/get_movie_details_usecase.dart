import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import 'package:mdiscover/features/details/domain/repositories/details_repository.dart';

class MovieDetailsData {
  final MovieEntity movie;
  final List<MovieEntity> similarMovies;

  const MovieDetailsData({
    required this.movie,
    required this.similarMovies,
  });
}

class GetMovieDetailsUseCase {
  final DetailsRepository repository;

  GetMovieDetailsUseCase({required this.repository});

  Future<DataState<MovieDetailsData>> execute(int movieId) async {
    try {
      final results = await Future.wait([
        repository.getMovieDetails(movieId),
        repository.getSimilarMovies(movieId),
      ]);

      final movie = results[0].data as MovieEntity?;
      final similar = results[1].data as List<MovieEntity>? ?? [];

      if (movie == null) {
        return const DataFailed(NetworkException('Movie details not found.'));
      }

      return DataSuccess(
        MovieDetailsData(
          movie: movie,
          similarMovies: similar,
        ),
      );
    } catch (e) {
      return DataFailed(NetworkException('Failed to load movie details: ${e.toString()}'));
    }
  }
}
