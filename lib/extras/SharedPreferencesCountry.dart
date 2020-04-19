import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCountry {

  addCountry(String country) async {
    //print('saving shared prefernece: ' + country);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('countryValue', country);
  }

  getCountry() async {
    //print('fetching shared prefernece: ');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('countryValue');
    return stringValue;
  }

}