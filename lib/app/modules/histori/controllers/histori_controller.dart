import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/config/api_config.dart';

class HistoriController extends GetxController {

  /// ==============================
  /// STATE
  /// ==============================

  var historiList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  var role = "".obs;
  var userId = "".obs;

  var totalLatihan = 0.obs;
  var avgAccuracy = 0.0.obs;

  /// ==============================
  /// INIT
  /// ==============================

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// ==============================
  /// LOAD USER DATA
  /// ==============================
Future<void> loadUserData() async {

  final prefs = await SharedPreferences.getInstance();

  role.value = prefs.getString("user_role") ?? "";
  userId.value = prefs.getString("user_id") ?? "";

  final token = prefs.getString("auth_token");

  if (userId.value.isEmpty || token == null) {
    print("❌ Token atau UserID kosong");
    return;
  }

  await fetchHistory();
  await fetchStats();
}
  /// ==============================
  /// FETCH HISTORY
  /// ==============================

  Future<void> fetchHistory() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    final userId = prefs.getString("user_id");

    if (token == null || userId == null) {
      print("❌ Token atau UserID tidak ditemukan");
      return;
    }

    isLoading.value = true;

    final url = Uri.parse(
      ApiConfig.historiUrlByUser(userId),
    );

    print("REQUEST HISTORI: $url");
    print("TOKEN HISTORI: $token");

    try {

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        if (data["status"] == "success") {

          historiList.value =
              List<Map<String, dynamic>>.from(data["data"]);

          print("✅ Histori berhasil diambil: ${historiList.length}");
        }

      } else {

        print("❌ Fetch histori gagal: ${response.statusCode}");
        print(response.body);

      }

    } catch (e) {

      print("❌ Error fetch histori: $e");

    } finally {

      isLoading.value = false;

    }
  }

  /// ==============================
  /// FETCH STATS
  /// ==============================

  Future<void> fetchStats() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");
    final userId = prefs.getString("user_id");

    if (token == null || userId == null) {
      print("❌ Token atau UserID tidak ditemukan");
      return;
    }

    final url = Uri.parse(
      "${ApiConfig.historiUrl}/stats/$userId",
    );

    print("REQUEST STATS: $url");

    try {

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        if (data["status"] == "success") {

          totalLatihan.value = data["total"] ?? 0;

          avgAccuracy.value =
              (data["avg_accuracy"] ?? 0).toDouble();

          print("✅ Stats diambil");
        }

      } else {

        print("❌ Fetch stats gagal: ${response.statusCode}");
        print(response.body);

      }

    } catch (e) {

      print("❌ Error fetch stats: $e");

    }
  }

  /// ==============================
  /// REFRESH HISTORI
  /// ==============================

  Future<void> refreshHistory() async {

    print("🔄 Refresh histori");

    await fetchHistory();
    await fetchStats();

  }

}