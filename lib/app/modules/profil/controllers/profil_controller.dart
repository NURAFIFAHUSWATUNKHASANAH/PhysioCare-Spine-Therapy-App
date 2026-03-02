import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {

  /// ===== STATE USER =====
  var userId = "".obs;
  var namaC = "".obs;
  var emailC = "".obs;
  var loginMethod = "".obs;
  var foto = "".obs;
  var image = Rx<File?>(null);

  /// ===== IMAGE PICKER =====
  final ImagePicker _picker = ImagePicker();
  var isPicking = false.obs;

  /// =============================
  /// INIT CONTROLLER
  /// =============================
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// =============================
  /// LOAD USER DATA
  /// =============================
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userId.value = prefs.getString('user_id') ?? '';
    loginMethod.value = prefs.getString('login_method') ?? '';

    /// reset image preview supaya tidak ikut akun sebelumnya
    image.value = null;

    if (userId.value.isNotEmpty) {
      await fetchUserProfile();
    }
  }

  /// =============================
  /// GET TOKEN
  /// =============================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// =============================
  /// FETCH PROFILE
  /// =============================
  Future<void> fetchUserProfile() async {

    if (userId.value.isEmpty) return;

    try {

      final token = await getToken();
      if (token == null) return;

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/user/${userId.value}'),
        headers: {
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        namaC.value = data['nama'] ?? '';
        emailC.value = data['email'] ?? '';
        foto.value = data['foto'] ?? '';

      } else {

        safeSnackbar("Error", "Gagal mengambil profil (${response.statusCode})");

      }

    } catch (e) {

      safeSnackbar("Error", "Terjadi kesalahan");

    }

  }

  /// =============================
  /// PICK IMAGE
  /// =============================
  Future<void> pickImageFromGallery() async {

    if (isPicking.value) return;

    isPicking.value = true;

    try {

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {

        File file = File(pickedFile.path);

        /// preview langsung
        image.value = file;

        await uploadProfileImage(file);

      }

    } catch (e) {

      safeSnackbar("Error", "Gagal memilih gambar");

    } finally {

      isPicking.value = false;

    }

  }

  /// =============================
  /// UPLOAD PROFILE IMAGE
  /// =============================
  Future<void> uploadProfileImage(File file) async {

    try {

      final token = await getToken();
      if (token == null) return;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/upload_profile_picture/${userId.value}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {

        await fetchUserProfile();

        safeSnackbar("Berhasil", "Foto profil berhasil diperbarui");

      } else {

        safeSnackbar("Error", "Upload gagal (${response.statusCode})");

      }

    } catch (e) {

      safeSnackbar("Error", "Terjadi kesalahan upload");

    }

  }

  /// =============================
  /// SNACKBAR AMAN
  /// =============================
  void safeSnackbar(String title, String message) {

    if (Get.context != null) {

      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
      );

    }

  }

  /// =============================
  /// NAVIGASI
  /// =============================
  void editProfile() {
    Get.toNamed('/edit-profil');
  }

  void showAbout() {
    Get.toNamed('/tentang');
  }

  /// =============================
  /// LOGOUT
  /// =============================
  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    /// reset semua state
    userId.value = '';
    namaC.value = '';
    emailC.value = '';
    foto.value = '';
    image.value = null;

    /// hapus session
    await prefs.clear();

    /// hapus semua controller
    Get.deleteAll();

    /// kembali ke login
    Get.offAllNamed('/login');

  }

}