class API {
  static final String host = 'covid19.mathdro.id';
  static final String basePath = 'api/';
  static final String countriesPath = 'api/countries';
  static final String jhuHost = 'corona.lmao.ninja';
  static final String jhuBasePath = 'v2/historical';

  Uri endpointUri() => Uri(
    scheme: 'https',
    host: host,
    path: '$basePath'
  );

  Uri countriesUri() => Uri(
    scheme: 'https',
    host: host,
    path: '$countriesPath'
  );

  Uri countryInfoUri(String country) => Uri(
    scheme: 'https',
    host: host,
    path: '$countriesPath'+'/'+country
  );

  Uri historicalData(String country) => Uri(
    scheme: 'https',
    host: jhuHost,
    path: '$jhuBasePath'+'/'+country
  );
}