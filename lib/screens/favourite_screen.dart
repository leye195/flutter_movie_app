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
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final data = await movieDB.getMovies();
    setState(() {
      movies = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Movie List'),
        leading: InkWell(
          child: Icon(Icons.keyboard_arrow_left),
          onTap: () => Navigator.pushReplacementNamed(context, "/")
        ),
      ),
      body: movies.length > 0 ? ListView.builder(
              itemCount:movies.length,
              itemBuilder: (BuildContext context,int index) {
                return Dismissible(
                  key: Key(movies[index].id.toString()), 
                  child:  MovieTile(movies[index],'favourite'),
                  onDismissed: (direction) async {
                    await movieDB.deleteMovie(movies[index].id);
                    setState(() {
                      movies.removeAt(index);
                    });
                  },
                  background: Container(
                    child: Icon(Icons.remove_circle,color: Colors.white,),
                    color: Colors.red
                  ),
                );
              },
              padding: EdgeInsets.all(1.5),
            ) : Container(
              child: Center(child: Text('No Data')),
              margin: EdgeInsets.only(bottom: 32),
            ) 
      );
  }
}