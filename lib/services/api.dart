class API {
  static final String host = 'us-central1-numometer.cloudfunctions.net';
  static final String basePath = 'api/';
  static final String countriesPath = 'app/listCountries';
  static final String jhuAllPath = 'v2/all';
  static final String jhucountriesPath = 'v2/countries';
  static final String jhuHost = 'disease.sh';
  static final String jhuBasePath = 'v2/historical';
  static final String localePath = 'app/indStats';
  static final String districtIndPath = 'app/indDistrict';
  static final String historicalINDPath = 'app/dataJson';
  static final String jhuAllBase = 'v2/jhucsse';
  static final String jhuVaccineData = 'v3/covid-19/vaccine';

  Uri endpointUri() => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhuAllPath'
  );

  Uri countriesUri() => Uri(
    scheme: 'https',
    host: host,
    path: '$countriesPath'
  );

  Uri countryInfoUri(String country) => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhucountriesPath'+'/'+country
  );

  Uri historicalData(String country) => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhuBasePath'+'/'+country
  );

  Uri localeData() => Uri(
    scheme:'https',
    host: host,
    path: '$historicalINDPath'
  );

  Uri districtData() => Uri(
    scheme: 'https',
    host: host,
    path: '$districtIndPath'
  );

  Uri getHistoricalIndia() => Uri(
    scheme: 'https',
    host: host,
    path: '$historicalINDPath'
  );

  Uri getProvinceData() => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhuAllBase'
  );

  Uri getVaccineData() => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhuVaccineData'
  );
}