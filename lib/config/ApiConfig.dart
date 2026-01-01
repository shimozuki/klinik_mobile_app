class ApiConfig {
  static const bool isProd = bool.fromEnvironment('dart.vm.product');

  static String get baseUrl {
    if (isProd) {
      return '';
    } else {
      return 'http://192.168.1.5:8000/api';
    }
  }
}
