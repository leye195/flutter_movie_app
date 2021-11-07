import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  final _movie;
  const MovieTile(this._movie);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child:Card(
        child:InkWell(
          onTap: (){
            Navigator.pushNamed(context, "/detail",arguments: <String,dynamic>{
              'id': _movie.id,
              'title': _movie.title,
              'posterPath': _movie.posterPath,
              'backdropPath': _movie.backdropPath,
              'voteAvg': _movie.voteAvg
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
                      child: Image.network(_movie.posterPath), 
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
                          Container(child:Text(_movie.title,maxLines: 2, overflow: TextOverflow.ellipsis)),
                          Padding(
                            padding: EdgeInsets.only(top:10),
                            child: Row(
                              children: [
                                Icon(Icons.star,color: Colors.yellow),
                                Text(_movie.voteAvg.toString())
                              ]
                            ),
                          )
                        ]
                      )
                    ))
                  ]
                ),
              ),
              Expanded(flex: 2,child: IconButton(icon: Icon(Icons.favorite_outline),onPressed: (){}))
            ]
          )
        )
      )
    );
  }
}
