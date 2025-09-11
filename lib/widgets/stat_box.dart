import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatBox extends StatelessWidget {
  final String icon;
  final String? value;
  final BuildContext context;

  const StatBox({
    required this.icon,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext ctx) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImageIcon(
            AssetImage(icon),
            color: Theme.of(context).colorScheme.primary,
            size: 28.sp,
          ),
          Text(
            value ?? "NA",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}