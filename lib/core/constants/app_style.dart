import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyle {
  AppStyle._();

  static const String fontFamily = 'SF Pro Display';

  // Responsive styles with font size and weight
  static TextStyle get tss14W400 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get tss14W700 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get tss15W400 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get tss20W600 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get tss20W700 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get tss26W700 => TextStyle(
        fontFamily: fontFamily,
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
      );

  // Weight-only styles (fallbacks to default font size)
  static const TextStyle tssW300 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle tssW400 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle tssW500 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tssW700 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle tssW800 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle tssW900 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w900,
  );
}
