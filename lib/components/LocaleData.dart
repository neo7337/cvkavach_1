import 'dart:collection';

import 'package:numometer/extras/SharedPreferencesCountry.dart';
import 'package:numometer/extras/StatTileInd.dart';
import 'package:numometer/extras/StatsTile.dart';
import 'package:numometer/repositories/data_repositories.dart';
import 'package:numometer/services/api_service.dart';
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
  HashMap<String, List<DistrictData>> districtData = new HashMap<String, List<DistrictData>>();
  List<String> provinceList = new List<String>();
  String provinceDataList="";
  String country;
  SplayTreeMap<int, List<String>> provinceData = new SplayTreeMap<int, List<String>>();
  
  Future<String> getCurrentCountry() async {
    SharedPreferencesCountry prefs =  SharedPreferencesCountry();
    String countryName = await prefs.getCountry();
    return Future.value(countryName.trim());
  }

  Future<String> _fetchLocaleData() async {
    country = await getCurrentCountry();
    //country = "australia";
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    if(country == 'India'){
      localList = await dataRepository.getLocaleData();
    } else {
      provinceList = await dataRepository.getProvinces(country);
      provinceList.forEach((v) => {
        if(provinceDataList == "") {
          provinceDataList = v
        } else {
          provinceDataList = provinceDataList+','+v
        }
      });
      if(provinceList.length > 0 && provinceDataList != "mainland")
        localList = await dataRepository.getProvinceData(country);
    }
    return Future.value("OK");
  }

  Future<String> _fetchDistrictData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    districtData = await dataRepository.getDistrictData();
    return Future.value("OK");
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("Populating Locale Data");
    return FutureBuilder<List<String>>(
      future: Future.wait([_fetchLocaleData(), _fetchDistrictData()]), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
          return  _buildLoading();
        }else{
          if (snapshot.hasError)
            return _buildError();
          else
            return _buildBody();  // snapshot.data  :- get your object which is pass from your downloadData() function
        }
      },
    );
  }

  Widget _buildError() {
    print("build error");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(FeatherIcons.alertCircle, size: 48, color: Color(0xffff653b)),
          SizedBox(height: 14),
          Text('Please update the app to fix the issue', style: TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.none))
        ],
      )
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
      body: RefreshIndicator (
        onRefresh: _handleRefresh,
          child:new SafeArea (
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

  Widget noData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(FeatherIcons.alertCircle, size: 48, color: Color(0xffff653b)),
          SizedBox(height: 14),
          Text('No Data found for your location', style: TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.none))
        ],
      )
    );
  }

  List<Widget> _getListings() { 
    List listings = new List<Widget>();
    var list = localList.values.toList();
    if(localList.length > 0){
      for(var i =localList.length-2; i>=0; i--) {
        if(country == "India")
          listings.add(StatTileInd(list[i], districtData));
        else
          listings.add(StatsTile(list[i], districtData));
      }
    } else {
      listings.add(noData());
    }
    
    return listings;
  }
}