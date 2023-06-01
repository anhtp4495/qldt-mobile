class ApiEndpoints {
  ApiEndpoints._privateConstructor();
  static final ApiEndpoints _instance = ApiEndpoints._privateConstructor();
  static ApiEndpoints get instance => _instance;

  final String protocol = "https";
  final String domainName = "qldt-hufi.dev";
  final String apiPrefix = "api";
  final String apiVersion = "v1";
  
  final String _oauth = "oauth2";
  final String _login = "login";
  final String _token = "token";
  final String _attendance = "diemdanh";
  final String _activity = "hoatdong";
  final String _sessionList = "danhsachbuoi";
  final String _studentList = "danhsachsinhvien";

  ApiEndpoints();

  String get baseUrl => '$protocol://$domainName/$apiPrefix/$apiVersion';
  String get tokenEndpoint => '$baseUrl/$_oauth/$_token';
  String get loginEndpoint => '$baseUrl/$_oauth/$_login';
  String get attendanceEndpoint => '$baseUrl/$_attendance';
  String get activityEndpoint => '$baseUrl/$_activity';
  String get activitySessionEndpoint => '$baseUrl/$_activity/$_sessionList';
  String get studentAttendanceEndpoint => '$baseUrl/$_activity/$_studentList';
}