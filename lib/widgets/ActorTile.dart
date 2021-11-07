import 'package:flutter/material.dart';

class ActorTile extends StatelessWidget {
  final _actor;
  const ActorTile(this._actor);

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              child:  
                Column(
                  children: [
                  _actor.profilePath.toString().isNotEmpty ? 
                    Container(
                      child:Image.network(_actor.profilePath,          
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if(loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                          value:loadingProgress.expectedTotalBytes != null ? 
                                loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    ),
                    width:80,
                    height:80
                  ):
                  Container(width: 80,height: 80,color: Colors.black12),
                  Container(
                    child: Text(
                      _actor.name,
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 10, 
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 2
                    ),
                    width: 50,
                    height: 25
                  )
                ]
              )
            )
          ],
        );
  }
}