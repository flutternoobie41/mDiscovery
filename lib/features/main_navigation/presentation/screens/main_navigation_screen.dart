import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../coming_soon/presentation/bloc/coming_soon_bloc.dart';
import '../../../coming_soon/presentation/bloc/coming_soon_event.dart';
import '../../../coming_soon/presentation/screens/coming_soon_screen.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';
import '../../../dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../../dashboard/presentation/bloc/dashboard_event.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../details/presentation/bloc/details_bloc.dart';
import '../../../details/presentation/screens/movie_details_screen.dart';
import '../../../downloads_watchlist/presentation/screens/watchlist_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../search/presentation/bloc/search_bloc.dart';
import '../../../search/presentation/screens/search_screen.dart';
import '../cubit/navigation_cubit.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  void _navigateToDetails(BuildContext context, MovieEntity movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider<MovieDetailsBloc>(
          create: (_) => sl<MovieDetailsBloc>(),
          child: MovieDetailsScreen(
            movie: movie,
            onMovieSelected: (selectedMovie) => _navigateToDetails(context, selectedMovie),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentTab) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            index: currentTab,
            children: [
              BlocProvider<DashboardBloc>(
                create: (_) => sl<DashboardBloc>()..add(const FetchDashboardMoviesEvent()),
                child: DashboardScreen(
                  onMovieSelected: (movie) => _navigateToDetails(context, movie),
                ),
              ),
              BlocProvider<SearchBloc>(
                create: (_) => sl<SearchBloc>(),
                child: SearchScreen(
                  onMovieSelected: (movie) => _navigateToDetails(context, movie),
                ),
              ),
              BlocProvider<ComingSoonBloc>(
                create: (_) => sl<ComingSoonBloc>()..add(const FetchUpcomingMoviesEvent()),
                child: ComingSoonScreen(
                  onMovieSelected: (movie) => _navigateToDetails(context, movie),
                ),
              ),
              WatchlistScreen(
                onMovieSelected: (movie) => _navigateToDetails(context, movie),
              ),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentTab,
              onTap: (index) => context.read<NavigationCubit>().selectTab(index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.surface,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textMuted,
              selectedFontSize: 11.sp,
              unselectedFontSize: 11.sp,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded),
                  activeIcon: Icon(Icons.search_rounded, color: AppColors.primary),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_library_rounded),
                  activeIcon: Icon(Icons.video_library_rounded, color: AppColors.primary),
                  label: 'Coming Soon',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_download_outlined),
                  activeIcon: Icon(Icons.file_download_rounded, color: AppColors.primary),
                  label: 'Watchlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded, color: AppColors.primary),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
