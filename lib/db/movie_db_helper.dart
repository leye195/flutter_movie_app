import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tomato_movie/models/Movie.dart';

class MovieDBHelper {
  late Future<Database> _db;
  final String tableName = "movies";

  Future<void> _createDB(Database db) {
    return db.execute(
      "CREATE TABLE movies(id INTEGER PRIMARY KEY, title TEXT, posterPath TEXT, backdropPath TEXT, releaseDate TEXT, voteAvg DOUBLE, tagline TEXT, overview TEXT)"
    );
  }

  Future<Database> get database async {
      final dbPath = join(await getDatabasesPath(),'movies.db');
      _db = openDatabase(
        dbPath,
        onCreate: (db,version) => _createDB(db),
        version: 1
      );
      return _db;
  }

  Future<List<Movie>> getMovies() async {
    final Database db = await database;
    final List<Map<String,dynamic>> maps = await db.query(tableName);

    return List.generate(
      maps.length, 
      (idx) => Movie(
        id: maps[idx]['id'],
        title: maps[idx]['title'],
        posterPath: maps[idx]['posterPath'],
        backdropPath: maps[idx]['backdropPath'],
        releaseDate: maps[idx]['releaseDate'],
        tagline: maps[idx]['tagline'],
        voteAvg: maps[idx]['voteAvg'],
        overview: maps[idx]['overview']
      )
    );
  }

  Future<List<Movie>> getMovie(int id) async {
    final Database db = await database;
    final List<Map<String,dynamic>> maps = await db.query(tableName,where: 'id=?' ,whereArgs: [id]);
    
    return List.generate(
      maps.length, 
      (idx) => Movie(
        id: maps[idx]['id'],
        title: maps[idx]['title'],
        posterPath: maps[idx]['posterPath'],
        backdropPath: maps[idx]['backdropPath'],
        releaseDate: maps[idx]['releaseDate'],
        tagline: maps[idx]['tagline'],
        voteAvg: maps[idx]['voteAvg'],
        overview: maps[idx]['overview']
      )
    );
  }


  Future<void> insertMovie(Movie movie) async {
    final Database db = await database;
    await db.insert(
      tableName,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> deleteMovie(int id) async {
    final Database db = await database;
    await db.delete(
      tableName,
      where: 'id=?',
      whereArgs: [id]
    );
  }
}