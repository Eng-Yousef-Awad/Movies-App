abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {
  final List movies;
  SearchSuccessState(this.movies);
}

class SearchErrorState extends SearchStates {
  final String error;
  SearchErrorState(this.error);
}
