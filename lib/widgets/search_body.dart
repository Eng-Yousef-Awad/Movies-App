import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/search_tab_cubit/search_states.dart';
import 'movie_card.dart';

class SearchBody extends StatelessWidget {
  final SearchStates state;
  final String query;
  final Function(int movieId)? onMovieTap;

  const SearchBody({
    super.key,
    required this.state,
    required this.query,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return _EmptyState(imagePath: 'assets/images/no_movies.png');
    }

    if (state is SearchLoadingState) {
      return const _LoadingState();
    } else if (state is SearchErrorState) {
      return _ErrorState(message: (state as SearchErrorState).error);
    } else if (state is SearchSuccessState) {
      final movies = (state as SearchSuccessState).movies;
      if (movies.isEmpty) {
        return const _EmptyState(
          imagePath: 'assets/images/no_movies.png',
          message: "No movies found.",
        );
      }
      return GridView.builder(
        padding: EdgeInsets.all(10.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 0.65,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return MovieCard(movie: movie, onTap: onMovieTap);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50.w,
        height: 50.h,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Error: $message", style: TextStyle(fontSize: 16.sp)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String imagePath;
  final String message;

  const _EmptyState({required this.imagePath, this.message = ""});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 150.w, height: 150.h),
          if (message.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(message, style: TextStyle(fontSize: 16.sp)),
          ],
        ],
      ),
    );
  }
}
