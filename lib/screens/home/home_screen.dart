import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/bloc/profile_tab_cubit/profile_cubit.dart';
import 'package:movies_app/repository/home_repo.dart';
import 'package:movies_app/repository/home_repo_imp.dart';
import '../../bloc/app_cubit/app_cubit.dart';
import '../../bloc/app_cubit/app_states.dart';
import '../../bloc/explore_tab_cubit/explore_cubit.dart';
import '../../bloc/home_tab_cubit/home_cubit.dart';
import '../../bloc/search_tab_cubit/search_cubit.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  HomeScreen({super.key});
  HomeRepo repo = HomeRepoImpelementation();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppCubit()),
        BlocProvider(
          create: (context) => HomeCubit(repo)
            ..getMovies()
            ..getAllCategoriesMovies(),
        ),
        BlocProvider(
          create: (context) => ExploreCubit(repo)..getCurrentCategoryMovie(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(repo)..getInitialMovies(),
        ),
        BlocProvider(create: (context) => ProfileCubit()),
      ],
      child: BlocBuilder<AppCubit, AppStates>(
        builder: (BuildContext context, state) {
          final cubit = BlocProvider.of<AppCubit>(context);
          return Scaffold(
            bottomNavigationBar: BottomNavBar(),
            body: IndexedStack(
              index: cubit.currentTab,
              children: cubit.screens,
            ),
          );
        },
      ),
    );
  }
}
