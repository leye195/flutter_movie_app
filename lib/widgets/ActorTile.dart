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
                  _actor.profilePath != null? 
                    Container(child:Image.network(_actor.profilePath),width:70,height: 70):
                    Container(width: 70,height: 70,color: Colors.black12),
                  Text(_actor.name)
                ]
              )
            )
          ],
        );
  }
}