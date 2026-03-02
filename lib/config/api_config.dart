class ApiConfig {
  static String _baseUrl = '';

  // Getter untuk baseUrl
  static String get baseUrl => _baseUrl;

  // Setter untuk baseUrl (dengan normalisasi)
  static set baseUrl(String url) {
    _baseUrl = url.trim();
    if (_baseUrl.endsWith('/')) {
      _baseUrl = _baseUrl.substring(0, _baseUrl.length - 1);
    }
    print('Base URL updated to: $_baseUrl');

    
  }
  
  // Inisialisasi baseUrl default
  static void init() {
    _baseUrl = 'http://192.168.1.9:5000';
    print('Base URL updated to: $_baseUrl');
  }

  // ---------------- Auth ----------------
  static String get registerUrl => '$_baseUrl/auth/register';
  static String get loginUrl => '$_baseUrl/auth/login';
  static String get loginGoogleUrl => '$_baseUrl/auth/google';

  // ---------------- User ----------------
  static String userProfileUrl(String userId) => '$_baseUrl/user/$userId';
  static String uploadProfilePictureUrl(String userId )=> '$_baseUrl/static/images/uploads/profile_pictures/';
  static String updateUserUrl(String userId) => '$_baseUrl/user/$userId';

  // ---------------- Histori ----------------
  static String get historiUrl => '$_baseUrl/histori';
  static String historiUrlByUser(String userId) => '$_baseUrl/histori/$userId';

  // ---------------- Artikel ----------------
  static String get artikelUrl => '$_baseUrl/api/artikel';
  static String artikelDetailUrl(String id) => '$artikelUrl/$id';

  // ---------------- Jadwal (contoh tambahan) ----------------
  static String get jadwalUrl => '$_baseUrl/jadwal';
    // ---------------- Token ----------------
  static String get updateTokenUri => '$_baseUrl/update_token';

  // ---------------- Forgot Password ----------------
  static String get forgotPasswordUrl => '$_baseUrl/forgot_password';


  static String get verifyOtpUrl => '$_baseUrl/auth/verify-otp';

}
