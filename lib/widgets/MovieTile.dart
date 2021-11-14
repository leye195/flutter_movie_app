import 'package:flutter/material.dart';
import 'package:tomato_movie/db/movie_db_helper.dart';
import 'package:tomato_movie/models/Movie.dart';

class MovieTile extends StatefulWidget {
  final Movie _movie;
  final String _from;

  const MovieTile(this._movie,this._from);

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  final movieDB = new MovieDBHelper();
  bool isFavourite = false;

  Future<bool> isOnFavouriteList() async {
    final movie = await movieDB.getMovie(widget._movie.id);
    if(movie.isNotEmpty) return true;
    return false;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if(await isOnFavouriteList()) {
        setState(() {
          isFavourite = true;
        });
    } else {
      setState(() {
        isFavourite = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child:Card(
        child:InkWell(
          onTap: (){
            Navigator.pushNamed(context, "/detail",arguments: <String,dynamic>{
              'id': widget._movie.id,
              'title': widget._movie.title,
              'posterPath': widget._movie.posterPath,
              'backdropPath': widget._movie.backdropPath,
              'voteAvg': widget._movie.voteAvg
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Expanded(
                    flex:2,
                    child: Container(
                      child:  widget._movie.posterPath.toString().contains("null")?
                      Container(
                        height: 80,
                        width: 80,
                        color: Colors.blueGrey,
                      ) :
                      Image.network(
                        widget._movie.posterPath,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if(loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:loadingProgress.expectedTotalBytes != null ? 
                              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                            ),
                          );
                        } ,
                      ), 
                      width: 80,
                      height: 80
                    )
                  ),
                  Expanded(flex:8,child: 
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children:[
                          Container(child:Text(widget._movie.title,maxLines: 2, overflow: TextOverflow.ellipsis)),
                          Padding(
                            padding: EdgeInsets.only(top:10),
                            child: Row(
                              children: [
                                Icon(Icons.star,color: Colors.yellow),
                                Text(widget._movie.voteAvg.toString())
                              ]
                            ),
                          )
                        ]
                      )
                    ))
                  ]
                ),
              ),
              if(widget._from != 'favourite') Expanded(flex: 2,child: IconButton(color: isFavourite ? Colors.pink:Colors.black,icon: Icon(isFavourite?Icons.favorite:Icons.favorite_outline),onPressed: ()async{
                 if(await isOnFavouriteList()) {
                   await movieDB.deleteMovie(widget._movie.id);
                   setState(() {
                     isFavourite = false;
                   });
                 } else {
                  await movieDB.insertMovie(widget._movie);
                  setState(() {
                    isFavourite = true;
                  });
                 }
              })),
            ]
          )
        )
      )
    );
  }
}