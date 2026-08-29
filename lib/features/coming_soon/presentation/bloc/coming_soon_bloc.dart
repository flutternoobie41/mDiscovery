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
  }

  Future<void> _onFetchUpcomingMovies(
    FetchUpcomingMoviesEvent event,
    Emitter<ComingSoonState> emit,
  ) async {
    emit(const ComingSoonLoadingState());

    final result = await getUpcomingMoviesUseCase.execute();

    if (result is DataSuccess && result.data != null) {
      emit(ComingSoonLoadedState(movies: result.data!));
    } else {
      emit(ComingSoonErrorState(
        message: result.error?.message ?? 'Failed to fetch upcoming releases.',
      ));
    }
  }
}
