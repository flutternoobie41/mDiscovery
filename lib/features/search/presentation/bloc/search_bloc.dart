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

    final result = await searchMoviesUseCase.execute(query);

    if (result is DataSuccess && result.data != null) {
      final movies = result.data!;
      if (movies.isEmpty) {
        emit(SearchEmptyState(query: query));
      } else {
        emit(SearchLoadedState(movies: movies, query: query));
      }
    } else {
      emit(SearchErrorState(
        message: result.error?.message ?? 'Failed to perform search.',
      ));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchInitialState());
  }
}
