import 'dart:collection';

import 'package:cvkavach/repositories/data_repositories.dart';
import 'package:cvkavach/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocaleDataProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LocaleData(),
      ), create: (_) => DataRepository(apiService: APIService()),
    );
  }
}

class LocaleData extends StatefulWidget {
  LocaleData({Key key}) : super(key : key);
  @override
  _LocaleDataWidget createState() => _LocaleDataWidget();
}

class _LocaleDataWidget extends State<LocaleData>{
  void initState(){
    super.initState();
  }

  SplayTreeMap<int, List<String>> localList = new SplayTreeMap<int, List<String>>();
  
  Future<String> _fetchLocaleData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    localList = await dataRepository.getLocaleData();
    return Future.value("OK");
  }

  int _count = 0;
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {
      _count += 5;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Future.wait([_fetchLocaleData()]), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  _buildLoading();
        }else{
          if (snapshot.hasError)
            return _buildError(snapshot.error);
          else
            return _buildBody();  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  Widget _buildError(Widget error) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "cvkavach",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: error,
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 24),
            Text(
              'Fetching latest updates',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return new Scaffold(
      backgroundColor: Color(0xFF101010),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
          child:new SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child:  ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: _getListings(),
                  ),
                )
              ]
            )
          )
        )
      )
    );
  }

  List<Widget> _getListings() { 
    List listings = new List<Widget>();
    var list = localList.values.toList();
    for(var i =localList.length-2; i>=0; i--) {
      listings.add(_StatTile(list[i]));
    }
    return listings;
  }

  Widget column = Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Title', style: TextStyle(fontSize: 16),),
        Text('subtitle'),
      ],
    ),
  );

}

class _StatTile extends StatelessWidget {
  final List<String> value;

  _StatTile(this.value);

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.white24),
        ),
      ),
      child: Column(
        children:<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: Text(value[0], 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none)),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.circle, color: Color(0xff0000ff), size: 10),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Total Cases',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                value[1].toString().replaceAllMapped(reg, mathFunc),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.circle, color: Color(0xffff653b), size: 10),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Deaths',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                value[2].toString().replaceAllMapped(reg, mathFunc),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(FeatherIcons.circle, color: Color(0xff9ff794), size: 10),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Recovered',
                    style: TextStyle(
                        fontSize: 14, 
                        color: Colors.white.withOpacity(0.6),
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              Text(
                value[3].toString().replaceAllMapped(reg, mathFunc),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ],
          )
        ]
      )
    );
  }
}