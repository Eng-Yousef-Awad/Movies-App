import 'package:bloc/bloc.dart';
import '../../constants/app_constants.dart';
import '../../models/movies_model.dart';
import '../../repository/home_repo.dart';
import 'explore_states.dart';

class ExploreCubit extends Cubit<ExploreStates> {
  HomeRepo homeRepo;
  ExploreCubit(this.homeRepo) : super(ExploreInitialState());
  List<String> genres = AppConstants.genres;
  int currentCategoryIndex = 0;
  Map<String, MoviesModel> categoryMovies = {};

  void getCurrentCategoryMovie() async {
    final genre = genres[currentCategoryIndex];
    if (categoryMovies.containsKey(genre) && categoryMovies[genre] != null) {
      emit(ExploreGetCategoryMoviesSuccessState());
      return;
    }
    emit(ExploreGetCategoryMoviesLoadingState());
    try {
      final response = await homeRepo.getCategoryMovies(
        genres[currentCategoryIndex],
        limit: 50,
      );
      categoryMovies[genres[currentCategoryIndex]] = response;
      emit(ExploreGetCategoryMoviesSuccessState());
    } catch (e) {
      emit(ExploreGetCategoryMoviesErrorState());
    }
  }

  void changeCategoryIndex(int index) {
    currentCategoryIndex = index;
    getCurrentCategoryMovie();
    emit(ExploreChangeCategoryIndexState());
  }
}
