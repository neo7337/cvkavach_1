import 'package:flutter/material.dart';

class Event extends StatefulWidget {
  Event({Key key}) : super(key : key);

  @override
  _EventWidget createState() => _EventWidget();
}

class _EventWidget extends State<Event> {
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
      'Index 1: Event Info'
    )
    );
  }
}