import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tomato_movie/models/Actor.dart';
import 'package:tomato_movie/models/Movie.dart';
import 'package:tomato_movie/service/MovieService.dart';
import 'package:tomato_movie/widgets/ActorTile.dart';
import 'package:tomato_movie/widgets/Section.dart';
import 'package:tomato_movie/widgets/ContentTile.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({ Key? key }) : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var _service = MovieService();
  final ScrollController _sliverScrollController = ScrollController();
  bool _isPinned = false;

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

  Widget _contentList(movies) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (BuildContext context, int index) {
        return ContentTile(movies[index]);
      }
    );
  }




  @override
  void initState() {
    super.initState();
      _sliverScrollController.addListener(() {
        if (!_isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset >= kToolbarHeight + 50) {

          setState(() {
            _isPinned = true;
          });
        } else if (_isPinned &&
          _sliverScrollController.hasClients &&
          _sliverScrollController.offset < kToolbarHeight + 50) {

          setState(() {
            _isPinned = false;
          });
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
        body: CustomScrollView(
          controller: _sliverScrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              collapsedHeight: 60,
              expandedHeight: 200,
              flexibleSpace: LayoutBuilder(builder: (context,constraints) {
                return FlexibleSpaceBar(
                  title: Text(
                    arguments['title'],
                    style: TextStyle(
                      fontSize: 16,
                      shadows: <Shadow>[
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black,
                          offset: Offset(2.5, 2.5),
                        )
                      ]
                    )
                  ),
                  background: Image.network(arguments['backdropPath'],fit: BoxFit.cover)
                );
              }) 
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context,index){
                return Container(child:FutureBuilder(
                future: Future.wait([
                  _service.requestMovie(arguments['id']),
                  _service.requestCredits(arguments['id']),
                  _service.requestSimilar(arguments['id']),
                  _service.requestRecommendations(arguments['id']),
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
                    final similarMovies = snapshot.data?[2] as List<Movie>;
                    final recommendations = snapshot.data?[3] as List<Movie>;
                    print(similarMovies);
                    return Padding(padding: EdgeInsets.only(top:32),child:Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 0),child: Container(child: Image.network(arguments['posterPath']),height:180)),
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
                          child: Text(
                            movie.overview as String,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          )
                        ),
                        Container(
                          margin: EdgeInsets.only(top:16,bottom: 16),
                          padding: EdgeInsets.only(top: 16),
                          child: new Section('Casting', SizedBox(child: _actorList(actors),height: 130,)),
                        ),
                        if(similarMovies.length > 0) Container(                        
                          margin: EdgeInsets.only(bottom: 32),
                          padding: EdgeInsets.only(top: 16),
                          child:new Section("Similar Movies", SizedBox(child: _contentList(similarMovies),height: 130))
                        ),
                        if(recommendations.length > 0) Container(                        
                          margin: EdgeInsets.only(bottom:64),
                          padding: EdgeInsets.only(top: 16),
                          child:new Section("Recommendations", SizedBox(child: _contentList(recommendations),height: 130))
                        ),
                      ],
                    ));
                  }
                },
              ));
              },childCount: 1) 
            )
          ],
        ),
      );
  }
}