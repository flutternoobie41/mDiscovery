import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../domain/entities/movie_entity.dart';

/// Reusable horizontal movie list rail component with poster card, title, and rating.
class MovieRailWidget extends StatelessWidget {
  final String title;
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieSelected;

  const MovieRailWidget({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.heading3),
              Text(
                'See All',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Container(
                width: 130.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                child: GestureDetector(
                  onTap: () => onMovieSelected(movie),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CustomCachedImage(
                            imageUrl: movie.posterPath,
                            width: 130.w,
                            height: 175.h,
                            borderRadius: 12.r,
                          ),
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: RatingBadge(rating: movie.voteAverage),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        movie.title,
                        style: AppTypography.titleLarge.copyWith(fontSize: 13.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
