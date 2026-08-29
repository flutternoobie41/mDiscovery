import 'package:equatable/equatable.dart';

abstract class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMovieDetailsEvent extends DetailsEvent {
  final int movieId;

  const FetchMovieDetailsEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
