import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyhsiocare/app/routes/app_pages.dart';
import 'package:pyhsiocare/config/api_config.dart';

class EditProfileController extends GetxController {
  final namaC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final currentNama = ''.obs;
  final currentEmail = ''.obs;
  final isLoading = false.obs;

  String? userId;
  bool isGoogleLogin = false;

  @override
  void onInit() {
    super.onInit();
    fetchUserIdAndData();
  }

  void fetchUserIdAndData() async {
    final prefs = await SharedPreferences.getInstance();

    // Cek apakah login Google atau manual
    final googleEmail = prefs.getString('googleEmail');
    if (googleEmail != null && googleEmail.isNotEmpty) {
      // Login Google terdeteksi
      isGoogleLogin = true;
      currentNama.value = prefs.getString('googleName') ?? '';
      currentEmail.value = googleEmail;

      namaC.text = currentNama.value;
      emailC.text = currentEmail.value;

      // Jika mau, kamu bisa sembunyikan password field di UI saat Google login
    } else {
      // Login manual
      userId = prefs.getString('user_id');
      if (userId == null) {
        Get.snackbar("Error", "User ID tidak ditemukan");
        return;
      }
      await fetchUserData();
    }
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Get.snackbar("Error", "Token tidak ditemukan");
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConfig.userProfileUrl(userId ?? '')),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        currentNama.value = data['nama'] ?? '';
        currentEmail.value = data['email'] ?? '';
        namaC.text = currentNama.value;
        emailC.text = currentEmail.value;
      } else {
        Get.snackbar("Gagal", "Tidak dapat mengambil data pengguna");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfile() async {
    // *IZINKAN* update profil untuk user Google juga
    // Jadi hapus atau komentar pengecekan ini
    // if (isGoogleLogin) {
    //   Get.snackbar("Info", "Profil Google tidak dapat diubah melalui aplikasi ini.");
    //   return;
    // }

    String newNama = namaC.text.trim();
    String newEmail = emailC.text.trim();
    String newPassword = passwordC.text.trim();

    Map<String, String> dataToUpdate = {};

    if (newNama.isNotEmpty && newNama != currentNama.value) {
      dataToUpdate['nama'] = newNama;
    }
    if (newEmail.isNotEmpty && newEmail != currentEmail.value) {
      dataToUpdate['email'] = newEmail;
    }
    if (!isGoogleLogin && newPassword.isNotEmpty) {
      // Biasanya user Google gak perlu atau gak bisa update password di sini
      dataToUpdate['password'] = newPassword;
    }

    if (dataToUpdate.isEmpty) {
      Get.snackbar("Info", "Tidak ada perubahan yang disimpan.");
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userIdToUse = isGoogleLogin ? prefs.getString('_id') : userId;

      if (token == null || userIdToUse == null) {
        Get.snackbar("Error", "Token atau User ID tidak ditemukan");
        return;
      }

      final response = await http.put(
        Uri.parse(ApiConfig.updateUserUrl(userIdToUse)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(dataToUpdate),
      );

      if (response.statusCode == 200) {
        // Update di ProfileController juga biar UI update
        final profileController = Get.find<ProfileController>();
        await profileController.fetchUserProfile();

        if (dataToUpdate.containsKey('nama')) currentNama.value = newNama;
        if (dataToUpdate.containsKey('email')) currentEmail.value = newEmail;
        passwordC.clear();

        await fetchUserData();

        // Update SharedPreferences juga supaya konsisten
        final prefs = await SharedPreferences.getInstance();
        if (dataToUpdate.containsKey('nama')) {
          if (isGoogleLogin) {
            await prefs.setString('googleName', newNama);
          } else {
            await prefs.setString('user_nama', newNama);
          }
        }
        if (dataToUpdate.containsKey('email')) {
          if (isGoogleLogin) {
            await prefs.setString('googleEmail', newEmail);
          } else {
            await prefs.setString('user_email', newEmail);
          }
        }

        Get.snackbar("Sukses", "Profil berhasil diperbarui.");
        Get.offAllNamed(Routes.BOTTOM, arguments: 3); // Arahkan ke tab profil
      } else {
        Get.snackbar("Gagal", "Password Minimal 6 Karakter");

      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }
}
