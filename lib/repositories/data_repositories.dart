import 'dart:collection';

import 'package:numometer/services/api_service.dart';
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
      //print('calling getCountryInfo datarepository ' + country);
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
      //print('calling getHistoricalData datarepository ' + country);
      return await apiService.getHistoricalData(country);
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getHistoricalData(country);
      }
      rethrow;
    }
  }

  Future<SplayTreeMap<int, List<String>>> getLocaleData() async {
    try{
      //print('calling getLocaleData datarepository ');
      return await apiService.getLocaleData();
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getLocaleData();
      }
      rethrow;
    }
  }

  Future<HashMap<String, List<DistrictData>>> getDistrictData() async {
    try{
      //print('calling getDistrictData datarepository ');
      return await apiService.getDistrictData();
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getDistrictData();
      }
      rethrow;
    }
  }

  Future<List<List<HistoryStruct>>> getHistoricalDataInd() async {
    try{
      //print('calling getDistrictData datarepository ');
      return await apiService.getHistoricalDataInd();
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getHistoricalDataInd();
      }
      rethrow;
    }
  }

  Future<HashMap<String, String>> getCountryInfoInd() async {
    try{
      //print('calling getCountryInfoInd datarepository ');
      return await apiService.getCountryInfoInd();
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getCountryInfoInd();
      }
      rethrow;
    }
  }

  Future<List<String>> getProvinces(String country) async {
    try{
      //print('calling fetchingprovinces datarepository ');
      return await apiService.getProvinces(country);
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getProvinces(country);
      }
      rethrow;
    }
  }

  Future<SplayTreeMap<int, List<String>>> getProvinceData(String country) async {
    try{
      //print('calling getProvinceData datarepository ');
      return await apiService.getProvinceData(country);
    } on Response catch (response) {
      if(response.statusCode == 401 ){
        return await apiService.getProvinceData(country);
      }
      rethrow;
    }
  }
}
