class ApiEndpoints {
  static const String baseUrl = '${const String.fromEnvironment('BASE_URL')}api';
  static const String login = '/runners/login';
  static const String runners = '/runners/';
  static const String addMarkers = '/markers';
  static const String viewMarkers = '/markers/display/all';
  static const String scanQRCode = '/logscan/scan';
}
