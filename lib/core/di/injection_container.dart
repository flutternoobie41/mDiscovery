import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/get_dashboard_movies_usecase.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/get_trending_movies_usecase.dart';
import '../../features/search/domain/usecases/search_movies_usecase.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';

import '../../features/coming_soon/data/datasources/coming_soon_remote_datasource.dart';
import '../../features/coming_soon/data/repositories/coming_soon_repository_impl.dart';
import '../../features/coming_soon/domain/repositories/coming_soon_repository.dart';
import '../../features/coming_soon/domain/usecases/get_upcoming_movies_usecase.dart';
import '../../features/coming_soon/presentation/bloc/coming_soon_bloc.dart';

import '../../features/details/data/datasources/details_remote_datasource.dart';
import '../../features/details/data/repositories/details_repository_impl.dart';
import '../../features/details/domain/repositories/details_repository.dart';
import '../../features/details/domain/usecases/get_movie_details_usecase.dart';
import '../../features/details/presentation/bloc/details_bloc.dart';

import '../../features/main_navigation/presentation/cubit/navigation_cubit.dart';

final sl = GetIt.instance;

/// Initialize all GetIt service locator dependencies.
Future<void> initDependencyInjection() async {
  // Core Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Navigation Shell
  sl.registerFactory<NavigationCubit>(() => NavigationCubit());

  // Features - Dashboard
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetDashboardMoviesUseCase>(
    () => GetDashboardMoviesUseCase(repository: sl()),
  );
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(getDashboardMoviesUseCase: sl()),
  );

  // Features - Search
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SearchMoviesUseCase>(
    () => SearchMoviesUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetTrendingMoviesUseCase>(
    () => GetTrendingMoviesUseCase(repository: sl()),
  );
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchMoviesUseCase: sl(),
      getTrendingMoviesUseCase: sl(),
    ),
  );

  // Features - Coming Soon
  sl.registerLazySingleton<ComingSoonRemoteDataSource>(
    () => ComingSoonRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ComingSoonRepository>(
    () => ComingSoonRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetUpcomingMoviesUseCase>(
    () => GetUpcomingMoviesUseCase(repository: sl()),
  );
  sl.registerFactory<ComingSoonBloc>(
    () => ComingSoonBloc(getUpcomingMoviesUseCase: sl()),
  );

  // Features - Details
  sl.registerLazySingleton<DetailsRemoteDataSource>(
    () => DetailsRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<DetailsRepository>(
    () => DetailsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<GetMovieDetailsUseCase>(
    () => GetMovieDetailsUseCase(repository: sl()),
  );
  sl.registerFactory<MovieDetailsBloc>(
    () => MovieDetailsBloc(getMovieDetailsUseCase: sl()),
  );
}
