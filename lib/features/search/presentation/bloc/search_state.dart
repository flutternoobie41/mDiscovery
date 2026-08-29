import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {
  final List<MovieEntity> trendingMovies;
  final bool isLoading;
  final String? error;

  const SearchInitialState({
    this.trendingMovies = const [],
    this.isLoading = false,
    this.error,
  });

  SearchInitialState copyWith({
    List<MovieEntity>? trendingMovies,
    bool? isLoading,
    String? error,
  }) {
    return SearchInitialState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [trendingMovies, isLoading, error];
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchEmptyState extends SearchState {
  final String query;

  const SearchEmptyState({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchLoadedState extends SearchState {
  final List<MovieEntity> movies;
  final String query;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadMoreActive;

  const SearchLoadedState({
    required this.movies,
    required this.query,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadMoreActive = false,
  });

  SearchLoadedState copyWith({
    List<MovieEntity>? movies,
    String? query,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadMoreActive,
  }) {
    return SearchLoadedState(
      movies: movies ?? this.movies,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadMoreActive: isLoadMoreActive ?? this.isLoadMoreActive,
    );
  }

  @override
  List<Object?> get props => [movies, query, currentPage, hasReachedMax, isLoadMoreActive];
}

class SearchErrorState extends SearchState {
  final String message;

  const SearchErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
