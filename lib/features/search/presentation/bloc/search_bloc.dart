import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

EventTransformer<T> debounceTransformer<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMoviesUseCase searchMoviesUseCase;

  SearchBloc({required this.searchMoviesUseCase}) : super(const SearchInitialState()) {
    on<SearchQueryChangedEvent>(
      _onSearchQueryChanged,
      transformer: debounceTransformer(const Duration(milliseconds: 400)),
    );
    on<ClearSearchEvent>(_onClearSearch);
    on<LoadMoreSearchMoviesEvent>(_onLoadMoreSearchMovies);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const SearchInitialState());
      return;
    }

    emit(const SearchLoadingState());

    final result = await searchMoviesUseCase.execute(query, page: 1);

    if (result is DataSuccess && result.data != null) {
      final movies = result.data!;
      if (movies.isEmpty) {
        emit(SearchEmptyState(query: query));
      } else {
        emit(SearchLoadedState(
          movies: movies,
          query: query,
          currentPage: 1,
          hasReachedMax: movies.length < 20,
          isLoadMoreActive: false,
        ));
      }
    } else {
      emit(SearchErrorState(
        message: result.error?.message ?? 'Failed to perform search.',
      ));
    }
  }

  Future<void> _onLoadMoreSearchMovies(
    LoadMoreSearchMoviesEvent event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchLoadedState ||
        currentState.hasReachedMax ||
        currentState.isLoadMoreActive) {
      return;
    }

    emit(currentState.copyWith(isLoadMoreActive: true));

    final nextPage = currentState.currentPage + 1;
    final result = await searchMoviesUseCase.execute(
      currentState.query,
      page: nextPage,
    );

    if (result is DataSuccess && result.data != null) {
      final newMovies = result.data!;
      if (newMovies.isEmpty) {
        emit(currentState.copyWith(
          hasReachedMax: true,
          isLoadMoreActive: false,
        ));
      } else {
        emit(SearchLoadedState(
          movies: currentState.movies + newMovies,
          query: currentState.query,
          currentPage: nextPage,
          hasReachedMax: newMovies.length < 20,
          isLoadMoreActive: false,
        ));
      }
    } else {
      emit(currentState.copyWith(isLoadMoreActive: false));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchInitialState());
  }
}
