import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/widgets/custom_shimmer_loader.dart';
import '../../../../core/widgets/error_retry_widget.dart';
import '../../domain/entities/movie_entity.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/previews_list_widget.dart';
import '../widgets/continue_watching_list_widget.dart';
import '../widgets/movie_rail_widget.dart';
import '../../../main_navigation/presentation/cubit/navigation_cubit.dart';

class DashboardScreen extends StatefulWidget {
  final Function(MovieEntity) onMovieSelected;

  const DashboardScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset;
    });
  }

  void _precacheAllMovies(DashboardLoadedState state) {
    if (!mounted) return;
    final data = state.data;
    final allMovies = [
      ...data.previews,
      ...data.continueWatching,
      ...data.popular,
      ...data.trending,
      ...data.top10,
      ...data.myList,
      ...data.africanMovies,
      ...data.nollywood,
      ...data.netflixOriginals,
      ...data.watchItAgain,
      ...data.newReleases,
      ...data.tvThrillers,
      ...data.usTvShows,
    ];
    for (final movie in allMovies) {
      if (movie.posterPath.isNotEmpty && movie.posterPath.startsWith('http')) {
        precacheImage(
          CachedNetworkImageProvider(movie.posterPath),
          context,
        ).catchError((_) {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showSolidHeader = _scrollOffset > 50;

    return BlocListener<NavigationCubit, int>(
      listener: (context, state) {
        if (state == 0) {
          context.read<DashboardBloc>().add(const FetchDashboardMoviesEvent());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardLoadedState) {
            _precacheAllMovies(state);
          }
        },
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
            // The featured movie is selected from the top trending list
            final featuredMovie = data.trending.isNotEmpty ? data.trending.first : data.popular.first;

            return Stack(
              children: [
                // 1. Full Screen Scrollable Content
                Positioned.fill(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    onRefresh: () async {
                      context.read<DashboardBloc>().add(const FetchDashboardMoviesEvent());
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Featured movie Hero banner at the top
                          HeroBannerWidget(
                            movie: featuredMovie,
                            onTap: () => widget.onMovieSelected(featuredMovie),
                          ),
                          SizedBox(height: 8.h),
                          // Section 1: Previews (circular)
                          PreviewsListWidget(
                            movies: data.previews,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 2: Continue Watching
                          ContinueWatchingListWidget(
                            movies: data.continueWatching,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 3: Popular on Netflix
                          MovieRailWidget(
                            title: 'Popular on Netflix',
                            movies: data.popular,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 4: Trending Now
                          MovieRailWidget(
                            title: 'Trending Now',
                            movies: data.trending,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 5: Top 10 in Nigeria Today
                          MovieRailWidget(
                            title: 'Top 10 in Nigeria Today',
                            movies: data.top10,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 6: My List
                          MovieRailWidget(
                            title: 'My List',
                            movies: data.myList,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 7: African Movies
                          MovieRailWidget(
                            title: 'African Movies',
                            movies: data.africanMovies,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 8: Nollywood Movies & TV
                          MovieRailWidget(
                            title: 'Nollywood Movies & TV',
                            movies: data.nollywood,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 9: Netflix Originals (Taller cards)
                          MovieRailWidget(
                            title: 'Netflix Originals',
                            movies: data.netflixOriginals,
                            isOriginals: true,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 10: Watch It Again
                          MovieRailWidget(
                            title: 'Watch It Again',
                            movies: data.watchItAgain,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 11: New Releases
                          MovieRailWidget(
                            title: 'New Releases',
                            movies: data.newReleases,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 12: TV Thrillers & Mysteries
                          MovieRailWidget(
                            title: 'TV Thrillers & Mysteries',
                            movies: data.tvThrillers,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 12.h),
                          // Section 13: US TV Shows
                          MovieRailWidget(
                            title: 'US TV Shows',
                            movies: data.usTvShows,
                            onMovieSelected: widget.onMovieSelected,
                          ),
                          SizedBox(height: 30.h), // Spacing for bottom navbar
                        ],
                      ),
                    ),
                  ),
                ),
                // 2. Overlapping Dynamic Transparent Header Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    color: showSolidHeader
                        ? Colors.black.withValues(alpha: 0.85)
                        : Colors.transparent,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Row(
                          children: [
                            // Netflix small logo
                            Image.asset(
                              'assets/images/logos_netflix-small.png',
                              height: 32.h,
                            ),
                            SizedBox(width: 20.w),
                            // Navigation Links
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'TV Shows',
                                      style: AppStyle.tss14W400.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'Movies',
                                      style: AppStyle.tss14W400.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'My List',
                                      style: AppStyle.tss14W400.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ),
  );
}

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner shimmer
          CustomShimmerLoader(
            width: double.infinity,
            height: 520.h,
            borderRadius: 0,
          ),
          SizedBox(height: 20.h),
          // Previews title shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomShimmerLoader(width: 100.w, height: 18.h),
          ),
          SizedBox(height: 12.h),
          // Previews circle avatars shimmer
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              itemCount: 4,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CustomShimmerLoader(
                  width: 90.w,
                  height: 90.h,
                  borderRadius: 45.r,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Standard rail title shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomShimmerLoader(width: 160.w, height: 18.h),
          ),
          SizedBox(height: 12.h),
          // Standard cards rail shimmer
          SizedBox(
            height: 165.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              itemCount: 3,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: CustomShimmerLoader(
                  width: 110.w,
                  height: 165.h,
                  borderRadius: 8.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
