import 'dart:collection';

import 'package:cvkavach/repositories/data_repositories.dart';
import 'package:cvkavach/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CountrySearchProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CountrySearch(),
      ), create: (_) => DataRepository(apiService: APIService()),
    );
  }
}
class CountrySearch extends StatefulWidget {
  CountrySearch({Key key}) : super(key: key);
  @override
  _CountrySearchWidget createState() => _CountrySearchWidget();
}
class Merged{
  final String foo;
  final String bar;
  Merged({this.foo, this.bar});
}
/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;
  LinearSales(this.year, this.sales);
}
class _CountrySearchWidget extends State<CountrySearch> {
  void initState() {
    super.initState();
  }

  HashMap<String, String> countriesList = new HashMap<String, String>();
  SplayTreeMap<String, String> _countriesList = new SplayTreeMap<String, String>();
  Map<String, double> dataMap = new Map<String, double>();
  Map<String, String> finalResponseMap = new Map<String, String>();
  HashMap<String, String> responseMap = new HashMap<String, String>();
  List<List<HistoryStruct>> historyMapList = new List<List<HistoryStruct>>();
  String dropdownValue = 'IND';

  Future<String> _fetchCountries() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final countriesList = await dataRepository.getCountries();
    _countriesList = countriesList;
    return Future.value("OK");
  }

  Future<String> fetchCountryData(String input) async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    if(input == 'IND'){
      responseMap = await dataRepository.getCountryInfoInd();
    } else {
      responseMap = await dataRepository.getCountryInfo(input);
    }
    //responseMap = await dataRepository.getCountryInfo(input);
    finalResponseMap["Confirmed"]=responseMap['Confirmed'];
    finalResponseMap["Recovered"]=responseMap['Recovered'];
    finalResponseMap["Deaths"]=responseMap['Deaths'];
    finalResponseMap["Active"]=responseMap['Active'];
    finalResponseMap["TestsTaken"]=responseMap["TestsTaken"];
    finalResponseMap["LastUpdate"]=responseMap['LastUpdated'];
    return Future.value('OK');
  }
  
  List<HistoryStruct> c1 = new List<HistoryStruct>();
  List<HistoryStruct> d1 = new List<HistoryStruct>();
  List<HistoryStruct> r1 = new List<HistoryStruct>();

  Future<String> fetchHistoricalData(String input) async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    if(input == 'IND'){
      historyMapList = await dataRepository.getHistoricalDataInd();
    } else {
      historyMapList = await dataRepository.getHistoricData(input);
    }
    //print(historyMapList.toString());
    c1 = historyMapList[0];
    d1 = historyMapList[1];
    r1 = historyMapList[2];
    return Future.value('OK');
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Future.wait([_fetchCountries(), fetchCountryData(dropdownValue), fetchHistoricalData(dropdownValue)]), // function where you call your api
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

  Widget _buildBody() {
  return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: _buildDropdown() 
                ),
                //_CustomGraph(dataMap, "Cases"),
                Flexible(
                  flex: 1,
                  child: StackedAreaLineChart(
                    _createSampleData(c1, d1, r1),
                    // Disable animations for image tests.
                    animate: true,
                  ) 
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      _StatTile(Color(0xffffffff), 'Total Cases', int.parse(finalResponseMap['Confirmed'])),
                      _StatTile(Color(0xff0000ff), 'Active', int.parse(finalResponseMap['Active'])),
                      _StatTile(Color(0xffff653b), 'Deaths', int.parse(finalResponseMap['Deaths'])),
                      _StatTile(Color(0xff9ff794), 'Recovered', int.parse(finalResponseMap['Recovered'])),
                      _StatTile(Color(0xfff5c76a), 'Tests Taken', int.parse(finalResponseMap['TestsTaken'])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Last update ' + finalResponseMap['LastUpdate'],
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.4), 
                                fontSize: 10, 
                                decoration: TextDecoration.none),                  
                            )
                          )
                        ],
                      ),
                    ],
                  ) 
                ),
              ],
            )
          ),
          height: MediaQuery.of(context).size.height,
        )
      )
    );
  }
  
  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
              color: Colors.white, style: BorderStyle.solid, width: 0.80
            )
          ),
        child: new Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.black
          ),
          child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            underline: SizedBox(),
            style: TextStyle(color: Colors.white),
            onChanged: (String newValue) {
              setState(() => dropdownValue = newValue);
            },
            items: _countriesList
                .map((description, value) {
                    return MapEntry(
                        description,
                        DropdownMenuItem<String>(
                          value: value,
                          child: Text(description + ' ('+value+')'),
                        ));
                  })
                  .values
                  .toList(),
          ),
        )
        )
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

  /// Create one series with sample hard coded data.
  static List<charts.Series<HistoryStruct, DateTime>> _createSampleData(c1, d1, r1) {
    return [
      new charts.Series<HistoryStruct, DateTime>(
        id: 'Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HistoryStruct sales, _) => sales.date,
        measureFn: (HistoryStruct sales, _) => sales.count,
        data: c1,
      ),
      new charts.Series<HistoryStruct, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (HistoryStruct sales, _) => sales.date,
        measureFn: (HistoryStruct sales, _) => sales.count,
        data: d1,
      ),
      new charts.Series<HistoryStruct, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (HistoryStruct sales, _) => sales.date,
        measureFn: (HistoryStruct sales, _) => sales.count,
        data: r1,
      ),
    ];
  }
}

class StackedAreaLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  StackedAreaLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
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