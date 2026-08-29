import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/network/error_handler.dart';
import 'package:mdiscover/features/dashboard/domain/usecases/get_dashboard_movies_usecase.dart';
import 'package:mdiscover/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:mdiscover/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:mdiscover/features/dashboard/presentation/bloc/dashboard_state.dart';

class MockGetDashboardMoviesUseCase extends Mock implements GetDashboardMoviesUseCase {}

void main() {
  late DashboardBloc dashboardBloc;
  late MockGetDashboardMoviesUseCase mockGetDashboardMoviesUseCase;

  setUp(() {
    mockGetDashboardMoviesUseCase = MockGetDashboardMoviesUseCase();
    dashboardBloc = DashboardBloc(getDashboardMoviesUseCase: mockGetDashboardMoviesUseCase);
  });

  tearDown(() {
    dashboardBloc.close();
  });

  final tDashboardData = DashboardData(
    previews: MockData.sampleMovies,
    continueWatching: MockData.sampleMovies,
    popular: MockData.sampleMovies,
    trending: MockData.sampleMovies,
    top10: MockData.sampleMovies,
    myList: MockData.sampleMovies,
    africanMovies: MockData.sampleMovies,
    nollywood: MockData.sampleMovies,
    netflixOriginals: MockData.sampleMovies,
    watchItAgain: MockData.sampleMovies,
    newReleases: MockData.sampleMovies,
    tvThrillers: MockData.sampleMovies,
    usTvShows: MockData.sampleMovies,
  );

  test('initial state should be DashboardInitialState', () {
    expect(dashboardBloc.state, equals(const DashboardInitialState()));
  });

  blocTest<DashboardBloc, DashboardState>(
    'emits [DashboardLoadingState, DashboardLoadedState] when FetchDashboardMoviesEvent succeeds',
    build: () {
      when(() => mockGetDashboardMoviesUseCase.execute())
          .thenAnswer((_) async => DataSuccess(tDashboardData));
      return dashboardBloc;
    },
    act: (bloc) => bloc.add(const FetchDashboardMoviesEvent()),
    expect: () => [
      const DashboardLoadingState(),
      DashboardLoadedState(data: tDashboardData),
    ],
    verify: (_) {
      verify(() => mockGetDashboardMoviesUseCase.execute()).called(1);
    },
  );

  blocTest<DashboardBloc, DashboardState>(
    'emits [DashboardLoadingState, DashboardErrorState] when FetchDashboardMoviesEvent fails',
    build: () {
      when(() => mockGetDashboardMoviesUseCase.execute())
          .thenAnswer((_) async => const DataFailed(NetworkException('Network error')));
      return dashboardBloc;
    },
    act: (bloc) => bloc.add(const FetchDashboardMoviesEvent()),
    expect: () => [
      const DashboardLoadingState(),
      const DashboardErrorState(message: 'Network error'),
    ],
  );
}
