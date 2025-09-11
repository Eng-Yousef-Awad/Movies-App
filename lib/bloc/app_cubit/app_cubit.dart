import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:movies_app/bloc/app_cubit/app_states.dart';
import '../../screens/home/home_tabs/explore_tab.dart';
import '../../screens/home/home_tabs/home_tab.dart';
import '../../screens/home/home_tabs/profile_tab.dart';
import '../../screens/home/home_tabs/search_tab.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  List<Widget> screens = [HomeTab(), SearchTab(), ExploreTab(), ProfileTab()];
  int currentTab = 0;
  void changeTab(int index,{String genre = ''}) {
    currentTab = index;
    emit(AppChangeTabState());
  }

  void onSeeMoreTapped(String genre){
    changeTab(2);
    emit(HomeSeeMoreTappedState());
  }
}
