import 'dart:ui';

import 'package:flutter/material.dart';

import 'main_colors.dart';

class AppColors implements MainColors {
  @override
  Color get backgroundColor => const Color(0xff121312);

  @override
  Color get secondaryBackgroundColor => const Color(0xff212121);

  @override
  Color get textColor => const Color(0xffFFFFFF);

  @override
  Color get textColor2 => const Color(0xff121312);

  @override
  Color get textColor3 => const Color(0xffFFFFFF);

  @override
  Color get primary1 => const Color(0xffF6BD00); // Lightest

  @override
  Color get primary2 => const Color(0xffF6BD00); // Lighter

  @override
  Color get primary3 => const Color(0xFFF2FEFF); // Light

  @override
  Color get primary4 => const Color(0xFF5669FF); // Normal

  @override
  Color get primary5 => const Color(0xFF3A4BFF); // Dark

  @override
  Color get primary6 => const Color(0xFF2A3BFF); // Darker

  @override
  Color get secondary => const Color(0xff282A28); // Teal

  @override
  Color get warning => const Color(0xFFFFA000); // Amber

  @override
  Color get error => const Color(0xFFE82626);
}
