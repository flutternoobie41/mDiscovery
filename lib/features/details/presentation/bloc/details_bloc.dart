import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import 'details_event.dart';
import 'details_state.dart';

class MovieDetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final GetMovieDetailsUseCase getMovieDetailsUseCase;

  MovieDetailsBloc({required this.getMovieDetailsUseCase})
      : super(const DetailsInitialState()) {
    on<FetchMovieDetailsEvent>(_onFetchMovieDetails);
  }

  Future<void> _onFetchMovieDetails(
    FetchMovieDetailsEvent event,
    Emitter<DetailsState> emit,
  ) async {
    emit(const DetailsLoadingState());

    final result = await getMovieDetailsUseCase.execute(event.movieId);

    if (result is DataSuccess && result.data != null) {
      emit(DetailsLoadedState(detailsData: result.data!));
    } else {
      emit(DetailsErrorState(
        message: result.error?.message ?? 'Failed to load movie details.',
      ));
    }
  }
}
