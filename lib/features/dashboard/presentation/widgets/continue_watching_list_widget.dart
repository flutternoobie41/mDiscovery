import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/movie_entity.dart';

class ContinueWatchingListWidget extends StatelessWidget {
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieSelected;

  const ContinueWatchingListWidget({
    super.key,
    required this.movies,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    // Mock progress values for the movies
    final progressValues = [0.35, 0.72, 0.50, 0.15];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Text(
            'Continue Watching for Emenalo',
            style: AppStyle.tss20W700.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 205.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final progress = progressValues[index % progressValues.length];

              return Container(
                width: 110.w,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                child: GestureDetector(
                  onTap: () => onMovieSelected(movie),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster Image
                        Expanded(
                          child: Stack(
                            children: [
                              CustomCachedImage(
                                imageUrl: movie.posterPath,
                                width: 110.w,
                                height: double.infinity,
                                borderRadius: 12.r,
                              ),
                              // Big Play icon overlay
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 24.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Watch Progress Bar
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          minHeight: 3.h,
                        ),
                        // Footer Panel
                        Container(
                          color: AppColors.surface,
                          height: 38.h,
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () => onMovieSelected(movie),
                              ),
                              const Icon(
                                Icons.more_vert_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
