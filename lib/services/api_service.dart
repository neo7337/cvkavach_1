import 'dart:collection';
import 'dart:convert';

import 'package:cvkavach/services/api.dart';
import 'package:http/http.dart' as http;

class Countries {
  final String name;
  final String iso3;
  Countries(this.name, this.iso3);
}

class RegionalData {
  final String state;
  final int total;
  final int deaths;
  final int recovered;
  RegionalData(this.state, this.total, this.deaths, this.recovered);
}

class HistoryStruct {
  final DateTime date;
  final int count;
  HistoryStruct(this.date, this.count);
}

class APIService {
  final API api = new API();

  HashMap<String, String> responseMap = new HashMap<String, String>();
  List<String> countriesMap = new List<String>();
  SplayTreeMap<String, String> countriesList = new SplayTreeMap<String, String>();
  SplayTreeMap<String, List<int>> regionalDataList = new SplayTreeMap<String, List<int>>();

  Future<HashMap<String, String>> getEndpointData() async {
    final uri = api.endpointUri();
    //print(uri);
    final response = await http.get(
      uri.toString(),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      responseMap['Confirmed']=json.decode(response.body)["cases"].toString();
      responseMap['Recovered']=json.decode(response.body)["recovered"].toString();
      responseMap['Deaths']=json.decode(response.body)["deaths"].toString();
      responseMap['Active']=json.decode(response.body)["active"].toString();
      int timestamp = json.decode(response.body)["updated"];
      var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
      responseMap['LastUpdated']=date.toString();
      return responseMap;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<HashMap<String, String>> getCountryInfo(String country) async {
    final uri = api.countryInfoUri(country);
    print(uri);
    final response = await http.get(
      uri.toString(),
      headers: {'Accept': 'application/json'}
    );
    if(response.statusCode == 200){
      responseMap['Confirmed']=json.decode(response.body)["cases"].toString();
      responseMap['Recovered']=json.decode(response.body)["recovered"].toString();
      responseMap['Deaths']=json.decode(response.body)["deaths"].toString();
      responseMap['Active']=json.decode(response.body)["active"].toString();
      responseMap['TestsTaken']=json.decode(response.body)["tests"].toString();
      int timestamp = json.decode(response.body)["updated"];
      var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
      responseMap['LastUpdated']=date.toString();
      return responseMap;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<SplayTreeMap<String, List<int>>> getLocaleData() async {
    final uri = api.localeData();
    print(uri);
    final response = await http.get(
      uri.toString(),
      headers: {'Accept': 'application/json'}
    );
    if(response.statusCode == 200){
      responseMap['Confirmed']=json.decode(response.body)["cases"].toString();
      List<dynamic> regionalList = json.decode(response.body)["data"]["regional"];
      List<RegionalData> regional = new List<RegionalData>();
      regionalList.forEach((f) {
        RegionalData s = APIService.newJsonMap(f);
        regional.add(s);
      });
      regional.forEach( (val) => {
        regionalDataList[val.state.toString()]=[val.total, val.deaths, val.recovered]
      });
      return regionalDataList;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<SplayTreeMap<String, String>> getCountries() async {
    final uri = api.countriesUri();
    //print(uri);
    final response = await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if(response.statusCode == 200 ){
      print('Countries List fetched');
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      List<dynamic> dynamicList = decodedMap['countries'];
      List<Countries> countries = new List<Countries>();
      dynamicList.forEach((f) {
        Countries s = APIService.fromJsonMap(f);
        countries.add(s);
      });
      countries.forEach( (val) => {
        if(val.iso3 != null)
          countriesList[val.name.toString()]=val.iso3.toString()
      });
      return countriesList;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<List<List<HistoryStruct>>> getHistoricalData(String country) async {
    final uri = api.historicalData(country);
    //print(uri);
    final response = await http.get(
      uri.toString(),
      headers: {'Accept': 'application/json'}
    );
    if(response.statusCode == 200 ){
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      List<HistoryStruct> casesList = new List<HistoryStruct>();
      List<HistoryStruct> deathsList = new List<HistoryStruct>();
      List<HistoryStruct> recoveredList = new List<HistoryStruct>();
      List<List<HistoryStruct>> historyData = new List<List<HistoryStruct>>();
      for(var key in decodedMap['timeline']['cases'].keys) {
        casesList.add(new HistoryStruct(new DateTime(int.parse("20"+key.toString().split("/")[2]), 
        int.parse(key.toString().split("/")[0]), 
          int.parse(key.toString().split("/")[1])), decodedMap['timeline']['cases'][key]));
      }
      historyData.add(casesList);
      for(var key in decodedMap['timeline']['deaths'].keys) {
        deathsList.add(new HistoryStruct(new DateTime(int.parse("20"+key.toString().split("/")[2]), 
        int.parse(key.toString().split("/")[0]), 
          int.parse(key.toString().split("/")[1])), decodedMap['timeline']['deaths'][key]));
      }
      historyData.add(deathsList);
      for(var key in decodedMap['timeline']['recovered'].keys) {
        recoveredList.add(new HistoryStruct(new DateTime(int.parse("20"+key.toString().split("/")[2]), 
        int.parse(key.toString().split("/")[0]), 
          int.parse(key.toString().split("/")[1])), decodedMap['timeline']['recovered'][key]));
      }
      historyData.add(recoveredList);
      return historyData;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Countries fromJsonMap(Map<String, dynamic> json) {
    String name = json['name'];
    String iso3 = json['iso3'];
    Countries s = new Countries(name, iso3);
    return s;
  }

  static RegionalData newJsonMap(Map<String, dynamic> json) {
    String state = json['loc'];
    int total = json['totalConfirmed'];
    int deaths = json['deaths'];
    int recovered = json['discharged'];
    return new RegionalData(state, total, deaths, recovered);
  }


}