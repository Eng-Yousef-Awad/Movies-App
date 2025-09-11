import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/bloc/search_tab_cubit/search_cubit.dart';
import 'package:movies_app/bloc/search_tab_cubit/search_states.dart';
import 'package:movies_app/repository/home_repo_imp.dart';
import 'package:movies_app/screens/movie_details/movie_details_screen.dart';
import 'package:movies_app/widgets/search_body.dart';
import 'package:movies_app/bloc/movie_details_cubit/movie_details_cubit.dart';

class SearchTab extends StatefulWidget {
  static const routeName = '/search';
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchCubit>().searchMovies(query);
    });
  }

  void _onMovieTap(int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) =>
              MovieDetailsCubit(HomeRepoImpelementation())
                ..getMovieDetails(movieId: movieId),
          child: MovieDetailsScreen(movieId: movieId),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchStates>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: Icon(Icons.search, size: 24.w),
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    onChanged: _onSearchChanged,
                  ),
                ),
                Expanded(
                  child: SearchBody(
                    state: state,
                    query: _controller.text,
                    onMovieTap: _onMovieTap,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
