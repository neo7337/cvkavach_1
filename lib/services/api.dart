class API {
  static final String host = 'covid19.mathdro.id';
  static final String basePath = 'api/';
  static final String countriesPath = 'api/countries';
  static final String jhuAllPath = 'v2/all';
  static final String jhucountriesPath = 'v2/countries';
  static final String jhuHost = 'corona.lmao.ninja';
  static final String jhuBasePath = 'v2/historical';
  static final String localeHost = 'api.rootnet.in';
  static final String localePath = 'covid19-in/stats/latest';
  static final String districtIndHost = 'api.covid19india.org';
  static final String districtIndPath = 'v2/state_district_wise.json';
  static final String historicalINDHost = 'api.covid19india.org';
  static final String historicalINDPath = 'data.json';
  static final String jhuAllBase = 'v2/jhucsse';

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
    host: historicalINDHost,
    path: '$historicalINDPath'
  );

  Uri districtData() => Uri(
    scheme: 'https',
    host: districtIndHost,
    path: '$districtIndPath'
  );

  Uri getHistoricalIndia() => Uri(
    scheme: 'https',
    host: historicalINDHost,
    path: '$historicalINDPath'
  );

  Uri getProvinceData() => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhuAllBase'
  );
}