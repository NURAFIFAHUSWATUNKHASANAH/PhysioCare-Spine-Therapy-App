import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodController extends GetxController {
  var mual = 0.0.obs;
  var energi = 5.0.obs;
  var nyeri = 0.0.obs;
  var tidur = 5.0.obs;
  var nafsuMakan = 5.0.obs;

  var recommendation = "".obs;
  var isLoading = false.obs;

Future<void> getRecommendation() async {
  isLoading.value = true;

  try {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id'); // 🔥 ambil user_id

    final url = ApiConfig.moodRecommendationUrl;

    final bodyData = {
      "user_id": userId, // 🔥 kirim ke backend
      "energy": energi.value,
      "nausea": mual.value,
      "pain": nyeri.value,
      "sleep": tidur.value,
      "appetite": nafsuMakan.value
    };

    print("Request Body: ${jsonEncode(bodyData)}");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        recommendation.value = data["recommendation"] ?? "Tidak ada rekomendasi";
      } else {
        recommendation.value = "⚠ ${data["message"]}";
      }
    } else {
      recommendation.value = "⚠ Server error: ${response.statusCode}";
    }

  } catch (e) {
    recommendation.value = "⚠ Error: $e";
  }

  isLoading.value = false;
}
}
