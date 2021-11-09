import 'package:flutter/material.dart';
import 'package:tomato_movie/db/movie_db_helper.dart';
import 'package:tomato_movie/models/Movie.dart';

class MovieTile extends StatefulWidget {
  final Movie _movie;

  const MovieTile(this._movie);

  @override
  _MovieTileState createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  
  bool isFavourite = false;

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
              Expanded(flex: 2,child: IconButton(color: isFavourite ? Colors.pink:Colors.black,icon: Icon(isFavourite?Icons.favorite:Icons.favorite_outline),onPressed: ()async{
                 final db =  new MovieDBHelper();
                 final movie = await db.getMovie(widget._movie.id);
                 if(movie.isEmpty) {
                   await db.insertMovie(widget._movie);
                   setState(() {
                     isFavourite = true;
                   });
                 }
              }))
            ]
          )
        )
      )
    );
  }
}

