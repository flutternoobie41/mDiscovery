import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/movie_entity.dart';

class MovieRailWidget extends StatelessWidget {
  final String title;
  final List<MovieEntity> movies;
  final Function(MovieEntity) onMovieSelected;
  final bool isOriginals;

  const MovieRailWidget({
    super.key,
    required this.title,
    required this.movies,
    required this.onMovieSelected,
    this.isOriginals = false,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    // Originals are taller (135w x 240h), standard cards are (110w x 165h)
    final double cardWidth = isOriginals ? 135.w : 110.w;
    final double cardHeight = isOriginals ? 240.h : 165.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Text(
            title,
            style: AppStyle.tss20W700.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Container(
                width: cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                child: GestureDetector(
                  onTap: () => onMovieSelected(movie),
                  child: CustomCachedImage(
                    imageUrl: movie.posterPath,
                    width: cardWidth,
                    height: cardHeight,
                    borderRadius: 8.r,
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
