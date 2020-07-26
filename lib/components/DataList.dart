import 'package:flutter/material.dart';

class DataList extends StatefulWidget {
  DataList({Key key}) : super(key : key);

  @override
  _DataListWidget createState() => _DataListWidget();
}

class _DataListWidget extends State<DataList> {
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
      'Index 1: Data List Info'
    )
    );
  }
}