import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_style.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../domain/entities/movie_entity.dart';

class HeroBannerWidget extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onTap;

  const HeroBannerWidget({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Background Poster
        CustomCachedImage(
          imageUrl: movie.posterPath, // using poster path for taller portrait aspect ratio
          width: double.infinity,
          height: 520.h,
          borderRadius: 0,
        ),
        // Dark Gradient Overlay
        Container(
          height: 520.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.transparent,
                Colors.transparent,
                Colors.black87,
                Colors.black,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.2, 0.5, 0.85, 1.0],
            ),
          ),
        ),
        // Overlaid Information & Action Buttons
        Positioned(
          left: 20.w,
          right: 20.w,
          bottom: 10.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top 10 rank banner
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svgs/top_10_icon.svg',
                    height: 22.h,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '#2 in Nigeria Today',
                    style: AppStyle.tss14W700.copyWith(
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // My List Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added "${movie.title}" to My List')),
                      );
                    },
                    child: SizedBox(
                      width: 80.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/my_list_plus.svg',
                            width: 22.w,
                            height: 22.h,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'My List',
                            style: AppStyle.tss14W400.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Play Button (White container with black text/icon)
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/play_button.svg',
                            width: 18.w,
                            height: 18.h,
                            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Play',
                            style: AppStyle.tss20W600.copyWith(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Info Button
                  GestureDetector(
                    onTap: onTap,
                    child: SizedBox(
                      width: 80.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/info.svg',
                            width: 22.w,
                            height: 22.h,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Info',
                            style: AppStyle.tss14W400.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
