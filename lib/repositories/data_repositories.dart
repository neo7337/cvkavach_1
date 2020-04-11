import 'dart:collection';

import 'package:cvkavach/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class DataRepository {
  DataRepository({@required this.apiService});
  final APIService apiService;

  Future<HashMap<String, String>> getEndpointData() async {
    try {
      return await apiService.getEndpointData();
    } on Response catch (response) {
      // if unauthorized, get access token again
      if (response.statusCode == 401) {
        return await apiService.getEndpointData();
      }
      rethrow;
    }
  }

  Future<SplayTreeMap<String, String>> getCountries() async {
    try{
      return await apiService.getCountries();
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getCountries();
      }
      rethrow;
    }
  }

  Future<HashMap<String, String>> getCountryInfo(String country) async {
    try{
      print('calling getCountryInfo datarepository ' + country);
      return await apiService.getCountryInfo(country);
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getCountryInfo(country);
      }
      rethrow;
    }
  }

  Future<List<List<HistoryStruct>>> getHistoricData(String country) async {
    try{
      print('calling getHistoricalData datarepository ' + country);
      return await apiService.getHistoricalData(country);
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getHistoricalData(country);
      }
      rethrow;
    }
  }

  Future<SplayTreeMap<String, List<int>>> getLocaleData() async {
    try{
      print('calling getLocaleData datarepository ');
      return await apiService.getLocaleData();
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getLocaleData();
      }
      rethrow;
    }
  }

}
