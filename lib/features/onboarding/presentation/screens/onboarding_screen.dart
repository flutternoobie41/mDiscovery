import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onGetStarted;

  const OnboardingScreen({
    super.key,
    required this.onGetStarted,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Widget _buildProfile(String imagePath, String name) {
    return GestureDetector(
      onTap: widget.onGetStarted,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image.asset(
              imagePath,
              width: 100.w,
              height: 100.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            name,
            style: AppTypography.bodyMedium.copyWith(
              color: const Color(0xFFE5E5E5),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 20.h),
          // Top Bar
          Container(
            width: double.infinity,
            height: 48.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/logos_netflix.png',
                  width: 110.w,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/svgs/edit_pencil.svg',
                      width: 18.w,
                      height: 18.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
          // Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 54.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProfile('assets/images/rectangle1.jpg', 'Emenalo'),
                    _buildProfile('assets/images/rectangle2.jpg', 'Onyeka'),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildProfile('assets/images/rectangle3.jpg', 'Thelma'),
                    _buildProfile('assets/images/kids_rectangle.jpg', 'Kids'),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
          // Add Profile Button
          GestureDetector(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svgs/plus_circle.svg',
                  width: 50.w,
                  height: 50.w,
                ),
                SizedBox(height: 14.h),
                Text(
                  'Add Profile',
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFFE5E5E5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
