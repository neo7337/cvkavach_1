import 'dart:collection';

import 'package:numometer/extras/SharedPreferencesCountry.dart';
import 'package:numometer/extras/_CustomGraph.dart';
import 'package:numometer/extras/_StatTile.dart';
import 'package:numometer/repositories/data_repositories.dart';
import 'package:numometer/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';

class Tracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TrackerInfo(),
      ), create: (_) => DataRepository(apiService: APIService()),
    );
  }
}

class TrackerInfo extends StatefulWidget {
  TrackerInfo({Key key}) : super(key : key);

  @override
  _TrackerWidget createState() => _TrackerWidget();
}

class _TrackerWidget extends State<TrackerInfo> {

  final HashMap<String, String> responseMap = new HashMap<String, String>();
  List<String> countriesList = new List<String>();
  final Map<String, double> dataMap = new Map<String, double>();
  final Map<String, String> finalResponseMap = new Map<String, String>();
  
  void initState(){
    super.initState();
  }
  
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    return null;
  }

  Future<String> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final responseMap = await dataRepository.getEndpointData();
    //print("Data fetched Successfully");
    //print(responseMap.toString());
    dataMap.putIfAbsent("active", () => double.parse(responseMap['Active']));
    dataMap.putIfAbsent("dead", () => double.parse(responseMap['Deaths']));
    dataMap.putIfAbsent("ok", () => double.parse(responseMap['Recovered']));
    finalResponseMap.putIfAbsent("Confirmed", () => responseMap['Confirmed']);
    finalResponseMap.putIfAbsent("Recovered", () => responseMap['Recovered']);
    finalResponseMap.putIfAbsent("Deaths", () => responseMap['Deaths']);
    finalResponseMap.putIfAbsent("Active", () => responseMap['Active']);
    finalResponseMap.putIfAbsent("LastUpdate", () => responseMap['LastUpdated']);
    return Future.value("OK");
  }

  Future<String> getUserLocation() async {//call this async method from whereever you need
    LocationData myLocation;
    String error;
    Location location = new Location();
    bool gotLocation = false;
    SharedPreferencesCountry prefs =  SharedPreferencesCountry();
    try {
      //print("Getting Location");
      myLocation = await location.getLocation();
      //print(myLocation.toString());
      gotLocation = true;
    } on PlatformException catch (e) {
      //print(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    //currentLocation = myLocation;
    //print("test");
    if(gotLocation){
      //print("Location Accessed Successfully");
      final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      //print("Addressed : " + addresses.toString());
      var first = addresses.first;
      var addressList = first.addressLine.split(",");
      //print(addressList[addressList.length-1]);
      //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      prefs.addCountry(addressList[addressList.length-1]);
    } else {
      //print("Location Denied");
      prefs.addCountry('India');
    }
    
    return Future.value("OK");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Future.wait([_updateData(), getUserLocation()]), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
            return  _buildLoading();
        }else{
            if (snapshot.hasError)
              return _buildError();
            else
              return _buildBody(dataMap, finalResponseMap);  // snapshot.data  :- get your object which is pass from your downloadData() function
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

  Widget _buildBody(Map<String, double> dataMap, Map<String, String> responseMap) {
    //print('Populating tracker data ' + dataMap.toString() + ' ' + responseMap.toString());
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CustomGraph(dataMap, "Cases Worldwide"),
                Column(
                  children: <Widget>[
                    StatTile(Color(0xffffffff), 'Total Cases', int.parse(responseMap['Confirmed'])),
                    StatTile(Color(0xfff5c76a), 'Active', int.parse(responseMap['Active'])),
                    StatTile(Color(0xffff653b), 'Deaths', int.parse(responseMap['Deaths'])),
                    StatTile(Color(0xff9ff794), 'Recovered', int.parse(responseMap['Recovered'])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Last update ' + responseMap['LastUpdate'],
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4), 
                              fontSize: 10, 
                              decoration: TextDecoration.none),                  
                        )
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height,
        )
      )
    );
  }
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