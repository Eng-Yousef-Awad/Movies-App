import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/home_tab_cubit/home_cubit.dart';
import '../../../bloc/home_tab_cubit/home_states.dart';
import '../../../models/movies_model.dart';
import '../../../widgets/available_now_section_item.dart';
import '../../../widgets/watch_now_section_item.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (BuildContext context, state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        List<Movies> movies = cubit.moviesResponse?.data?.movies ?? [];
        if (state is HomeGetMoviesLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else if (state is HomeGetMoviesErrorState) {
          return Center(
            child: Text(
              "Something went wrong!",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        }
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/home_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 25.h)),
              SliverToBoxAdapter(
                child: Image.asset(
                  'assets/images/available_now.png',
                  fit: BoxFit.contain,
                  width: 276.w,
                  height: 93.h,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: CarouselSlider.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index, realIndex) {
                    final isSelected = index == cubit.selectedMovie;
                    Movies movie = movies[index];
                    return AvailableNowSectionItem(
                      movie: movie,
                      isSelected: isSelected,
                    );
                  },
                  options: CarouselOptions(
                    height: 400.h,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.6,
                    pageSnapping: true,
                    onPageChanged: (index, reason) {
                      cubit.changeSelectedMovie(index);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: Image.asset(
                  'assets/images/watch_now.png',
                  fit: BoxFit.contain,
                  width: 276.w,
                  height: 93.h,
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverList.separated(
                itemCount: cubit.genres.length,
                separatorBuilder: (context, index) => SizedBox(height: 20.h),
                itemBuilder: (context, sectionIndex) {
                  return WatchNowSectionItem(
                    sectionIndex: sectionIndex,
                    cubit: cubit,
                  );
                },
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        );
      },
    );
  }
}
