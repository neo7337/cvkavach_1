import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key : key);
  @override
  _AccountWidget createState() => _AccountWidget();
}

class _AccountWidget extends State<Account>{
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
      'Index 3: Account Info'
    )
    );
  }
}