import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'dart:async';
import 'package:tomato_movie/models/Movie.dart';
import 'package:tomato_movie/service/MovieService.dart';
import 'package:tomato_movie/widgets/MovieTile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future searchFuture;
  final controller = TextEditingController();
  var _service = MovieService();
  
  void _updateText() {
    if(controller.text != '') {
      EasyDebounce.cancelAll();
      EasyDebounce.debounce('search', Duration(milliseconds: 300), () { 
        setState(() {
          searchFuture = fetchMovieList();
        });
      });
    }
	}

  Future<List<Movie>> fetchMovieList() {
    return _service.searchMovies(controller.text);
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
  void initState() {
    super.initState();
    searchFuture = fetchMovieList();
    controller.addListener(_updateText);
  }

  @override
  void dispose() {
    controller.dispose();
    EasyDebounce.cancel("search");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 8,bottom: 16),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left:16,right:16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search Movie',
                    suffixIcon: Icon(Icons.search),
                  ),
                  controller: controller,
                )
              ),
              Expanded(
                child: FutureBuilder(
                  initialData: [],
                  future: searchFuture,
                  builder: (context,snapshot) {
                    if(snapshot.connectionState != ConnectionState.done) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey)
                          ),
                        ]
                      );
                    } 
                    if(snapshot.hasData) {
                      final movies = snapshot.data;
                      return _movieList(movies);
                    }
                    return Container(
                      child: Text('No Results'),
                      margin: EdgeInsets.only(top: 16),
                    );
                  }
                )
              )
            ],
          )),
        )
    );
  }
}