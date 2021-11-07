import 'package:flutter/material.dart';

class ContentTile extends StatelessWidget {
  final _movie;
  const ContentTile(this._movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      child: Image.network(_movie.posterPath),
      width: 80,
    );
  }
}