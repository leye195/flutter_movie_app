import 'package:flutter/material.dart';

class ContentTile extends StatelessWidget {
  final _movie;
  const ContentTile(this._movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: InkWell(
        child: Image.network(
          _movie.posterPath,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if(loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:loadingProgress.expectedTotalBytes != null ? 
                      loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
              ),
            );
          },
        ),
        onTap: (){
          Navigator.pushNamed(context, '/detail',arguments: <String,dynamic>{
            'id': _movie.id,
            'title': _movie.title,
            'posterPath': _movie.posterPath,
            'backdropPath': _movie.backdropPath,
            'voteAvg': _movie.voteAvg
          }
        );
      }),
      width: 80,
    );
  }
}