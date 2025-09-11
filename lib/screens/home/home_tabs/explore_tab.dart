import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/bloc/explore_tab_cubit/explore_states.dart';
import '../../../bloc/explore_tab_cubit/explore_cubit.dart';
import '../../../widgets/movie_list_item.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreCubit,ExploreStates>(
      builder: (BuildContext context, state) {
        ExploreCubit cubit = BlocProvider.of<ExploreCubit>(context);
        if(state is ExploreGetCategoryMoviesLoadingState){
          return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,));
        }
        else if(state is ExploreGetCategoryMoviesErrorState){
          return Center(child: Text("Something went wrong!",style: Theme.of(context).textTheme.headlineSmall,));
        }
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: cubit.genres.length,
                    itemBuilder: (context, index){
                      bool isSelected = index == cubit.currentCategoryIndex;
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          cubit.changeCategoryIndex(index);
                        },
                        child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3
                          ),

                        ),
                        child: Text(cubit.genres[index] ,style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: isSelected ? Colors.black : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold
                        ),),
                                            ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 10),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final movie = cubit.categoryMovies[cubit.genres[cubit.currentCategoryIndex]]?.data?.movies?[index];
                    return movie == null ? SizedBox.shrink() :
                    MovieListItem(movie: movie);
                  },
                  childCount: cubit.categoryMovies[cubit.genres[cubit.currentCategoryIndex]]?.data?.movies?.length ?? 0,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 20.w,
                  childAspectRatio: 0.7,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20.h),
              ),
              ],
          ),
        );
      },
    );
  }
}
