import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/error_handler.dart';
import '../../domain/usecases/get_dashboard_movies_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardMoviesUseCase getDashboardMoviesUseCase;

  DashboardBloc({required this.getDashboardMoviesUseCase})
      : super(const DashboardInitialState()) {
    on<FetchDashboardMoviesEvent>(_onFetchDashboardMovies);
  }

  Future<void> _onFetchDashboardMovies(
    FetchDashboardMoviesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoadingState());

    final result = await getDashboardMoviesUseCase.execute();

    if (result is DataSuccess && result.data != null) {
      emit(DashboardLoadedState(data: result.data!));
    } else {
      emit(DashboardErrorState(
        message: result.error?.message ?? 'Unable to fetch dashboard content.',
      ));
    }
  }
}
