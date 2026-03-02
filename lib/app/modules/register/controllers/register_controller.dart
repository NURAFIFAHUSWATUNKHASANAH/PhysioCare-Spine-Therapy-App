import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/config/api_config.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  void register() async {
    final String nama = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      _showError("Semua field harus diisi");
      return;
    }

    if (!isValidEmail(email)) {
      _showError("Format email tidak valid");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nama": nama,
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      print("Register response: $data");

      if (response.statusCode == 201) {
        var userId = data["user_id"];

        // Periksa null dan kosong dengan aman
        if (userId == null || userId.toString().trim().isEmpty) {
          _showError("User ID tidak ditemukan, silakan coba lagi");
          return;
        }

        // Konversi ke String jika perlu
        if (userId is! String) {
          userId = userId.toString();
        }

        Get.snackbar("Sukses", "Kode OTP sudah dikirim ke email Anda",
            snackPosition: SnackPosition.BOTTOM);

        // Navigasi ke halaman verifikasi OTP dengan user_id
        Get.toNamed("/verify-otp", arguments: {"user_id": userId});
      } else {
        _showError(data["message"] ?? "Gagal mendaftar");
      }
    } catch (e) {
      _showError("Terjadi kesalahan koneksi: $e");
    }
  }

  void _showError(String message) {
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white);
  }
}
