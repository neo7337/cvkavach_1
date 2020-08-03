import 'package:flutter/material.dart';
import 'package:numometer/services/api_service.dart';

class VaccineDataTile extends StatelessWidget {
  final VDataStruct vData;
  final int num;

  static final MaterialColor phase3 = Colors.teal;
  static final MaterialColor phase2 = Colors.blueGrey[900];
  static final MaterialColor phase1 = Colors.blue[300];
  static final MaterialColor pre = Colors.blue[100];
  static final MaterialColor early = Colors.amber[50];

  VaccineDataTile(this.num, this.vData);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "card$num",
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Material(
                  child: ListTile(
                    
                    title: Text(vData.candidate.toString()),
                    subtitle: Text(vData.trialPhase.toString()),
                  ),
                )
              ],
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              bottom: 0.0,
              right: 0.0,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () async {
                    await Future.delayed(Duration(milliseconds: 200));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return new PageItem(num: num, vData: vData);
                        },
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  final VDataStruct vData;
  final int num;

  const PageItem({Key key, this.num, this.vData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Hero(
        tag: "card$num",
        child: Material(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: new Card(
                  color: _fetchTheme(vData.trialPhase),
                  child: new Container(
                    padding: new EdgeInsets.all(32.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text(vData.candidate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20)),
                            ),
                            ListTile(
                              title: Text(vData.trialPhase,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            ListTile(
                              title: Text("Sponsors",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(vData.sponsors.substring(
                                  vData.sponsors.indexOf('[') + 1,
                                  vData.sponsors.indexOf(']'))),
                            ),
                            ListTile(
                              title: Text("Funding",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(vData.funding.substring(
                                  vData.funding.indexOf('[') + 1,
                                  vData.funding.indexOf(']'))),
                            ),
                            ListTile(
                              title: Text("Institutions",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(vData.institutions.substring(
                                  vData.institutions.indexOf('[') + 1,
                                  vData.institutions.indexOf(']'))),
                            ),
                            ListTile(
                              title: Text("Details",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(vData.details.replaceAll("&nbsp;", '').replaceAll("&rsquo;", "'")),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

MaterialColor _fetchTheme(String phase) {
  if (phase.indexOf("3") > 0) {
    return Colors.teal;
  } else if (phase.indexOf("2") > 0) {
    return Colors.blueGrey;
  } else if (phase.indexOf("1") > 0) {
    return Colors.cyan;
  } else if (phase.indexOf("Pre") >= 0) {
    return Colors.grey;
  } else {
    return Colors.amber;
  }
}
