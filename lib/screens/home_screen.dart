import 'package:flutter/material.dart';
import 'package:tomato_movie/models/Movie.dart';
import 'package:tomato_movie/service/MovieService.dart';
import 'package:tomato_movie/widgets/MovieTile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _service = MovieService();

  Future<List<Movie>> fetchMovieList() {
    return _service.requestMovies();
  }

  Widget _movieList(movies) {
    return ListView.builder(
      itemCount:movies.length,
      itemBuilder: (BuildContext context,int index) {
        return MovieTile(movies[index]);
      },
      padding: EdgeInsets.all(1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 8,bottom: 16),
          child: FutureBuilder(
            future: fetchMovieList(),
            builder: (context,snapshot) {
              if(!snapshot.hasData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey))]
                );
              } else {
                final movies = snapshot.data;
                return _movieList(movies);
              }
            }
          )
        )
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.favorite_border),onPressed: (){
        Navigator.pushNamed(context, "/favourite");
      }),
    );
  }
}
