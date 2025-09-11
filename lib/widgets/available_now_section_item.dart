import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/movies_model.dart';
import '../screens/movie_details/movie_details_screen.dart';

class AvailableNowSectionItem extends StatelessWidget {
  final bool isSelected;
  final Movies movie;
  const AvailableNowSectionItem({
    super.key,
    required this.isSelected,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        shape: BoxShape.rectangle,
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 3.w,
        ),
      ),
      child: Stack(
        children: [
          SizedBox.expand(
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailsScreen(movieId: movie.id??550),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 150),
                  scale: isSelected ? 1 : 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Image.network(
                      movie.largeCoverImage ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: isSelected ? 12.w : 24.w,
              left: isSelected ? 10.h : 20.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withAlpha(80),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${movie.rating} ",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(fontSize: 16.sp),
                ),
                Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
