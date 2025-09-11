import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/bloc/profile_tab_cubit/profile_cubit.dart';
import 'package:movies_app/bloc/profile_tab_cubit/profile_states.dart';
import 'package:movies_app/mapper/movie_details_to_list.dart';
import 'package:movies_app/models/movie_details.dart';
import 'package:movies_app/repository/home_repo_imp.dart';
import 'package:movies_app/screens/home/update_profile/update_profile.dart';
import 'package:movies_app/screens/Auth/login_screen.dart';
import 'package:movies_app/screens/movie_details/movie_details_screen.dart';
import '../../../widgets/profile_stat_box.dart';
import '../../../widgets/movie_card.dart';

class ProfileTab extends StatelessWidget {
  static const routeName = "/profile";
  const ProfileTab({super.key});

  Future<Movie?> _fetchMovie(int id) async {
    try {
      final repo = HomeRepoImpelementation();
      final response = await repo.getMovieDetails(id);
      return response.data?.movie;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoggedOut) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileLoggedOut || state is ProfileDeleted) {
          return const Scaffold(body: Center(child: Text("No Profile Data")));
        }

        if (state is ProfileInitial || state is ProfileUpdated) {
          final watchList = state.watchLater;
          final history = state.history;

          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 60.h,
                        left: 16.w,
                        right: 16.w,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60.r,
                                backgroundImage: state.avatar.isNotEmpty
                                    ? (state.avatar.startsWith("assets/")
                                          ? AssetImage(state.avatar)
                                                as ImageProvider
                                          : NetworkImage(state.avatar))
                                    : const AssetImage(
                                        "assets/images/profile.png",
                                      ),
                              ),
                              SizedBox(width: 30.w),
                              StatProfile(
                                value: "${watchList.length}",
                                label: "Watch List",
                              ),
                              SizedBox(width: 25.w),
                              StatProfile(
                                value: "${history.length}",
                                label: "History",
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                state.name,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall!.fontSize?.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<ProfileCubit>(),
                                          child: const UpdateProfile(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Edit Profile",
                                    style: GoogleFonts.roboto(
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall!.fontSize?.sp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                flex: 1,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.error,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<ProfileCubit>().logout();
                                  },
                                  icon: Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                    size: 22.sp,
                                  ),
                                  label: Text(
                                    "Exit",
                                    style: GoogleFonts.roboto(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontSize: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall!.fontSize?.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            labelStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                            tabs: [
                              Tab(
                                icon: Icon(Icons.list_alt, size: 35.sp),
                                child: Text(
                                  "Watch List",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              Tab(
                                icon: Icon(
                                  Icons.folder,
                                  size: 35.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Text(
                                  "History",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: TabBarView(
                        children: [
                          watchList.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    "assets/images/no_movies.png",
                                    width: 125.w,
                                    height: 125.h,
                                  ),
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.all(12.w),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.w,
                                        mainAxisSpacing: 12.h,
                                        childAspectRatio: 0.7,
                                      ),
                                  itemCount: watchList.length,
                                  itemBuilder: (context, index) {
                                    final movieId = watchList[index];
                                    return FutureBuilder<Movie?>(
                                      future: _fetchMovie(movieId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return const Icon(Icons.error);
                                        }
                                        final movie = snapshot.data!;
                                        return MovieCard(
                                          movie: movie.toMoviesModel(),
                                          onTap: (id) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    MovieDetailsScreen(
                                                      movieId: id,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                          history.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    "assets/images/no_movies.png",
                                    width: 125.w,
                                    height: 125.h,
                                  ),
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.all(12.w),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12.w,
                                        mainAxisSpacing: 12.h,
                                        childAspectRatio: 0.7,
                                      ),
                                  itemCount: history.length,
                                  itemBuilder: (context, index) {
                                    final movieId = history[index];
                                    return FutureBuilder<Movie?>(
                                      future: _fetchMovie(movieId),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return const Icon(Icons.error);
                                        }
                                        final movie = snapshot.data!;
                                        return MovieCard(
                                          movie: movie.toMoviesModel(),
                                          onTap: (id) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    MovieDetailsScreen(
                                                      movieId: id,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text("Unknown State")));
      },
    );
  }
}
