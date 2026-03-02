import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

import 'package:pyhsiocare/config/api_config.dart';

class AuthService {
  final GetStorage _storage = GetStorage();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
    serverClientId: '945236677336-pl4ua4gp1p388u0131uouanod6av77gp.apps.googleusercontent.com',
  );

  /// Standard login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['token'] != null) {
        _storage.write('token', body['token']);
        return {'success': true, 'data': body};
      } else {
        return {'success': false, 'message': body['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  /// Google Sign-In login
  // Future<Map<String, dynamic>> loginWithGoogle() async {
  //   try {
  //     final googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       print('User cancelled sign in');
  //       return {'success': false, 'message': 'User cancelled sign-in'};
  //     }

  //     final googleAuth = await googleUser.authentication;
  //     //final tokenToSend = googleAuth.idToken ?? googleAuth.accessToken;

  //     print('accessToken: ${googleAuth.accessToken}');
  //     print('idToken: ${googleAuth.idToken}');

  //     // final response = await http.post(
  //     //   Uri.parse(ApiConfig.loginGoogleUrl),
  //     //   headers: {'Content-Type': 'application/json'},
  //     //   body: jsonEncode({'access_token': tokenToSend}),
  //     // );
  //      final response = await http.post(
  //       Uri.parse(ApiConfig.loginGoogleUrl), // <-- Define this in ApiConfig
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'idToken': googleAuth.idToken}),
  //     );

  //     final body = jsonDecode(response.body);

  //     if (response.statusCode == 200 && body['token'] != null) {
  //       _storage.write('token', body['token']);
  //       return {
  //         'success': true,
  //         'user': body['user'],
  //         'token': body['token'],
  //       };
  //     } else {
  //       return {
  //         'success': false,
  //         'message': body['message'] ?? 'Login Google gagal'
  //       };
  //     }
  //   } catch (e) {
  //     return {'success': false, 'message': 'Google login error: $e'};
  //   }
  // }
  Future<Map<String, dynamic>> loginWithGoogle() async {
  try {
    final googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      print('User cancelled sign in');
      return {'success': false, 'message': 'User cancelled sign-in'};
    }

    final googleAuth = await googleUser.authentication;

    final response = await http.post(
      Uri.parse(ApiConfig.loginGoogleUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': googleAuth.idToken}),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['token'] != null) {
      // Simpan token dan user data ke GetStorage
      _storage.write('token', body['token']);
      _storage.write('user_id', body['user']['_id']);   // PENTING!
      _storage.write('user_name', body['user']['nama']);
      _storage.write('user_email', body['user']['email']);

      return {
        'success': true,
        'user': body['user'],
        'token': body['token'],
      };
    } else {
      return {
        'success': false,
        'message': body['message'] ?? 'Login Google gagal'
      };
    }
  } catch (e) {
    return {'success': false, 'message': 'Google login error: $e'};
  }
}

}
