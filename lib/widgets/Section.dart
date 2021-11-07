import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final Widget children;
  const Section(this.title,this.children); 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8,left: 16),
          child:Text(
            this.title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          )
        ),
        children
      ]
    );
  }
}
