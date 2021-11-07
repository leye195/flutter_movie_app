import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tomato_movie/models/Actor.dart';
import 'package:tomato_movie/models/Movie.dart';
import 'package:tomato_movie/service/MovieService.dart';
import 'package:tomato_movie/widgets/ActorTile.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({ Key? key }) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var _service = MovieService();

  Widget _actorList(actors) {   
    return Container(
      height: MediaQuery.of(context).size.height,
      child:ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:actors.length,
        itemBuilder: (BuildContext context,int index) {
          return ActorTile(actors[index]);
        },
        padding: EdgeInsets.all(5),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              flexibleSpace: Stack(children: [
                Positioned.fill(child: Image.network(arguments['posterPath'],fit: BoxFit.cover))
              ]),
            ),
            SliverFillRemaining(
              fillOverscroll: true,
              child: FutureBuilder(
                future: Future.wait([
                  _service.requestMovie(arguments['id']),
                  _service.requestCredits(arguments['id'])
                ]),
                builder: (context,AsyncSnapshot<List<dynamic>>snapshot) {
                  if(!snapshot.hasData) {
                    return Padding(padding: EdgeInsets.only(top:50) ,child:Column(                      
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey))]
                    ));
                  } else {
                    final movie = snapshot.data?[0] as Movie;
                    final actors = snapshot.data?[1] as List<Actor>;
                    return   Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top:21),child: Container(child: Image.network(arguments['posterPath']),width: 300,height:200)),
                        Text(arguments['title'],style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,color: Colors.yellow),
                            Text(arguments['voteAvg'].toString())
                          ]
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:8,left:32,right:32,bottom:10),
                          child: Text(movie.overview as String,)
                        ),
                        Container(padding: EdgeInsets.only(top: 16),child:_actorList(actors),height: 180)
                      ],
                    );
                  }
                },
              )
            )
          ],
        ),
      );
  }
}