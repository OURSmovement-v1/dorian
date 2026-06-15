class ApiConfig {
  static const String baseUrl = 'https://api.atmoshome.io';

  static String mediaUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }
}
