import 'package:numometer/components/CountrySearch.dart';
import 'package:numometer/components/LocaleData.dart';
import 'package:numometer/components/Tracker.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String display;
  int _selectedIndex = 0;
  var shareURL = "https://play.google.com/store/apps/details?id=com.app.cvkavach";
  //var shareURL = loadYaml("/configs.yaml");
  static List<Widget> _widgetOptions = <Widget>[
    Tracker(),
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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('NUMOMETER'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              final RenderBox box = context.findRenderObject();
              Share.share("Check out this new App : " + shareURL,
                  subject: "CVKavach",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
          )
        ],
      ),
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
                icon: Icon(Icons.search), title: Text('Search')),
            BottomNavigationBarItem(
                icon: Icon(Icons.remove_red_eye), title: Text('Locale Data'))
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
          backgroundColor: Color(0xFF101010),
          type: BottomNavigationBarType.fixed),
    );
  }
}
