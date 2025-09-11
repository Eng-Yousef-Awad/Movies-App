
import 'package:bloc/bloc.dart';
import 'package:movies_app/bloc/home_tab_cubit/home_states.dart';
import '../../constants/app_constants.dart';
import '../../models/movies_model.dart';
import '../../repository/home_repo.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeRepo homeRepo;
  HomeCubit(this.homeRepo) : super(HomeInitialState());

  int selectedMovie=0;
  MoviesModel ? moviesResponse;
  List<String> genres = AppConstants.genres;
  Map<String, MoviesModel> categoryMovies = {};

  void changeSelectedMovie(int index){
    selectedMovie = index;
    emit(HomeChangeSelectedMovieState());
  }
  void getMovies()async{
    emit(HomeGetMoviesLoadingState());
    try{
      moviesResponse = await homeRepo.getMovies();
      emit(HomeGetMoviesSuccessState());
    }catch(e){
      emit(HomeGetMoviesErrorState());
    }
  }
  void getAllCategoriesMovies()async{
    emit(HomeGetCategoryMoviesLoadingState());
    try{
      final futures = genres.map((genre) async {
        final response = await homeRepo.getCategoryMovies(genre);
        categoryMovies[genre] = response;
      }).toList();
      await Future.wait(futures);
      emit(HomeGetCategoryMoviesSuccessState());
    }catch(e){
      emit(HomeGetCategoryMoviesErrorState());
      print(e);
    }
  }




}