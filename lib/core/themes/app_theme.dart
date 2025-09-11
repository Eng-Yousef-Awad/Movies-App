import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/app_colors.dart';
import '../colors/main_colors.dart';
import '../styles/font_styles.dart';
import '../styles/main_styles.dart';

class AppTheme {
  static ThemeData getTheme({required BuildContext context}) {
    final MainColors colors = AppColors();
    final MainStyles font = FontStyles();

    return ThemeData(
      scaffoldBackgroundColor: colors.backgroundColor,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colors.primary1,
        onPrimary: colors.textColor,
        secondary: colors.secondaryBackgroundColor,
        onSecondary: colors.textColor2,
        tertiary: colors.primary1,
        onTertiary: colors.primary2,
        error: colors.error,
        onError: colors.textColor,
        surface: colors.secondaryBackgroundColor,
        onSurface: colors.textColor2,
      ),
      textTheme: TextTheme(
        displayLarge: font.bodyLargeBold(context, colors.textColor),
        displayMedium: font.bodyMediumMedium(context, colors.textColor),
        displaySmall: font.bodySmallRegular(context, colors.textColor),
        headlineMedium: font.bodyXLargeBold(context, colors.textColor),
        headlineSmall: font.bodyLargeRegular(context, colors.textColor),
        titleLarge: font.h1(context, colors.textColor),
        bodyLarge: font.bodyXLargeBold(context, colors.textColor),
        bodyMedium: font.bodyXLargeMedium(context, colors.textColor),
        titleMedium: font.h4(context, colors.textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          textStyle: Theme.of(context).textTheme.titleMedium,
          backgroundColor: colors.primary1,
          foregroundColor: colors.textColor2,
          side: BorderSide(color: colors.primary1, width: 2.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0.w),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colors.secondaryBackgroundColor,
        filled: true,
        prefixIconColor: colors.textColor,
        prefixIconConstraints: BoxConstraints(
          minWidth: 50,
          minHeight: 50,
        ),
        suffixIconColor: colors.textColor,
        hintStyle: GoogleFonts.roboto(
          textStyle: Theme.of(context).textTheme.titleMedium,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: colors.textColor
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.secondaryBackgroundColor,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colors.primary1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: font.h6(context, colors.primary1),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.backgroundColor),
    );
  }
}
