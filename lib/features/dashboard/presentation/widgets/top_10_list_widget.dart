import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/movie_entity.dart';

class Top10ListWidget extends StatelessWidget {
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieSelected;

  const Top10ListWidget({
    super.key,
    required this.movies,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    final displayMovies = movies.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Text(
            'Top 10 in Nigeria Today',
            style: AppTypography.heading3.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: displayMovies.length,
            itemBuilder: (context, index) {
              final movie = displayMovies[index];

              return Container(
                width: 145.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: GestureDetector(
                  onTap: () => onMovieSelected(movie),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Hollow Outline Rank Number in background
                      Positioned(
                        left: -5.w,
                        bottom: -15.h,
                        child: Stack(
                          children: [
                            // White/Grey Outline Stroke
                            Text(
                              '${index + 1}',
                              style: AppStyle.tssW900.copyWith(
                                fontSize: 115.sp,
                                height: 0.9,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 6.w
                                  ..color = const Color(0xFF8C8787),
                              ),
                            ),
                            // Black Interior fill (creates the stencil look)
                            Text(
                              '${index + 1}',
                              style: AppStyle.tssW900.copyWith(
                                fontSize: 115.sp,
                                height: 0.9,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Movie Card Poster overlapping
                      Positioned(
                        left: 42.w,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: CustomCachedImage(
                          imageUrl: movie.posterPath,
                          width: 105.w,
                          height: 180.h,
                          borderRadius: 8.r,
                        ),
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
