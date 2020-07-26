import 'package:numometer/components/CountrySearch.dart';
import 'package:numometer/components/DataList.dart';
import 'package:numometer/components/LocaleData.dart';
import 'package:numometer/components/Tracker.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:numometer/extras/SDApi.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String display;
  int _selectedIndex = 0;
  bool _lights = false;
  var shareURL = "https://play.google.com/store/apps/details?id=com.app.numometer";
  //var shareURL = loadYaml("/configs.yaml");
  static List<Widget> _widgetOptions = <Widget>[
    Tracker(),
    DataList(),
    CountrySearchProvider(),
    LocaleDataProvider()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
    /* var doc = loadYaml("../../configs.yaml");
    print(doc);
    File f = new File("../../configs.yaml");
    f.readAsString().then((String text) {
      Map yaml = loadYaml(text);

      shareURL = yaml['shareURL'];
    }); */
  }

  invokeSocialDistancingAPI() {
    SDApi invoke = new SDApi();
    if(_lights){
      invoke.invokeSocDistance();
      var mon = invoke.monitorApi();
      print(mon.toString());
    }
    else
      invoke.stopTransmission();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: AppBar(
        title: const Text('NUMOMETER'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              final RenderBox box = context.findRenderObject();
              Share.share("Check out this new App : " + shareURL,
                  subject: "NumOMeter",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          )
        ],
      ),
      body: Center(
        child: Scaffold(
          key: scaffoldKey,
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.language),
                  title: Text('Tracker'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  title: Text('Full List')
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), title: Text('Search')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.remove_red_eye), title: Text('Locale Data'))
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
              backgroundColor: Color(0xFF101010),
              type: BottomNavigationBarType.fixed),
        )
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Social Distancing API'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
                invokeSocialDistancingAPI();
              },
              secondary: const Icon(Icons.blur_circular),
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ]
        )
      ),
    );
  }
}
