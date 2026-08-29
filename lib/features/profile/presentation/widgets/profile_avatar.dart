import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_style.dart';

class ProfileAvatarItem extends StatelessWidget {
  final String name;
  final String imageAsset;
  final VoidCallback onTap;

  const ProfileAvatarItem({
    super.key,
    required this.name,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: Image.asset(
              imageAsset,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: AppStyle.tss12W400.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class AddProfileAvatarItem extends StatelessWidget {
  final VoidCallback onTap;

  const AddProfileAvatarItem({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.grey.shade800, width: 1.5.w),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/plus_plane.svg',
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '',
            style: AppStyle.tss12W400.copyWith(color: Colors.transparent),
          ),
        ],
      ),
    );
  }
}
