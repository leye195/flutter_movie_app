import 'package:flutter/material.dart';
import 'package:tomato_movie/db/movie_db_helper.dart';
import 'package:tomato_movie/models/Movie.dart';
import 'package:tomato_movie/widgets/MovieTile.dart';

class FavouriteScreen extends StatefulWidget {

  const FavouriteScreen({ Key? key }) : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Movie> movies = [];
  final movieDB = new MovieDBHelper();
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite Movie List')),
      body: FutureBuilder(
        future: movieDB.getMovies(),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            final movies = snapshot.data;
            return ListView.builder(
              itemCount:(movies as List<Movie>).length,
              itemBuilder: (BuildContext context,int index) {
                return MovieTile(movies[index]);
              },
              padding: EdgeInsets.all(1.5),
            );
          }
          return Container(
              child: Text('No Data'),
              margin: EdgeInsets.only(top: 16),
          );
        }
      )
    );
  }
}