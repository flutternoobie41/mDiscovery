import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mdiscover/core/constants/app_colors.dart';
import 'package:mdiscover/core/constants/app_style.dart';
import 'package:mdiscover/core/constants/mock_data.dart';
import 'package:mdiscover/core/widgets/custom_cached_image.dart';
import 'package:mdiscover/features/dashboard/domain/entities/movie_entity.dart';

class WatchlistScreen extends StatelessWidget {
  final Function(MovieEntity) onMovieSelected;

  const WatchlistScreen({
    super.key,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Only list mock data where images are available
    final movies = MockData.sampleMovies
        .where((movie) => movie.backdropPath.isNotEmpty && movie.posterPath.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smart Downloads Header
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                child: Text(
                  'Smart Downloads',
                  style: AppStyle.tss14W400.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(height: 24.h),

              // Full-bleed static Movie List (similar to Search screen's list design)
              Column(
                children: movies.map((movie) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 3.h),
                    child: _MovieListItem(
                      movie: movie,
                      onTap: () => onMovieSelected(movie),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovieListItem extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const _MovieListItem({
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.searchBarBg,
        height: 76.h,
        width: double.infinity,
        child: Row(
          children: [
            CustomCachedImage(
              imageUrl: movie.backdropPath,
              width: 140.w,
              height: 76.h,
              fit: BoxFit.cover,
              borderRadius: 0,
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                movie.title,
                style: AppStyle.tss15W400.copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SvgPicture.asset(
                'assets/svgs/play_circle.svg',
                width: 28.w,
                height: 28.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
