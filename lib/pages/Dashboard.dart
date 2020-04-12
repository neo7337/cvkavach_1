import 'package:cvkavach/components/CountrySearch.dart';
import 'package:cvkavach/components/LocaleData.dart';
import 'package:cvkavach/components/Tracker.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {

  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {
  String display;
  int _selectedIndex = 0;
  static TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    //Home(),
    //Event(),
    Tracker(),
    CountrySearchProvider(),
    //Account(),
    LocaleDataProvider()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    super.initState();
  }
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    print("Locale CountryCode" + myLocale.countryCode.toString());
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('cvkavach'),
        centerTitle: true
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          /*BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            title: Text('Event'),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            title: Text('Tracker'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            title: Text('Locale Data')
          )
          /*BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Account')
          )*/
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF101010),
        type: BottomNavigationBarType.fixed
      ),
    );
  }
}