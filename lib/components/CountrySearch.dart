import 'dart:collection';

import 'package:cvkavach/extras/pieChart.dart';
import 'package:cvkavach/repositories/data_repositories.dart';
import 'package:cvkavach/services/api_service.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _CountrySearchWidget extends State<CountrySearch> {
  void initState() {
    super.initState();
    //fetchCountryData('IND');
  }

  HashMap<String, String> countriesList = new HashMap<String, String>();
  SplayTreeMap<String, String> _countriesList = new SplayTreeMap<String, String>();
  Map<String, double> dataMap = new Map<String, double>();
  Map<String, String> finalResponseMap = new Map<String, String>();
  HashMap<String, String> responseMap = new HashMap<String, String>();
  String dropdownValue = 'IND';

  Future<String> _fetchCountries() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final countriesList = await dataRepository.getCountries();
    print('print'+countriesList.toString());
    _countriesList = countriesList;
    return Future.value("OK");
  }

  Future<String> fetchCountryData(String input) async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    responseMap = await dataRepository.getCountryInfo(input);
    print('country info CountryData.dart' + responseMap.toString());
    //final countriesList = await dataRepository.getCountries();
    dataMap["active"]=double.parse(responseMap['Active']);
    dataMap["dead"]=double.parse(responseMap['Deaths']);
    dataMap["ok"]=double.parse(responseMap['Recovered']);
    finalResponseMap["Confirmed"]=responseMap['Confirmed'];
    finalResponseMap["Recovered"]=responseMap['Recovered'];
    finalResponseMap["Deaths"]=responseMap['Deaths'];
    finalResponseMap["Active"]=responseMap['Active'];
    finalResponseMap["LastUpdate"]=responseMap['LastUpdate'];
    return Future.value('OK');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: Future.wait([_fetchCountries(), fetchCountryData(dropdownValue)]), // function where you call your api
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

  Widget _buildBody() {
  print('building widget ' + dataMap.toString() + ' ' + finalResponseMap.toString());
  return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildDropdown(),
          _CustomGraph(dataMap, "Cases"),
          Column(
            children: <Widget>[
              _StatTile(Color(0xffffffff), 'Total Cases', int.parse(finalResponseMap['Confirmed'])),
              _StatTile(Color(0xfff5c76a), 'Active', int.parse(finalResponseMap['Active'])),
              _StatTile(Color(0xffff653b), 'Deaths', int.parse(finalResponseMap['Deaths'])),
              _StatTile(Color(0xff9ff794), 'Recovered', int.parse(finalResponseMap['Recovered'])),
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
          ),
        ],
      ),
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
              //fetchCountryData(dropdownValue);
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