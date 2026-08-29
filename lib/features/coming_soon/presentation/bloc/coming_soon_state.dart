import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';

abstract class ComingSoonState extends Equatable {
  const ComingSoonState();

  @override
  List<Object?> get props => [];
}

class ComingSoonInitialState extends ComingSoonState {
  const ComingSoonInitialState();
}

class ComingSoonLoadingState extends ComingSoonState {
  const ComingSoonLoadingState();
}

class ComingSoonLoadedState extends ComingSoonState {
  final List<MovieEntity> movies;
  final int currentPage;
  final bool hasReachedMax;
  final bool isLoadMoreActive;

  const ComingSoonLoadedState({
    required this.movies,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isLoadMoreActive = false,
  });

  ComingSoonLoadedState copyWith({
    List<MovieEntity>? movies,
    int? currentPage,
    bool? hasReachedMax,
    bool? isLoadMoreActive,
  }) {
    return ComingSoonLoadedState(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadMoreActive: isLoadMoreActive ?? this.isLoadMoreActive,
    );
  }

  @override
  List<Object?> get props => [movies, currentPage, hasReachedMax, isLoadMoreActive];
}

class ComingSoonErrorState extends ComingSoonState {
  final String message;

  const ComingSoonErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
