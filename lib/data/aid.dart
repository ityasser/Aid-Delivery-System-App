import '../core/models/identifiable.dart';

class Aid  extends Identifiable{
  final int movieId;
  final String originalTitle;
  final String overview;
  final double voteAverage;
  final String posterPath;

  Aid({
    id_object,
    required this.movieId,
    required this.originalTitle,
    required this.overview,
    required this.voteAverage,
    required this.posterPath,
  });

  factory Aid.fromJson(Map<String, dynamic> json) {
    return Aid(
      id_object: 0,
      movieId: json["movie_id"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      voteAverage: (json["vote_average"] as num).toDouble(),
      posterPath: json["poster_path"],
    );
  }
}