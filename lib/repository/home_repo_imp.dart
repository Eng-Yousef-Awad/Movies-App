import 'package:movies_app/models/movie_details.dart';
import 'package:movies_app/models/movies_suggestions.dart';
import 'package:movies_app/repository/home_repo.dart';

import '../api/api_manager.dart';
import '../constants/end_points.dart';
import '../models/movies_model.dart';

class HomeRepoImpelementation implements HomeRepo {
  ApiManager apiManager = ApiManager();

  @override
  Future<MoviesModel> getMovies() async {
    try {
      var response = await apiManager.getApi(
        endPoint: ApiUrls.listMoviesEndpoint,
        parameters: {'limit': 10, "sort_by": "year", "order_by": "desc"},
      );
      MoviesModel result = MoviesModel.fromJson(response.data);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MoviesModel> getCategoryMovies(String genre, {int limit = 10}) async {
    try {
      var response = await apiManager.getApi(
        endPoint: ApiUrls.listMoviesEndpoint,
        parameters: {
          'limit': limit,
          "sort_by": "year",
          "order_by": "desc",
          "genre": genre,
        },
      );
      MoviesModel result = MoviesModel.fromJson(response.data);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MoviesModel> searchMovies(String query, {int limit = 20}) async {
    try {
      var response = await apiManager.getApi(
        endPoint: ApiUrls.listMoviesEndpoint,
        parameters: {
          'query_term': query, // yts API uses 'query_term' for search
          'limit': limit,
          "sort_by": "year",
          "order_by": "desc",
        },
      );
      MoviesModel result = MoviesModel.fromJson(response.data);
      return result;
    } catch (e) {
      print("$e");
      rethrow;
    }
  }

  @override
  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    try {
      var response = await apiManager.getApi(
        endPoint: ApiUrls.movieDetailsEndpoint,
        parameters: {
          'movie_id': movieId,
          'with_images': true,
          'with_cast': true,
        },
      );
      MovieDetailsModel result = MovieDetailsModel.fromJson(response.data);
      print("sucess");
      return result;
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }

  @override
  Future<SuggestedMoviesModel> getSimilarMovie(int movieId) async {
    try {
      var response = await apiManager.getApi(
        endPoint: ApiUrls.movieSuggestionsEndpoint,
        parameters: {'movie_id': movieId},
      );
      SuggestedMoviesModel result = SuggestedMoviesModel.fromJson(
        response.data,
      );
      return result;
    } catch (e) {
      print("error $e");
      rethrow;
    }
  }
}
