import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_styles.dart';

class FontStyles implements MainStyles {
  TextStyle _getFont(
      Color color,
      double fontSize,
      FontWeight fontWeight, {
        double? height,
      }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  @override
  TextStyle h1(BuildContext context, Color color) =>
      _getFont(color, 36.sp, FontWeight.w500);

  @override
  TextStyle h2(BuildContext context, Color color) =>
      _getFont(color, 24.sp, FontWeight.bold);

  @override
  TextStyle h3(BuildContext context, Color color) =>
      _getFont(color, 22.sp, FontWeight.bold);

  @override
  TextStyle h4(BuildContext context, Color color) =>
      _getFont(color, 20.sp, FontWeight.bold);

  @override
  TextStyle h5(BuildContext context, Color color) =>
      _getFont(color, 18.sp, FontWeight.bold);

  @override
  TextStyle h6(BuildContext context, Color color) =>
      _getFont(color, 16.sp, FontWeight.bold);

  @override
  TextStyle bodyXLargeBold(BuildContext context, Color color) =>
      _getFont(color, 24.sp, FontWeight.bold);

  @override
  TextStyle bodyXLargeMedium(BuildContext context, Color color) =>
      _getFont(color, 24.sp, FontWeight.w500, height: 1.5);

  @override
  TextStyle bodyXLargeRegular(BuildContext context, Color color) =>
      _getFont(color, 24.sp, FontWeight.normal, height: 1.3);

  @override
  TextStyle bodyLargeBold(BuildContext context, Color color) =>
      _getFont(color, 20.sp, FontWeight.bold, height: 1.3);

  @override
  TextStyle bodyLargeMedium(BuildContext context, Color color) =>
      _getFont(color, 20.sp, FontWeight.w500, height: 13);

  @override
  TextStyle bodyLargeRegular(BuildContext context, Color color) =>
      _getFont(color, 20.sp, FontWeight.normal, height: 1.3);

  @override
  TextStyle bodyMediumBold(BuildContext context, Color color) =>
      _getFont(color, 14.sp, FontWeight.bold, height: 1.6);

  @override
  TextStyle bodyMediumMedium(BuildContext context, Color color) =>
      _getFont(color, 14.sp, FontWeight.w500, height: 1.6);

  @override
  TextStyle bodyMediumRegular(BuildContext context, Color color) =>
      _getFont(color, 14.sp, FontWeight.normal, height: 1.6);

  @override
  TextStyle bodySmallBold(BuildContext context, Color color) =>
      _getFont(color, 12.sp, FontWeight.bold, height: 1.6);

  @override
  TextStyle bodySmallMedium(BuildContext context, Color color) =>
      _getFont(color, 12.sp, FontWeight.w500, height: 1.45);

  @override
  TextStyle bodySmallRegular(BuildContext context, Color color) =>
      _getFont(color, 12.sp, FontWeight.normal, height: 1.45);

  @override
  TextStyle bodyXSmallBold(BuildContext context, Color color) =>
      _getFont(color, 12.sp, FontWeight.bold);

  @override
  TextStyle bodyXSmallMedium(BuildContext context, Color color) =>
      _getFont(color, 12.sp, FontWeight.w500);

  @override
  TextStyle bodyXSmallRegular(BuildContext context, Color color) =>
      _getFont(color, 12.sp, FontWeight.normal);
}
