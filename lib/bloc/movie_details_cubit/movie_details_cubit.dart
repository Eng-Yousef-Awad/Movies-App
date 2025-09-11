import 'package:bloc/bloc.dart';
import '../../firebase/firebasemanger.dart';
import '../../models/movie_details.dart';
import '../../models/movies_suggestions.dart';
import '../../repository/home_repo.dart';
import 'movie_details_states.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsStates> {
  HomeRepo homeRepo;
  MovieDetailsCubit(this.homeRepo) : super(MovieDetailsInitialState());

  bool isSavedToWatchlist = false;
  MovieDetailsModel? movieDetailsResponse;
  SuggestedMoviesModel? similarMoviesResponse;

  Future<void> getMovieDetails({required int movieId}) async {
    emit(MovieDetailsGetLoadingState());
    try {
      movieDetailsResponse = await homeRepo.getMovieDetails(movieId);

      if (movieDetailsResponse?.data?.movie?.id != null) {
        isSavedToWatchlist = await FirebaseManager.isInWatchLater(
          movieDetailsResponse!.data!.movie!.id!,
        );
      }

      emit(MovieDetailsGetSuccessState());
    } catch (e) {
      emit(MovieDetailsGetErrorState());
    }
  }

  Future<void> getSimilarMovies({required int movieId}) async {
    emit(MovieDetailsGetSimilarLoadingState());
    try {
      similarMoviesResponse = await homeRepo.getSimilarMovie(movieId);
      emit(MovieDetailsGetSimilarSuccessState());
    } catch (e) {
      emit(MovieDetailsGetSimilarErrorState());
    }
  }

  Future<void> toggleWatchlistStatus() async {
    if (movieDetailsResponse?.data?.movie?.id == null) return;

    final movieId = movieDetailsResponse!.data!.movie!.id!;
    if (isSavedToWatchlist) {
      await FirebaseManager.removeFromWatchLater(movieId);
      isSavedToWatchlist = false;
    } else {
      await FirebaseManager.addToWatchLater(movieId);
      isSavedToWatchlist = true;
    }

    emit(MovieDetailsWatchlistToggledState());
  }

  void addToHistory() {
    if (movieDetailsResponse?.data?.movie?.id == null) return;
    FirebaseManager.addToHistory(movieDetailsResponse!.data!.movie!.id!);
    emit(MovieDetailsAddToHistoryState());
  }
}
