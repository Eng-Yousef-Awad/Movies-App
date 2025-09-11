import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/repository/home_repo.dart';
import 'package:movies_app/repository/home_repo_imp.dart';
import '../../bloc/movie_details_cubit/movie_details_cubit.dart';
import '../../bloc/movie_details_cubit/movie_details_states.dart';
import '../../models/movie_details.dart';
import '../../models/movies_suggestions.dart';
import '../../widgets/loader_with_timeout.dart';
import '../../widgets/similar_movie_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/torrent_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    HomeRepo repo = HomeRepoImpelementation();
    return BlocProvider(
      create: (context) => MovieDetailsCubit(repo)
        ..getMovieDetails(movieId: movieId)
        ..getSimilarMovies(movieId: movieId),
      child: BlocBuilder<MovieDetailsCubit, MovieDetailsStates>(
        builder: (context, state) {
          final cubit = context.read<MovieDetailsCubit>();
          final MovieDetailsModel? movie = cubit.movieDetailsResponse;
          final List<Movies>? similarMovies =
              cubit.similarMoviesResponse?.data?.movies;

          print(
            "--------------------------- id :$movieId --------------------",
          );

          if (state is MovieDetailsGetSuccessState &&
              movie?.data?.movie?.id != null) {
            cubit.addToHistory();
          }

          List<String?> screenshots = [
            movie?.data?.movie?.mediumScreenshotImage1,
            movie?.data?.movie?.mediumScreenshotImage2,
            movie?.data?.movie?.mediumScreenshotImage3,
          ];
          List<String?> castNames = [
            for (var actor in movie?.data?.movie?.cast ?? []) actor.name,
          ];
          List<String?> castImg = [
            for (var actor in movie?.data?.movie?.cast ?? [])
              actor.urlSmallImage,
          ];
          List<String?> castCharacters = [
            for (var actor in movie?.data?.movie?.cast ?? [])
              actor.characterName,
          ];
          List<String?> genres = [
            for (var genre in movie?.data?.movie?.genres ?? []) genre,
          ];

          if (state is MovieDetailsGetLoadingState ||
              state is MovieDetailsGetSimilarLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is MovieDetailsGetErrorState) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error occurred while fetching movie details"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Back To Home"),
                  ),
                ],
              ),
            );
          }

          if (movie == null) {
            return const Scaffold(body: Center(child: LoaderWithTimeout()));
          }

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                // Cover section
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                movie.data?.movie?.largeCoverImage ??
                                    "https://placehold.co/400",
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width: double.infinity,
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      const Color(0xff121312).withOpacity(0.1),
                                      const Color(0xff121312).withOpacity(0.3),
                                      const Color(0xff121312).withOpacity(0.8),
                                      const Color(0xff121312).withOpacity(0.9),
                                      const Color(0xff121312).withOpacity(1),
                                    ],
                                  ),
                                ),
                              ),
                              Image.asset("assets/icons/play_ic.png"),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 8.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Text(
                                  movie.data?.movie?.title ?? "no Title",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                movie.data?.movie?.year.toString() ?? "NA",
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 40.h,
                        left: 16.w,
                        right: 16.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const ImageIcon(
                                AssetImage("assets/icons/arr_back_ic.png"),
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            IconButton(
                              icon: ImageIcon(
                                const AssetImage("assets/icons/save_ic.png"),
                                color: cubit.isSavedToWatchlist
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,
                              ),
                              onPressed: () {
                                cubit.toggleWatchlistStatus();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                // Watch button and stats
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 16.h,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  side: BorderSide.none,
                                ),
                                child: Text(
                                  "Watch",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TorrentButton(
                                torrentUrl:
                                    movie.data?.movie?.torrents?[0].url ?? "",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        child: Row(
                          spacing: 8.w,
                          children: [
                            Expanded(
                              child: StatBox(
                                icon: "assets/icons/like_ic.png",
                                value: movie.data?.movie?.likeCount.toString(),
                              ),
                            ),
                            // Runtime
                            Expanded(
                              child: StatBox(
                                icon: "assets/icons/watch_ic.png",
                                value: movie.data?.movie?.runtime.toString(),
                              ),
                            ),
                            // Rating
                            Expanded(
                              child: StatBox(
                                icon: "assets/icons/star_ic.png",
                                value: movie.data?.movie?.rating.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                // Screen Shots
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          "Screen Shots",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemBuilder: (context, index) {
                          final screenshotUrl =
                              (screenshots[index] != null &&
                                  screenshots[index]!.isNotEmpty)
                              ? screenshots[index]!
                              : "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png";

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.network(
                              screenshotUrl,
                              fit: BoxFit.cover,
                              height: 167.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
                                  fit: BoxFit.cover,
                                  height: 167.h,
                                );
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemCount: screenshots.length,
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                // Similar Movies
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (similarMovies == null || similarMovies.isEmpty) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "No similar movies available",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "Similar",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16.h,
                                  crossAxisSpacing: 16.w,
                                  childAspectRatio: 0.7,
                                ),
                            itemBuilder: (context, index) {
                              return SimilarMovieItem(
                                movie: similarMovies[index],
                              );
                            },
                            itemCount: similarMovies.length,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                // Summary
                if (movie.data!.movie!.descriptionFull!.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Summary",
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            movie.data?.movie?.descriptionFull ?? "",
                            style: Theme.of(context).textTheme.displayMedium!
                                .copyWith(fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                ],
                // Cast
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          "Cast",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: 8.h,
                              horizontal: 8.w,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(
                                    (castImg[index] != null &&
                                            castImg[index]!.isNotEmpty)
                                        ? castImg[index]!
                                        : "https://placehold.co/100x100.png",
                                    width: 70.w,
                                    height: 70.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        "https://placehold.co/70*70.png",
                                        width: 70.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        "Name : ${castNames[index]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        "Character : ${castCharacters[index]}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemCount: castNames.length,
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                // Genres
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Genres",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16.h,
                                crossAxisSpacing: 16.w,
                                childAspectRatio: 10 / 4,
                              ),
                          itemCount: genres.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Text(
                                genres[index] ?? "",
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String icon;
  final String? value;

  const StatBox({super.key, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
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
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
