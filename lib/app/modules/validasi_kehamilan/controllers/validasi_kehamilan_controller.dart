import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:pyhsiocare/app/routes/app_pages.dart';

class ValidasiKehamilanController extends GetxController {

  var hpht = "";
  var tinggi = "";
  var berat = "";
  var penyakit = "";

  void setHpht(String v) => hpht = v;
  void setTinggi(String v) => tinggi = v;
  void setBerat(String v) => berat = v;
  void setPenyakit(String v) => penyakit = v;

  Future<void> submitData() async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    final response = await http.post(

      Uri.parse("${ApiConfig.baseUrl}/pregnancy/validate"),

      headers: {

        "Content-Type": "application/json",
        "Authorization": "Bearer $token"

      },

      body: jsonEncode({

        "hpht": hpht,
        "tinggi_badan": tinggi,
        "berat_badan": berat,
        "riwayat_penyakit": penyakit

      }),

    );

    if (response.statusCode == 200) {

      await prefs.setBool("is_validated", true);

      Get.offAllNamed(Routes.BOTTOM);

    } else {

      Get.snackbar("Error", "Gagal menyimpan data");

    }

  }

}