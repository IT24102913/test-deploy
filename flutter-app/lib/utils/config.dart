import 'package:http/http.dart' as http;

class ApiConfig {
  /// Set your live hosted backend URL here when deployed
  static const String customProductionHost = '';

  /// Can be overridden at build time via: flutter run --dart-define=API_URL=https://...
  static const String envApiUrl = String.fromEnvironment('API_URL');

  static String _activeHost = envApiUrl.isNotEmpty
      ? envApiUrl
      : (customProductionHost.isNotEmpty
          ? customProductionHost
          : 'http://192.168.1.8:5126');

  static final List<String> candidateHosts = [
    if (envApiUrl.isNotEmpty) envApiUrl,
    if (customProductionHost.isNotEmpty) customProductionHost,
    'http://127.0.0.1:5126',   // ADB reverse port forwarding (USB connected physical device)
    'http://192.168.1.8:5126', // LAN IPv4 address of PC
    'http://10.0.2.2:5126',     // Android Emulator default loopback
    'http://localhost:5126',    // Web / Direct local
  ];

  static String get baseUrl => '$_activeHost/api';
  static String get authUrl => '$baseUrl/auth';
  static String get labUrl => '$baseUrl/lab';
  static String get paymentsUrl => '$baseUrl/payments';
  static String get emrUrl => '$baseUrl/emr';
  static String get doctorsUrl => '$baseUrl/doctors';
  static String get appointmentsUrl => '$baseUrl/doctorappointments';

  /// Probe and set the fastest working backend host URL
  static Future<String> getWorkingBaseUrl() async {
    for (final host in candidateHosts) {
      try {
        final res = await http.get(Uri.parse('$host/api/Medicines')).timeout(const Duration(seconds: 2));
        if (res.statusCode == 200) {
          _activeHost = host;
          return '$host/api';
        }
      } catch (_) {}
    }
    return baseUrl;
  }
}
