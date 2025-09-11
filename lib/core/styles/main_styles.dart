import 'package:flutter/material.dart';

abstract class MainStyles {
  TextStyle h1(BuildContext context, Color color);
  TextStyle h2(BuildContext context, Color color);
  TextStyle h3(BuildContext context, Color color);
  TextStyle h4(BuildContext context, Color color);
  TextStyle h5(BuildContext context, Color color);
  TextStyle h6(BuildContext context, Color color);

  TextStyle bodyXLargeBold(BuildContext context, Color color);
  TextStyle bodyXLargeMedium(BuildContext context, Color color);
  TextStyle bodyXLargeRegular(BuildContext context, Color color);

  TextStyle bodyLargeBold(BuildContext context, Color color);
  TextStyle bodyLargeMedium(BuildContext context, Color color);
  TextStyle bodyLargeRegular(BuildContext context, Color color);

  TextStyle bodyMediumBold(BuildContext context, Color color);
  TextStyle bodyMediumMedium(BuildContext context, Color color);
  TextStyle bodyMediumRegular(BuildContext context, Color color);

  TextStyle bodySmallBold(BuildContext context, Color color);
  TextStyle bodySmallMedium(BuildContext context, Color color);
  TextStyle bodySmallRegular(BuildContext context, Color color);

  TextStyle bodyXSmallBold(BuildContext context, Color color);
  TextStyle bodyXSmallMedium(BuildContext context, Color color);
  TextStyle bodyXSmallRegular(BuildContext context, Color color);
}
