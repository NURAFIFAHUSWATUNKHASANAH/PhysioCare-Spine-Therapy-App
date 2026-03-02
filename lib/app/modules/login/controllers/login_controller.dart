import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyhsiocare/app/data/services/auth_services.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:pyhsiocare/app/routes/app_pages.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordHidden = true.obs;

  final AuthService _authService;

  LoginController({required AuthService authService}) : _authService = authService;

  void updateEmail(String value) => email.value = value;
  void updatePassword(String value) => password.value = value;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login() async {
  if (email.value.isEmpty || password.value.isEmpty) {
    Get.snackbar("Error", "Email dan Password harus diisi!");
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(ApiConfig.loginUrl), // contoh: http://10.13.234.167:5000/auth/login
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.value,
        'password': password.value,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userData = data['user'];

      print("Token JWT: $token");

      // Simpan token dan data user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_id', userData['_id']);
      await prefs.setString('user_nama', userData['nama']);
      await prefs.setString('user_email', userData['email']);
      if (userData['foto'] != null) {
        await prefs.setString('user_foto', userData['foto']);
      }
      await prefs.setString('login_method', 'manual');

      // Update ProfileController
      final profileController = Get.put(ProfileController());
      profileController.userId.value = userData['_id'];
      profileController.namaC.value = userData['nama'];
      profileController.emailC.value = userData['email'];
      profileController.foto.value = userData['foto'] ?? '';
      profileController.loginMethod.value = 'manual';

      Get.snackbar("Berhasil", "Selamat datang, ${userData['nama']}!");
      Get.offNamed(Routes.BOTTOM);
    } else {
      final res = jsonDecode(response.body);
      Get.snackbar("Gagal Login", res['message'] ?? "Email atau password salah");
    }
  } catch (e) {
    Get.snackbar("Error", "Terjadi kesalahan: $e");
  }
}


Future<void> loginWithGoogle() async {
  final result = await _authService.loginWithGoogle();

  if (result['success']) {
    final userData = result['user'];
    final token = result['token'];
    // Print token ke console log Flutter
    print("Token JWT: $token");

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', userData['_id']);
    await prefs.setString('user_nama_google', userData['nama']);
    await prefs.setString('user_email_google', userData['email']);
    await prefs.setString('login_method', 'google');

    final profileController = Get.put(ProfileController());
    profileController.namaC.value = userData['nama'] ?? '';
    profileController.emailC.value = userData['email'] ?? '';
    profileController.foto.value = userData['foto'] ?? '';
    profileController.loginMethod.value = 'google';

    Get.snackbar("Berhasil", "Login dengan Google berhasil");
    Get.offNamed(Routes.BOTTOM);
  } else {
    Get.snackbar("Gagal", result['message'] ?? "Login Google gagal");
  }
}

}