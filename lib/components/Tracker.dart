import 'dart:collection';

import 'package:cvkavach/extras/pieChart.dart';
import 'package:cvkavach/repositories/data_repositories.dart';
import 'package:cvkavach/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    print('resfers');
    super.initState();
  }

  int _count = 0;
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    setState(() {
      _count += 5;
    });
    return null;
  }

  Future<String> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final responseMap = await dataRepository.getEndpointData();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _updateData(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {  // AsyncSnapshot<Your object type>
        if( snapshot.connectionState == ConnectionState.waiting){
            return  _buildLoading();
        }else{
            if (snapshot.hasError)
              return _buildError(snapshot.error);
            else
              return _buildBody(dataMap, finalResponseMap);  // snapshot.data  :- get your object which is pass from your downloadData() function
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

  Widget _buildBody(Map<String, double> dataMap, Map<String, String> responseMap) {
    print('building widget ' + dataMap.toString() + ' ' + responseMap.toString());
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
                _CustomGraph(dataMap, "Cases Worldwide"),
                Column(
                  children: <Widget>[
                    _StatTile(Color(0xffffffff), 'Total Cases', int.parse(responseMap['Confirmed'])),
                    _StatTile(Color(0xfff5c76a), 'Active', int.parse(responseMap['Active'])),
                    _StatTile(Color(0xffff653b), 'Deaths', int.parse(responseMap['Deaths'])),
                    _StatTile(Color(0xff9ff794), 'Recovered', int.parse(responseMap['Recovered'])),
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

class _CustomGraph extends StatelessWidget {
  final Map<String, double> dataMap;
  final String title;

  _CustomGraph(this.dataMap, this.title);

  @override
  Widget build(BuildContext context) {
    double chartRadiusFactor =
        MediaQuery.of(context).size.aspectRatio > 0.6 ? 0.5 : 0.625;
    double fontSize = MediaQuery.of(context).size.aspectRatio > 0.6 ? 10 : 12;
    TextStyle titleStyle = MediaQuery.of(context).size.aspectRatio > 0.6
        ? TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          )
        : TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          );
    return PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartRadius: MediaQuery.of(context).size.width * chartRadiusFactor,
      showChartValuesInPercentage: true,
      showChartValues: false,
      showChartValuesOutside: true,
      colorList: [Color(0xfff5c76a), Color(0xffff653b), Color(0xff9ff794)],
      showLegends: false,
      decimalPlaces: 1,
      showChartValueLabel: true,
      initialAngle: 4.5,
      chartType: ChartType.ring,
      chartValueStyle: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: fontSize,
      ),
      chartTitle: title,
      chartTitleStyle: titleStyle,
    );
  }
}

class _StatTile extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final int plus;

  _StatTile(this.color, this.label, this.value, {this.plus = 0});

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(FeatherIcons.circle, color: color, size: 10),
              SizedBox(
                width: 6,
              ),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14, 
                    color: Colors.white.withOpacity(0.6),
                    decoration: TextDecoration.none),
              ),
            ],
          ),
          (plus != 0)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                      Text(
                        value.toString().replaceAllMapped(reg, mathFunc),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        FeatherIcons.arrowUp,
                        size: 10,
                      ),
                      Text(
                        "${plus.toString().replaceAllMapped(reg, mathFunc)}",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    ])
              : Text(
                  value.toString().replaceAllMapped(reg, mathFunc),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
        ],
      ),
    );
  }
}