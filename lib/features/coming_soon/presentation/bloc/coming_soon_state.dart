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

  const ComingSoonLoadedState({required this.movies});

  @override
  List<Object?> get props => [movies];
}

class ComingSoonErrorState extends ComingSoonState {
  final String message;

  const ComingSoonErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
