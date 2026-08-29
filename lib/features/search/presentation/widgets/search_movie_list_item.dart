import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../dashboard/domain/entities/movie_entity.dart';

class SearchMovieListItem extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const SearchMovieListItem({
    super.key,
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
