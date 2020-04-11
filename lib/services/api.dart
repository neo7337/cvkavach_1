class API {
  static final String host = 'covid19.mathdro.id';
  static final String basePath = 'api/';
  static final String countriesPath = 'api/countries';
  static final String jhuAllPath = 'all';
  static final String jhucountriesPath = 'countries';
  static final String jhuHost = 'corona.lmao.ninja';
  static final String jhuBasePath = 'v2/historical';
  static final String localeHost = 'api.rootnet.in';
  static final String localePath = 'covid19-in/stats/latest';

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
    host: localeHost,
    path: '$localePath'
  );
}