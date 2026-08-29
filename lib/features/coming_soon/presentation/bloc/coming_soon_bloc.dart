import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/usecases/get_upcoming_movies_usecase.dart';
import 'coming_soon_event.dart';
import 'coming_soon_state.dart';

class ComingSoonBloc extends Bloc<ComingSoonEvent, ComingSoonState> {
  final GetUpcomingMoviesUseCase getUpcomingMoviesUseCase;

  ComingSoonBloc({required this.getUpcomingMoviesUseCase})
      : super(const ComingSoonInitialState()) {
    on<FetchUpcomingMoviesEvent>(_onFetchUpcomingMovies);
    on<LoadMoreUpcomingMoviesEvent>(_onLoadMoreUpcomingMovies);
  }

  Future<void> _onFetchUpcomingMovies(
    FetchUpcomingMoviesEvent event,
    Emitter<ComingSoonState> emit,
  ) async {
    emit(const ComingSoonLoadingState());

    final result = await getUpcomingMoviesUseCase.execute(page: 1);

    if (result is DataSuccess && result.data != null) {
      final movies = result.data!;
      emit(ComingSoonLoadedState(
        movies: movies,
        currentPage: 1,
        hasReachedMax: movies.isEmpty || movies.length < 20,
        isLoadMoreActive: false,
      ));
    } else {
      emit(ComingSoonErrorState(
        message: result.error?.message ?? 'Failed to fetch upcoming releases.',
      ));
    }
  }

  Future<void> _onLoadMoreUpcomingMovies(
    LoadMoreUpcomingMoviesEvent event,
    Emitter<ComingSoonState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ComingSoonLoadedState ||
        currentState.hasReachedMax ||
        currentState.isLoadMoreActive) {
      return;
    }

    emit(currentState.copyWith(isLoadMoreActive: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getUpcomingMoviesUseCase.execute(page: nextPage);

    if (result is DataSuccess && result.data != null) {
      final newMovies = result.data!;
      if (newMovies.isEmpty) {
        emit(currentState.copyWith(
          hasReachedMax: true,
          isLoadMoreActive: false,
        ));
      } else {
        emit(ComingSoonLoadedState(
          movies: currentState.movies + newMovies,
          currentPage: nextPage,
          hasReachedMax: newMovies.length < 20,
          isLoadMoreActive: false,
        ));
      }
    } else {
      emit(currentState.copyWith(isLoadMoreActive: false));
    }
  }
}
