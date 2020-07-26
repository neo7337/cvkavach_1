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
                          ListTile(
                              title: Text('Total Vaccine Contendors',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  'Contains the count of those vaccines as well which are not yet in human trials. In the midst of darkness we have a ray of hope.'),
                              trailing: Text(
                                '140+',
                                style: Theme.of(context).textTheme.headline4,
                              )),
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
					  color: Colors.blueGrey,
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Phase I',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle:
                                  Text('Vaccines testing safety and dosage'),
                              trailing: Text(
                                '19',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Card(
					  color: Colors.blue[300],
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Phase II',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle:
                                  Text('Vaccines in expanded safety trials'),
                              trailing: Text(
                                '13',
                                style: Theme.of(context).textTheme.headline4,
                              )),
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
					  color: Colors.blueGrey[900],
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Phase III',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(
                                  'Vaccines in large-scale efficacy tests'),
                              trailing: Text(
                                '4',
                                style: Theme.of(context).textTheme.headline4,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: new Card(
					  color: Colors.teal,
                    child: new Container(
                      padding: new EdgeInsets.all(32.0),
                      child: new Column(
                        children: <Widget>[
                          ListTile(
                              title: Text('Approval',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle:
                                  Text('Vaccines approved for limited use'),
                              trailing: Text(
                                '1',
                                style: Theme.of(context).textTheme.headline4,
                              )),
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
