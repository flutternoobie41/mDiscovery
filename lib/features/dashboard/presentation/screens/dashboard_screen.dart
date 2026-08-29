import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_shimmer_loader.dart';
import '../../../../core/widgets/error_retry_widget.dart';
import '../../domain/entities/movie_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/movie_rail_widget.dart';

class DashboardScreen extends StatelessWidget {
  final Function(MovieEntity) onMovieSelected;

  const DashboardScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoadingState || state is DashboardInitialState) {
            return _buildShimmerLoading();
          } else if (state is DashboardErrorState) {
            return ErrorRetryWidget(
              errorMessage: state.message,
              onRetry: () {
                context.read<DashboardBloc>().add(const FetchDashboardMoviesEvent());
              },
            );
          } else if (state is DashboardLoadedState) {
            final data = state.data;
            final featuredMovie = data.trending.isNotEmpty ? data.trending.first : data.popular.first;

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                context.read<DashboardBloc>().add(const FetchDashboardMoviesEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    HeroBannerWidget(
                      movie: featuredMovie,
                      onTap: () => onMovieSelected(featuredMovie),
                    ),
                    SizedBox(height: 12.h),
                    MovieRailWidget(
                      title: '🔥 Trending Now',
                      movies: data.trending,
                      onMovieSelected: onMovieSelected,
                    ),
                    MovieRailWidget(
                      title: '⭐ Popular Movies',
                      movies: data.popular,
                      onMovieSelected: onMovieSelected,
                    ),
                    MovieRailWidget(
                      title: '🎬 Now Playing in Theaters',
                      movies: data.nowPlaying,
                      onMovieSelected: onMovieSelected,
                    ),
                    MovieRailWidget(
                      title: '🏆 Top Rated Classics',
                      movies: data.topRated,
                      onMovieSelected: onMovieSelected,
                    ),
                    SizedBox(height: 90.h), // Spacing for bottom navbar
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmerLoader(
            width: double.infinity,
            height: 380.h,
            borderRadius: 0,
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomShimmerLoader(width: 160.w, height: 24.h),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 200.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 4,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: CustomShimmerLoader(width: 130.w, height: 180.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
