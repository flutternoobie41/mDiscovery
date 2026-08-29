import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_style.dart';

class ProfileMenuItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: InkWell(
        onTap: onTap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: AppStyle.tss30W500.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
