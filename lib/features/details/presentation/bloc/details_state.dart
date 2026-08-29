import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';

abstract class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

class DetailsInitialState extends DetailsState {
  const DetailsInitialState();
}

class DetailsLoadingState extends DetailsState {
  const DetailsLoadingState();
}

class DetailsLoadedState extends DetailsState {
  final MovieDetailsData detailsData;

  const DetailsLoadedState({required this.detailsData});

  @override
  List<Object?> get props => [detailsData];
}

class DetailsErrorState extends DetailsState {
  final String message;

  const DetailsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
