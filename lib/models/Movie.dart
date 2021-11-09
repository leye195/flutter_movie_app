import './Company.dart';

class Movie {
  final String title;
  final String posterPath;
  final String backdropPath;
  final int id;
  final String releaseDate;
  final double voteAvg;
  final String? tagline;
  final String? overview;
  final List<dynamic>? companies;

  Movie({required this.id, required this.title, required this.backdropPath, required this.posterPath,required this.releaseDate, required this.voteAvg, this.tagline, this.overview, this.companies});

  Movie.fromJson(Map<String, dynamic>json)
    : id = json['id'],
      title = json['title'],
      posterPath = "https://image.tmdb.org/t/p/w500${json['poster_path']}",
      backdropPath = "https://image.tmdb.org/t/p/w500${json['backdrop_path']}",
      releaseDate = json['release_date'],
      tagline = json['tagline'],
      voteAvg = (json['vote_average']).toDouble() ??0.0,
      overview = json['overview'],
      companies = json['production_companies']  ?? [];

  Map<String,dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'backdropPath': backdropPath,
    'releaseDate': releaseDate,
    'tagline': tagline,
    'voteAvg': voteAvg,
    'overview': overview,
    'companies': companies,
  };

  Map<String,dynamic> toMap() => {
    'id': id,
    'title': title,
    'posterpath': posterPath,
    'backdropPath': backdropPath,
    'releaseDate': releaseDate,
    'tagline': tagline,
    'voteAvg': voteAvg,
    'overview': overview,
  };
}