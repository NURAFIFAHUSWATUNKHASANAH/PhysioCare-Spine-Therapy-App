import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pyhsiocare/config/api_config.dart';

class MeditationController extends GetxController {

  var breathingSessions = <Map<String, dynamic>>[].obs;

  var selectedSession = Rxn<Map<String, dynamic>>();

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSessions();
  }

  Future<void> fetchSessions() async {

    try {

      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}/meditation_sessions"),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        breathingSessions.value =
            List<Map<String, dynamic>>.from(data);

      }

    } catch (e) {

      print(e);

    } finally {

      isLoading.value = false;

    }

  }

  void selectSession(int index) {

    selectedSession.value = breathingSessions[index];

  }

  void clearSelection() {

    selectedSession.value = null;

  }

}