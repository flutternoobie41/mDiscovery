import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/search/domain/usecases/get_trending_movies_usecase.dart';
import 'package:mdiscover/features/search/domain/usecases/search_movies_usecase.dart';
import 'package:mdiscover/features/search/presentation/bloc/search_bloc.dart';
import 'package:mdiscover/features/search/presentation/bloc/search_event.dart';
import 'package:mdiscover/features/search/presentation/bloc/search_state.dart';

class MockSearchMoviesUseCase extends Mock implements SearchMoviesUseCase {}
class MockGetTrendingMoviesUseCase extends Mock implements GetTrendingMoviesUseCase {}

void main() {
  late SearchBloc searchBloc;
  late MockSearchMoviesUseCase mockSearchMoviesUseCase;
  late MockGetTrendingMoviesUseCase mockGetTrendingMoviesUseCase;

  setUp(() {
    mockSearchMoviesUseCase = MockSearchMoviesUseCase();
    mockGetTrendingMoviesUseCase = MockGetTrendingMoviesUseCase();
    searchBloc = SearchBloc(
      searchMoviesUseCase: mockSearchMoviesUseCase,
      getTrendingMoviesUseCase: mockGetTrendingMoviesUseCase,
    );
  });

  tearDown(() {
    searchBloc.close();
  });

  test('initial state should be SearchInitialState', () {
    expect(searchBloc.state, equals(const SearchInitialState()));
  });

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoadingState, SearchLoadedState] when SearchQueryChangedEvent succeeds with non-empty results',
    build: () {
      when(() => mockSearchMoviesUseCase.execute('Dune'))
          .thenAnswer((_) async => DataSuccess(MockData.sampleMovies));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchQueryChangedEvent('Dune')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const SearchLoadingState(),
      SearchLoadedState(
        movies: MockData.sampleMovies,
        query: 'Dune',
        hasReachedMax: true,
      ),
    ],
    verify: (_) {
      verify(() => mockSearchMoviesUseCase.execute('Dune')).called(1);
    },
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoadingState, SearchEmptyState] when SearchQueryChangedEvent succeeds with empty results',
    build: () {
      when(() => mockSearchMoviesUseCase.execute('NonExistentMovie'))
          .thenAnswer((_) async => const DataSuccess([]));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchQueryChangedEvent('NonExistentMovie')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const SearchLoadingState(),
      const SearchEmptyState(query: 'NonExistentMovie'),
    ],
  );
}
