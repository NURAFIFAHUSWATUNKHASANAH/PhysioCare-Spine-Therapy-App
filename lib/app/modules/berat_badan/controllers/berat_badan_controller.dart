import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyhsiocare/config/api_config.dart';

class BeratBadanController extends GetxController {
  var riwayat = <Map<String, dynamic>>[].obs;
  var beratTerakhir = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatBeratBadan();
  }

Future<void> fetchRiwayatBeratBadan() async {
  isLoading.value = true;
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/berat_badan"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // convert setiap berat_badan ke double
      riwayat.value = List<Map<String, dynamic>>.from(data.map((d) {
        double berat = 0.0;
        final b = d["berat_badan"];
        if (b is String) {
          berat = double.tryParse(b) ?? 0.0;
        } else if (b is num) {
          berat = b.toDouble();
        }
        return {
          "berat_badan": berat,
          "tanggal": d["tanggal"],
        };
      }));

      if (riwayat.isNotEmpty) {
        beratTerakhir.value = riwayat.last["berat_badan"];
      } else {
        beratTerakhir.value = 0.0;
      }
    }
  } catch (e) {
    print(e);
  } finally {
    isLoading.value = false;
  }
}

  Future<void> tambahBeratBadan(double berat, {String? tanggal}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return;

    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/berat_badan"),
      headers: {"Authorization": "Bearer $token", "Content-Type": "application/json"},
      body: jsonEncode({"berat_badan": berat, "tanggal": tanggal}),
    );

    if (response.statusCode == 200) {
      fetchRiwayatBeratBadan(); // refresh data
    }
  }
}