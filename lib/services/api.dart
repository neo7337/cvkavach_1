class API {
  static final String host = 'covid19.mathdro.id';
  static final String basePath = 'api/';
  static final String countriesPath = 'api/countries';

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

}