import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/custom_shimmer_loader.dart';
import '../../../../core/widgets/error_retry_widget.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';
import '../../../dashboard/presentation/widgets/movie_rail_widget.dart';
import '../bloc/details_bloc.dart';
import '../bloc/details_event.dart';
import '../bloc/details_state.dart';

class MovieDetailsScreen extends StatefulWidget {
  final MovieEntity movie;
  final Function(MovieEntity) onMovieSelected;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isPlayingTrailer = false;
  bool _isSavedToList = false;

  final List<Map<String, String>> _castMembers = [
    {'name': 'Timothée Chalamet', 'role': 'Paul Atreides', 'image': 'https://image.tmdb.org/t/p/w200/BE2A2aWz2X4mZ0P3p3aJWh.jpg'},
    {'name': 'Zendaya', 'role': 'Chani', 'image': 'https://image.tmdb.org/t/p/w200/nZ62y2e2m1gZ7mZ.jpg'},
    {'name': 'Rebecca Ferguson', 'role': 'Lady Jessica', 'image': 'https://image.tmdb.org/t/p/w200/4Z62y2e2m1gZ7mZ.jpg'},
    {'name': 'Javier Bardem', 'role': 'Stilgar', 'image': 'https://image.tmdb.org/t/p/w200/5Z62y2e2m1gZ7mZ.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<MovieDetailsBloc>().add(FetchMovieDetailsEvent(widget.movie.id));
  }

  Future<void> _launchYouTubeTrailer() async {
    final Uri url = Uri.parse('https://www.youtube.com/results?search_query=${Uri.encodeComponent(widget.movie.title)}+trailer');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _isPlayingTrailer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieDetailsBloc, DetailsState>(
        builder: (context, state) {
          if (state is DetailsLoadingState || state is DetailsInitialState) {
            return _buildLoadingDetails();
          } else if (state is DetailsErrorState) {
            return ErrorRetryWidget(
              errorMessage: state.message,
              onRetry: () {
                context.read<MovieDetailsBloc>().add(FetchMovieDetailsEvent(widget.movie.id));
              },
            );
          } else if (state is DetailsLoadedState) {
            final movie = state.detailsData.movie;
            final similar = state.detailsData.similarMovies;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320.h,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        CustomCachedImage(
                          imageUrl: movie.backdropPath,
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: 0,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.heroOverlayGradient,
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: _launchYouTubeTrailer,
                            child: Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlayingTrailer ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 40.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBadge(rating: movie.voteAverage),
                            SizedBox(width: 10.w),
                            Text(
                              movie.releaseDate.split('-').first,
                              style: AppTypography.bodySmall,
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text('Ultra HD 4K', style: AppTypography.caption),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(movie.title, style: AppTypography.heading1),
                        SizedBox(height: 12.h),
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _launchYouTubeTrailer,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: Text('Play Trailer', style: AppTypography.button),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSavedToList = !_isSavedToList;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _isSavedToList
                                          ? 'Added "${movie.title}" to My List'
                                          : 'Removed from My List',
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                _isSavedToList ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                                color: _isSavedToList ? AppColors.primary : Colors.white,
                                size: 28.w,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Downloading movie offline...')),
                                );
                              },
                              icon: Icon(Icons.download_rounded, color: Colors.white, size: 28.w),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Synopsis', style: AppTypography.heading3),
                        SizedBox(height: 8.h),
                        Text(
                          movie.overview,
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text('Top Cast', style: AppTypography.heading3),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 90.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _castMembers.length,
                            itemBuilder: (context, index) {
                              final cast = _castMembers[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 28.r,
                                      backgroundColor: AppColors.surfaceLight,
                                      child: Icon(Icons.person_rounded, color: Colors.white70, size: 30.w),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      cast['name']!,
                                      style: AppTypography.caption.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        MovieRailWidget(
                          title: 'More Like This',
                          movies: similar,
                          onMovieSelected: widget.onMovieSelected,
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmerLoader(width: double.infinity, height: 320.h, borderRadius: 0),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerLoader(width: 200.w, height: 28.h),
                SizedBox(height: 12.h),
                CustomShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 12.r),
                SizedBox(height: 20.h),
                CustomShimmerLoader(width: double.infinity, height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
