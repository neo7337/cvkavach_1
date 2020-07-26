import 'package:flutter/material.dart';

class VaccineStatus extends StatefulWidget {
  VaccineStatus({Key key}) : super(key: key);

  @override
  _VaccineStatusWidget createState() => _VaccineStatusWidget();
}

class _VaccineStatusWidget extends State<VaccineStatus> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          child: new Column(children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Hello World'),
                          new Text('How are you?')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Hello World'),
                          new Text('How are you?')
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Hello World'),
                          new Text('How are you?')
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Card(
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          new Text('Hello World'),
                          new Text('How are you?')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
