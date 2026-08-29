import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_style.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get heading1 => AppStyle.tssW700.copyWith(
        fontSize: 28.sp,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading2 => AppStyle.tssW700.copyWith(
        fontSize: 22.sp,
        color: AppColors.textPrimary,
        height: 1.25,
      );

  static TextStyle get heading3 => AppStyle.tssW500.copyWith(
        fontSize: 18.sp,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get titleLarge => AppStyle.tssW500.copyWith(
        fontSize: 16.sp,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => AppStyle.tssW400.copyWith(
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => AppStyle.tssW400.copyWith(
        fontSize: 13.sp,
        color: AppColors.textSecondary,
      );

  static TextStyle get bodySmall => AppStyle.tssW400.copyWith(
        fontSize: 11.sp,
        color: AppColors.textMuted,
      );

  static TextStyle get caption => AppStyle.tssW500.copyWith(
        fontSize: 10.sp,
        color: AppColors.textMuted,
      );

  static TextStyle get button => AppStyle.tssW500.copyWith(
        fontSize: 14.sp,
        color: AppColors.textPrimary,
      );
}
