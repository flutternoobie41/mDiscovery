import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/movie_entity.dart';

class PreviewsListWidget extends StatelessWidget {
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieSelected;

  const PreviewsListWidget({
    super.key,
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
          child: Text(
            'Previews',
            style: AppStyle.tss20W700.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 98.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => onMovieSelected(movie),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white30,
                      width: 2.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CustomCachedImage(
                      imageUrl: movie.posterPath,
                      width: 90.w,
                      height: 90.h,
                      borderRadius: 0,
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
