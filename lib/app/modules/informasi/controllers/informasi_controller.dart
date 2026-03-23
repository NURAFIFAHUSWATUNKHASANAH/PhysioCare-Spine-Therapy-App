import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformasiController extends GetxController {

  var informasiList = [].obs;
  var selectedData = Rxn<dynamic>();

  @override
  void onInit() {
    fetchInformasi();
    super.onInit();
  }

  Future fetchInformasi() async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/informasi"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      }
    );

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);

      informasiList.value = data["data"];

    } else {

      print("Gagal ambil informasi: ${response.body}");

    }

  }

    // 🔥 pilih data
  void selectData(dynamic data) {
    selectedData.value = data;
  }

  // 🔥 kembali ke list
  void clearSelected() {
    selectedData.value = null;
  }
}