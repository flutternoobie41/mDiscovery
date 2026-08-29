import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mdiscover/core/constants/app_colors.dart';
import 'package:mdiscover/core/constants/app_typography.dart';
import 'package:mdiscover/core/widgets/custom_cached_image.dart';
import 'package:mdiscover/core/widgets/custom_shimmer_loader.dart';
import 'package:mdiscover/core/widgets/error_retry_widget.dart';
import 'package:mdiscover/core/widgets/rating_badge.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatefulWidget {
  final Function(MovieEntity) onMovieSelected;

  const SearchScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _genreCategories = [
    {'name': 'Action', 'icon': Icons.flash_on_rounded, 'color': const Color(0xFFFF5252)},
    {'name': 'Sci-Fi', 'icon': Icons.rocket_launch_rounded, 'color': const Color(0xFF7C4DFF)},
    {'name': 'Comedy', 'icon': Icons.sentiment_very_satisfied_rounded, 'color': const Color(0xFFFFB300)},
    {'name': 'Drama', 'icon': Icons.theater_comedy_rounded, 'color': const Color(0xFF00E676)},
    {'name': 'Thriller', 'icon': Icons.visibility_rounded, 'color': const Color(0xFFFF4081)},
    {'name': 'Animation', 'icon': Icons.palette_rounded, 'color': const Color(0xFF00E5FF)},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Search Movies', style: AppTypography.heading2),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context.read<SearchBloc>().add(SearchQueryChangedEvent(query));
              },
              style: AppTypography.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search movies, genres, cast...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          context.read<SearchBloc>().add(const ClearSearchEvent());
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitialState) {
                  return _buildInitialGenreGrid();
                } else if (state is SearchLoadingState) {
                  return _buildLoadingGrid();
                } else if (state is SearchEmptyState) {
                  return _buildEmptyResults(state.query);
                } else if (state is SearchErrorState) {
                  return ErrorRetryWidget(
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<SearchBloc>().add(SearchQueryChangedEvent(_searchController.text));
                    },
                  );
                } else if (state is SearchLoadedState) {
                  return _buildMovieGrid(state.movies);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialGenreGrid() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular Genres', style: AppTypography.heading3),
          SizedBox(height: 16.h),
          Expanded(
            child: GridView.builder(
              itemCount: _genreCategories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.2,
              ),
              itemBuilder: (context, index) {
                final genre = _genreCategories[index];
                return InkWell(
                  onTap: () {
                    _searchController.text = genre['name'] as String;
                    context.read<SearchBloc>().add(SearchQueryChangedEvent(genre['name'] as String));
                    setState(() {});
                  },
                  borderRadius: BorderRadius.circular(16.r),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: (genre['color'] as Color).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(genre['icon'] as IconData, color: genre['color'] as Color, size: 20.w),
                        ),
                        SizedBox(width: 12.w),
                        Text(genre['name'] as String, style: AppTypography.titleLarge.copyWith(fontSize: 14.sp)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) => CustomShimmerLoader(
        width: double.infinity,
        height: 220.h,
        borderRadius: 16.r,
      ),
    );
  }

  Widget _buildEmptyResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64.w, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text('No Movies Found', style: AppTypography.heading3),
          SizedBox(height: 8.h),
          Text(
            'We couldn\'t find any results for "$query"',
            style: AppTypography.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<MovieEntity> movies) {
    return GridView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => widget.onMovieSelected(movie),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    CustomCachedImage(
                      imageUrl: movie.posterPath,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 16.r,
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: RatingBadge(rating: movie.voteAverage),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                movie.title,
                style: AppTypography.titleLarge.copyWith(fontSize: 14.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.releaseDate.split('-').first,
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
