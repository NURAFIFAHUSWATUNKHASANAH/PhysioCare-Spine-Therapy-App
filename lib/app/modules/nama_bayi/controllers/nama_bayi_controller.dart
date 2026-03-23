import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/config/api_config.dart';

class NamaBayiController extends GetxController {

  /// ================================
  /// STATE
  /// ================================

  var keyword = "".obs;
  var category = "Islami".obs;
  var gender = "Laki-laki".obs;

  var result = "".obs;
  var isLoading = false.obs;

  var favorites = <Map<String, dynamic>>[].obs;

  /// ================================
  /// INIT
  /// ================================

  @override
  void onInit() {
    super.onInit();
    getFavorites();
  }

  /// ================================
  /// GENERATE NAMA BAYI (AI)
  /// ================================

  Future<void> generateNama() async {

    isLoading.value = true;

    try {

      final response = await http.post(
        Uri.parse(ApiConfig.generateBabyNameUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "keyword": keyword.value.trim(),
          "category": category.value,
          "gender": gender.value
        }),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        result.value = data["names"];
      } else {
        result.value = "Tidak ada rekomendasi nama.";
      }

    } catch (e) {

      result.value = "Gagal mengambil rekomendasi";

    }

    isLoading.value = false;

  }

  /// ================================
  /// PARSE HASIL AI KE LIST
  /// ================================

  List<Map<String, String>> get parsedNames {

    List<Map<String, String>> list = [];

    final lines = result.value.split("\n");

    for (var line in lines) {

      if (line.contains("-")) {

        final parts = line.replaceAll("•", "").split("-");

        if (parts.length == 2) {

          list.add({
            "name": parts[0].trim(),
            "meaning": parts[1].trim(),
          });

        }

      }

    }

    return list;

  }

  /// ================================
  /// SAVE FAVORITE
  /// ================================

  Future<void> saveFavorite(String name, String meaning) async {

    try {

      await http.post(
        Uri.parse(ApiConfig.babyNameFavoriteUrl),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "name": name.trim(),
          "meaning": meaning.trim(),
          "category": category.value,
          "gender": gender.value
        }),
      );

      await getFavorites();

      Get.snackbar(
        "Berhasil",
        "Nama bayi disimpan ke favorit",
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {

      Get.snackbar(
        "Error",
        "Gagal menyimpan favorit",
        snackPosition: SnackPosition.BOTTOM,
      );

    }

  }

  /// ================================
  /// GET FAVORITE
  /// ================================

  Future<void> getFavorites() async {

    try {

      final response = await http.get(
        Uri.parse(ApiConfig.babyNameFavoriteUrl),
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {

        favorites.value =
            List<Map<String, dynamic>>.from(data["data"]);

      }

    } catch (e) {

      Get.snackbar(
        "Error",
        "Gagal mengambil daftar favorit",
        snackPosition: SnackPosition.BOTTOM,
      );

    }

  }

  /// ================================
  /// DELETE FAVORITE
  /// ================================

  Future<void> removeFavorite(String name) async {

    try {

      final encodedName = Uri.encodeComponent(name);

      await http.delete(
        Uri.parse("${ApiConfig.babyNameFavoriteUrl}/$encodedName"),
      );

      favorites.removeWhere((e) => e["name"] == name);

      Get.snackbar(
        "Berhasil",
        "Nama dihapus dari favorit",
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {

      Get.snackbar(
        "Error",
        "Gagal menghapus favorit",
        snackPosition: SnackPosition.BOTTOM,
      );

    }

  }

}