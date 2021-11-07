import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'api_info.dart';
import 'package:tomato_movie/models/Actor.dart';
import 'package:tomato_movie/models/Movie.dart';

List<Movie> parseMovies(String responseBody) {
  final json = jsonDecode(responseBody);
  final results = json['results'];
  return (results as List).map<Movie>((movie) {
      return Movie.fromJson(movie);
  }).toList();
}

class MovieService {
  Future<List<Movie>> requestMovies() async {
    
    String url = getURL("/movie/now_playing");

    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;
    if(statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return parseMovies(responseBody);
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
      final movie = Movie.fromJson(json);
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
    if(statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return compute(parseMovies,responseBody);
    } else {
      return Future.error("Can not request Recommendation data");
    }
  }

  Future<List<Movie>> requestSimilar(int id) async {
    String url = getURL("/movie/$id/similar");
    var response = await http.get(Uri.parse(url));
    var statusCode = response.statusCode;
    if(statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      return compute(parseMovies,responseBody);
    } else {
      return Future.error("Can not get Movie List data");
    }
  }
}