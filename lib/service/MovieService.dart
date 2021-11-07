import 'package:http/http.dart' as http;
import 'package:tomato_movie/models/Actor.dart';
import 'dart:convert';
import 'dart:async';
import 'package:tomato_movie/models/Movie.dart';
import 'api_info.dart';

class MovieService {
  Future<List<Movie>> requestMovies() async {
    String url = getURL("/movie/now_playing");

    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;

    String responseBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responseBody);
    if(statusCode == 200) {
      var results = json['results'];
      var movies = (results as List).map((movie) {
        return Movie.fromJson(movie);
      });
      return movies.toList();
    } else {
      return Future.error("Can not get Movie List data");
    }
  }

  Future<Movie> requestMovie(int id)async {
    String url = getURL("/movie/$id");

    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;

    String responseBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responseBody);
    
    if(statusCode == 200) {
      var movie = Movie.fromJson(json);

      return movie;
    } else {
      return Future.error("Can not get Movie data");
    }
  }

  Future<List<Actor>> requestCredits(int id) async {
    String url = getURL("/movie/$id/credits");
    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;

    String responseBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responseBody);

    if(statusCode == 200) {
      var results = json['cast'];
      var actors = (results as List).map((actor) {
        return Actor.fromJson(actor);
      });
      return actors.toList().sublist(0,10);
    } else {
      return Future.error("Can not get Movie List data");
    }
  }

  Future<List<Movie>> requestRecommendations(int id) async {
    String url = getURL('/movie/$id/recommendations');
    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;

    String responseBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responseBody);
    if(statusCode == 200) {
      var results = json['results'];
      var movies = (results as List).map((movie) {
        return Movie.fromJson(movie);
      });
      return movies.toList();
    } else {
      return Future.error("Can not request Recommendation data");
    }
  }

  Future<List<Movie>> requestSimilar(int id) async {
    String url = getURL("/movie/$id/similar");
    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;

    String responseBody = utf8.decode(response.bodyBytes);
    var json = jsonDecode(responseBody);
    if(statusCode == 200) {
      var results = json['results'];
      var movies = (results as List).map((movie) {
        return Movie.fromJson(movie);
      });
      return movies.toList();
    } else {
      return Future.error("Can not get Movie List data");
    }
  }
}