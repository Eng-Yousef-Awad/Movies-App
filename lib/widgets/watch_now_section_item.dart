import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/bloc/app_cubit/app_cubit.dart';
import 'package:movies_app/bloc/explore_tab_cubit/explore_cubit.dart';
import 'package:movies_app/bloc/home_tab_cubit/home_cubit.dart';

import 'movie_list_item.dart';

class WatchNowSectionItem extends StatelessWidget {
  int sectionIndex;
  HomeCubit cubit;
  WatchNowSectionItem({
    super.key,
    required this.sectionIndex,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    var movies = cubit.categoryMovies[cubit.genres[sectionIndex]]?.data!.movies;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cubit.genres[sectionIndex],
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AppCubit>().changeTab(2);
                  context.read<ExploreCubit>().changeCategoryIndex(sectionIndex);

                },
                child: Text(
                  "See More ➔",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies?.length ?? 0,
            itemBuilder: (context, index) {
              final movie = movies?[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: SizedBox(
                  width: 146.w,
                  height: 220.h,
                  child: movie == null
                      ? SizedBox.shrink()
                      : MovieListItem(movie: movie),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
