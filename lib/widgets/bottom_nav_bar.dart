import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/app_cubit/app_cubit.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.w,
        right: 8.w,
        bottom: 20.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem("home_ic", 0, context: context),
            _buildNavItem("search_ic", 1, context: context),
            _buildNavItem("explore_ic", 2, context: context),
            _buildNavItem("profile_ic", 3, context: context),
          ],
        ),
      ),
    );
  }
  Widget _buildNavItem(String Img, int index, {required BuildContext context}) {
    final cubit = BlocProvider.of<AppCubit>(context);
    return GestureDetector(
      onTap: () {
        cubit.changeTab(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ImageIcon(
          AssetImage("assets/icons/$Img.png"),
          color: cubit.currentTab != index
              ? Colors.white
              : Theme.of(context).colorScheme.primary,
          size: 24.sp,
        ),
      ),
    );
  }
}
