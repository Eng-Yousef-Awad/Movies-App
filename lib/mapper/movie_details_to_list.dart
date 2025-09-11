import 'package:movies_app/models/movie_details.dart' as details;
import 'package:movies_app/models/movies_model.dart' as list;

extension MovieDetailsMapper on details.Movie {
  list.Movies toMoviesModel() {
    return list.Movies(
      id: id,
      url: url,
      imdbCode: imdbCode,
      title: title ?? titleEnglish ?? titleLong,
      titleEnglish: titleEnglish,
      titleLong: titleLong,
      slug: slug,
      year: year,
      rating: (rating is int) ? (rating as int).toDouble() : rating,
      runtime: runtime,
      genres: genres,
      descriptionFull: descriptionFull ?? descriptionIntro,
      ytTrailerCode: ytTrailerCode,
      language: language,
      mpaRating: mpaRating,
      backgroundImage: backgroundImage,
      backgroundImageOriginal: backgroundImageOriginal,
      smallCoverImage: smallCoverImage,
      mediumCoverImage: mediumCoverImage ?? largeCoverImage ?? smallCoverImage,
      largeCoverImage: largeCoverImage ?? mediumCoverImage ?? smallCoverImage,
      dateUploaded: dateUploaded,
      dateUploadedUnix: dateUploadedUnix,
    );
  }
}
