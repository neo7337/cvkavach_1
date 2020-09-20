import 'dart:collection';
import 'dart:convert';

import 'package:numometer/services/api.dart';
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

class DistrictData {
  final String district;
  final int confirmed;
  DistrictData(this.district, this.confirmed);
}

class VaccinePhases {
  final String phase;
  final String candidates;
  VaccinePhases(this.phase, this.candidates);
}

class VaccineData {
  final List<VDataStruct> vDataStruct;
  final String totalCandidates;
  final List<VaccinePhases> phases;
  VaccineData(this.vDataStruct, this.totalCandidates, this.phases);
}

class VDataStruct {
  final String candidate;
  final String sponsors;
  final String trialPhase;
  final String institutions;
  final String funding;
  final String details;
  VDataStruct(
      this.candidate, this.sponsors, this.trialPhase, this.institutions, this.details, this.funding);
}

var year = 2020;
var months = {
  'January': '1',
  'February': '2',
  'March': '3',
  'April': '4',
  'May': '5',
  'June': '6',
  'July': '7',
  'August': '8',
  'September': '9',
  'October': '10',
  'November': '11',
  'Decemeber': '12'
};

class APIService {
  final API api = new API();

  HashMap<String, String> responseMap = new HashMap<String, String>();
  List<String> countriesMap = new List<String>();
  SplayTreeMap<String, String> countriesList =
      new SplayTreeMap<String, String>();
  SplayTreeMap<int, List<String>> regionalDataList =
      new SplayTreeMap<int, List<String>>();
  SplayTreeMap<int, List<String>> provincesData =
      new SplayTreeMap<int, List<String>>();
  SplayTreeMap<int, HashMap<String, List<int>>> finalRegionalList =
      new SplayTreeMap<int, HashMap<String, List<int>>>();
  HashMap<String, List<DistrictData>> districtResponse =
      new HashMap<String, List<DistrictData>>();

  Future<HashMap<String, String>> getEndpointData() async {
    final uri = api.endpointUri();
    //print(uri);
    final response = await http.get(
      uri.toString(),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      //print(json.decode(response.body));
      responseMap['Confirmed'] = json.decode(response.body)["cases"].toString();
      responseMap['Recovered'] =
          json.decode(response.body)["recovered"].toString();
      responseMap['Deaths'] = json.decode(response.body)["deaths"].toString();
      responseMap['Active'] = json.decode(response.body)["active"].toString();
      int timestamp = json.decode(response.body)["updated"];
      var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
      responseMap['LastUpdated'] = date.toString();
      return responseMap;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<HashMap<String, String>> getCountryInfo(String country) async {
    final uri = api.countryInfoUri(country);
    //print(uri);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      responseMap['Confirmed'] = json.decode(response.body)["cases"].toString();
      responseMap['Recovered'] =
          json.decode(response.body)["recovered"].toString();
      responseMap['Deaths'] = json.decode(response.body)["deaths"].toString();
      responseMap['Active'] = json.decode(response.body)["active"].toString();
      responseMap['TestsTaken'] =
          json.decode(response.body)["tests"].toString();
      int timestamp = json.decode(response.body)["updated"];
      var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
      responseMap['LastUpdated'] = date.toString();
      return responseMap;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<SplayTreeMap<int, List<String>>> getLocaleData() async {
    final uri = api.localeData();
    //print(uri);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> regionalList = json.decode(response.body)["statewise"];
      List<RegionalData> regional = new List<RegionalData>();
      regionalList.forEach((f) {
        RegionalData s = APIService.newJsonMap(f);
        regional.add(s);
      });
      regional.forEach((val) => {
            regionalDataList[val.total] = [
              val.state,
              val.total.toString(),
              val.deaths.toString(),
              val.recovered.toString()
            ]
          });
      return regionalDataList;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<List<String>> getProvinces(String country) async {
    final uri = api.historicalData(country);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedMap = json.decode(response.body);
      List<dynamic> prov = decodedMap["province"];
      List<String> provinces = new List<String>();
      prov.forEach((f) {
        provinces.add(f);
      });
      return provinces;
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<SplayTreeMap<String, String>> getCountries() async {
    final uri = api.countriesUri();
    //print(uri);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      print('Countries List fetched');
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      List<dynamic> dynamicList = decodedMap['countries'];
      List<Countries> countries = new List<Countries>();
      dynamicList.forEach((f) {
        Countries s = APIService.fromJsonMap(f);
        countries.add(s);
      });
      countries.forEach((val) => {
            if (val.iso3 != null)
              countriesList[val.name.toString()] = val.iso3.toString()
          });
      return countriesList;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<List<List<HistoryStruct>>> getHistoricalDataInd() async {
    final uri = api.getHistoricalIndia();
    //print(uri);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      List<HistoryStruct> casesList = new List<HistoryStruct>();
      List<HistoryStruct> deathsList = new List<HistoryStruct>();
      List<HistoryStruct> recoveredList = new List<HistoryStruct>();
      List<List<HistoryStruct>> historyData = new List<List<HistoryStruct>>();
      List<dynamic> indHist = decodedMap['cases_time_series'];
      List<IndHistoricData> indList = new List<IndHistoricData>();
      indHist.forEach((f) {
        IndHistoricData i = APIService.indJsonMap(f);
        indList.add(i);
      });
      //print('ndsds sieze'+indList.length.toString());
      indList.forEach((val) {
        casesList.add(new HistoryStruct(
            new DateTime(year, int.parse(months[val.date.split(" ")[1]]),
                int.parse(val.date.split(" ")[0])),
            int.parse(val.cases)));
        deathsList.add(new HistoryStruct(
            new DateTime(year, int.parse(months[val.date.split(" ")[1]]),
                int.parse(val.date.split(" ")[0])),
            int.parse(val.deaths)));
        recoveredList.add(new HistoryStruct(
            new DateTime(year, int.parse(months[val.date.split(" ")[1]]),
                int.parse(val.date.split(" ")[0])),
            int.parse(val.recovered)));
      });
      historyData.add(casesList);
      historyData.add(deathsList);
      historyData.add(recoveredList);
      return historyData;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<HashMap<String, List<DistrictData>>> getDistrictData() async {
    final uri = api.districtData();
    //print(uri);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> indDist = jsonDecode(response.body);
      indDist.forEach((f) {
        List<dynamic> ls = f["districtData"];
        List<DistrictData> distList = new List<DistrictData>();
        ls.forEach((val) {
          DistrictData d = APIService.disJson(val);
          distList.add(d);
        });
        districtResponse[f["state"]] = distList;
      });
      return districtResponse;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<HashMap<String, String>> getCountryInfoInd() async {
    final uri = api.getHistoricalIndia();
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      responseMap['Confirmed'] =
          json.decode(response.body)["statewise"][0]['confirmed'].toString();
      responseMap['Recovered'] =
          json.decode(response.body)["statewise"][0]['recovered'].toString();
      responseMap['Deaths'] =
          json.decode(response.body)["statewise"][0]['deaths'].toString();
      responseMap['Active'] =
          json.decode(response.body)["statewise"][0]['active'].toString();
      List<dynamic> tests = decodedMap['tested'];
      responseMap['TestsTaken'] = json.decode(response.body)['tested'][tests.length-1]['totalsamplestested'].toString();
      responseMap['LastUpdated'] = json
          .decode(response.body)["statewise"][0]['lastupdatedtime']
          .toString();
      return responseMap;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<List<List<HistoryStruct>>> getHistoricalData(String country) async {
    final uri = api.historicalData(country);
    //print(uri);
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      List<HistoryStruct> casesList = new List<HistoryStruct>();
      List<HistoryStruct> deathsList = new List<HistoryStruct>();
      List<HistoryStruct> recoveredList = new List<HistoryStruct>();
      List<List<HistoryStruct>> historyData = new List<List<HistoryStruct>>();
      for (var key in decodedMap['timeline']['cases'].keys) {
        casesList.add(new HistoryStruct(
            new DateTime(
                int.parse("20" + key.toString().split("/")[2]),
                int.parse(key.toString().split("/")[0]),
                int.parse(key.toString().split("/")[1])),
            decodedMap['timeline']['cases'][key]));
      }
      historyData.add(casesList);
      for (var key in decodedMap['timeline']['deaths'].keys) {
        deathsList.add(new HistoryStruct(
            new DateTime(
                int.parse("20" + key.toString().split("/")[2]),
                int.parse(key.toString().split("/")[0]),
                int.parse(key.toString().split("/")[1])),
            decodedMap['timeline']['deaths'][key]));
      }
      historyData.add(deathsList);
      for (var key in decodedMap['timeline']['recovered'].keys) {
        recoveredList.add(new HistoryStruct(
            new DateTime(
                int.parse("20" + key.toString().split("/")[2]),
                int.parse(key.toString().split("/")[0]),
                int.parse(key.toString().split("/")[1])),
            decodedMap['timeline']['recovered'][key]));
      }
      historyData.add(recoveredList);
      return historyData;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<SplayTreeMap<int, List<String>>> getProvinceData(
      String country) async {
    final uri = api.getProvinceData();
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> decodedMap = jsonDecode(response.body);
      List<PVDataStruct> pvData = new List<PVDataStruct>();
      decodedMap.forEach((v) {
        if (v['country'].toString().toLowerCase() == country.toLowerCase()) {
          PVDataStruct s = APIService.pvJsonMap(v);
          pvData.add(s);
        }
      });
      pvData.forEach((v) => {
            provincesData[int.parse(v.total)] = [
              v.province,
              v.total,
              v.deaths,
              v.recovered
            ]
          });
      return provincesData;
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<VaccineData> getVaccineData() async {
    //print("calling vaccine data");
    final uri = api.getVaccineData();
    final response =
        await http.get(uri.toString(), headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      Map<String, dynamic> decodedMap = jsonDecode(response.body);
      List<dynamic> decodedList = decodedMap["data"];
      List<dynamic> phasesList = decodedMap["phases"];
      List<VDataStruct> vData = new List<VDataStruct>();
      List<VaccinePhases> vpData = new List<VaccinePhases>();
      decodedList.forEach((v) {
        VDataStruct vs = APIService.vJsonMap(v);
        vData.add(vs);
      });
      phasesList.forEach((v) {
        VaccinePhases vp = APIService.vpJsonMap(v);
        vpData.add(vp);
      });
      return new VaccineData(vData, json.decode(response.body)["totalCandidates"].toString(), vpData);
    }
    print(
        'Countries Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static VaccinePhases vpJsonMap(Map<String, dynamic> json) {
    String phase = json['phase'].toString();
    String candidates = json['candidates'].toString();
    return new VaccinePhases(phase, candidates);
  }

  static VDataStruct vJsonMap(Map<String, dynamic> json) {
    String candidate = json['candidate'].toString();
    String sponsors = json['sponsors'].toString();
    String trialPhase = json['trialPhase'].toString();
    String institutions = json['institutions'].toString();
    String details = json['details'].toString();
    String funding = (json['funding'].toString() == "null") ? "N/A" : json['funding'].toString();
    return new VDataStruct(candidate, sponsors, trialPhase, institutions, details, funding);
  }

  static PVDataStruct pvJsonMap(Map<String, dynamic> json) {
    String province = json['province'].toString();
    String total = json['stats']['confirmed'].toString();
    String deaths = json['stats']['deaths'].toString();
    String recovered = json['stats']['recovered'].toString();
    return new PVDataStruct(province, total, deaths, recovered);
  }

  static Countries fromJsonMap(Map<String, dynamic> json) {
    String name = json['name'];
    String iso3 = json['iso3'];
    Countries s = new Countries(name, iso3);
    return s;
  }

  static RegionalData newJsonMap(Map<String, dynamic> json) {
    String state = json['state'].toString();
    int total = int.parse(json['confirmed'].toString());
    int deaths = int.parse(json['deaths'].toString());
    int recovered = int.parse(json['recovered'].toString());
    return new RegionalData(state, total, deaths, recovered);
  }

  static IndHistoricData indJsonMap(Map<String, dynamic> json) {
    //print('intjson: '+json['date'].toString());
    String date = json['date'].toString();
    String cases = json['totalconfirmed'].toString();
    String deaths = json['totaldeceased'].toString();
    String recovered = json['totalrecovered'].toString();
    return new IndHistoricData(date, cases, deaths, recovered);
  }

  static DistrictData disJson(Map<String, dynamic> json) {
    String district = json["district"];
    int confirmed = json["confirmed"];
    return new DistrictData(district, confirmed);
  }
}

class PVDataStruct {
  final String province;
  final String total;
  final String deaths;
  final String recovered;
  PVDataStruct(this.province, this.total, this.deaths, this.recovered);
}

class IndHistoricData {
  final String date;
  final String cases;
  final String deaths;
  final String recovered;
  IndHistoricData(this.date, this.cases, this.deaths, this.recovered);
}
