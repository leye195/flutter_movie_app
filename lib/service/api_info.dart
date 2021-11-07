import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];
final baseURL = "https://api.themoviedb.org/3";

String getURL(String path) {
  return '$baseURL$path?api_key=$apiKey';
}
  
