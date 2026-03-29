import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:pyhsiocare/config/api_config.dart';

class BeratBadanController extends GetxController {
  final box = GetStorage();

  var riwayat = <Map<String, dynamic>>[].obs;
  var beratTerakhir = 0.0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatBeratBadan();
  }

  /// ==============================
  /// FETCH RIWAYAT
  /// ==============================
  Future<void> fetchRiwayatBeratBadan() async {
    isLoading.value = true;

    final token = box.read('auth_token');

    if (token == null) {
      print("❌ Token tidak ada");
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/berat_badan"),
        headers: {"Authorization": "Bearer $token"},
      );

      /// 🔐 HANDLE TOKEN EXPIRED
      if (response.statusCode == 401) {
        final body = jsonDecode(response.body);

        if (body["msg"] == "Token has expired") {
          print("🔐 Token expired → logout");

          box.erase();
          Get.offAllNamed('/login');
          return;
        }
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        riwayat.value = List<Map<String, dynamic>>.from(data.map((d) {
          double berat = 0.0;
          final b = d["berat_badan"];

          if (b is String) {
            berat = double.tryParse(b) ?? 0.0;
          } else if (b is num) {
            berat = b.toDouble();
          }

          return {
            "_id": d["_id"],
            "berat_badan": berat,
            "tanggal": d["tanggal"],
          };
        }));

        if (riwayat.isNotEmpty) {
          beratTerakhir.value = riwayat.last["berat_badan"];
        } else {
          beratTerakhir.value = 0.0;
        }
      } else {
        print("❌ Gagal ambil berat badan: ${response.body}");
      }
    } catch (e) {
      print("❌ Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ==============================
  /// TAMBAH DATA
  /// ==============================
  Future<void> tambahBeratBadan(double berat, {String? tanggal}) async {
    final token = box.read('auth_token');

    if (token == null) return;

    try {
      final response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}/berat_badan"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"berat_badan": berat, "tanggal": tanggal}),
      );

      /// 🔐 HANDLE TOKEN EXPIRED
      if (response.statusCode == 401) {
        final body = jsonDecode(response.body);

        if (body["msg"] == "Token has expired") {
          print("🔐 Token expired → logout");

          box.erase();
          Get.offAllNamed('/login');
          return;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchRiwayatBeratBadan();
      } else {
        print("❌ Gagal tambah berat: ${response.body}");
      }
    } catch (e) {
      print("❌ Error tambah berat: $e");
    }
  }

Future<void> updateBeratBadan(String id, double berat, {String? tanggal}) async {
  final token = box.read('auth_token');
  if (token == null) return;

  if (id.isEmpty) return;

  try {
    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}/berat_badan/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "berat_badan": berat,
        "tanggal": tanggal,
      }),
    );

    if (response.statusCode == 200) {
      await fetchRiwayatBeratBadan();
    } else {
      print("❌ gagal update: ${response.body}");
    }
  } catch (e) {
    print("❌ error update: $e");
  }
}

Future<void> deleteBeratBadan(String id) async {
  final token = box.read('auth_token');
  if (token == null) return;

  if (id.isEmpty) {
    print("❌ ID kosong, abort delete");
    return;
  }

  try {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/berat_badan/$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      await fetchRiwayatBeratBadan();
    } else {
      print("❌ gagal delete: ${response.body}");
    }
  } catch (e) {
    print("❌ error delete: $e");
  }
}

String formatBerat(dynamic value) {
  double val = 0;

  if (value is String) {
    val = double.tryParse(value) ?? 0;
  } else if (value is num) {
    val = value.toDouble();
  }

  // kalau bilangan bulat → hilangkan .0
  if (val % 1 == 0) {
    return val.toInt().toString();
  }

  return val.toString();
}
}
