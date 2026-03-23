import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:pyhsiocare/app/modules/senam/bindings/senam_binding.dart';
import 'package:pyhsiocare/app/modules/senam/views/senam_view.dart';

import '../services/pose_service.dart';
import '../services/tflite_service.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pyhsiocare/config/api_config.dart';
import 'package:pyhsiocare/app/modules/histori/controllers/histori_controller.dart';
import 'package:pyhsiocare/app/modules/home/controllers/home_controller.dart';

class SenamAiController extends GetxController {
  CameraController? cameraController;

  final PoseService poseService = PoseService();
  final TfliteService tfliteService = TfliteService();

  final FlutterTts tts = FlutterTts();

  var currentPose = "".obs;
  var feedback = "".obs;

  var isCameraReady = false.obs;
  String targetPose = "";

  Timer? timer;
  var seconds = 60.obs;

  var correctFrames = 0.obs;
  var totalFrames = 0.obs;
  var accuracy = 0.0.obs;

  bool isProcessing = false;

  /// cooldown TTS supaya tidak spam suara
  DateTime lastSpeak = DateTime.now();

  final labels = ["Bird Dog", "Cat Cow", "Child Pose", "Side Lying Leg Lift"];

  @override
  void onInit() {
    super.onInit();
    initModel();
  }

  /// Load model TFLite
  Future initModel() async {
    await tfliteService.loadModel();
  }

  /// Inisialisasi kamera
  Future initCamera(CameraDescription camera) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await cameraController!.initialize();

    isCameraReady.value = true;

    startPoseDetection();
  }

  /// TIMER LATIHAN
  void startTimer() {
    seconds.value = 60;

    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      seconds.value--;

      if (seconds.value <= 0) {
        t.cancel();
        cameraController?.stopImageStream();

        if (totalFrames.value > 0) {
          accuracy.value = (correctFrames.value / totalFrames.value) * 100;
        } else {
          accuracy.value = 0;
        }

        await simpanHistori(accuracy.value, targetPose);

        speak(
            "Latihan selesai. Akurasi kamu ${accuracy.value.toStringAsFixed(1)} persen");

        showResultDialog(); // default isManualStop = false
      }
    });
  }

  /// Mulai pose detection
  void startPoseDetection() {
    cameraController!.startImageStream((image) async {
      if (isProcessing) return;

      isProcessing = true;

      try {
        final pose = await poseService.detectPose(image);

        if (pose != null) {
          final input = poseService.extractLandmarks(pose);

          final normalized = await poseService.normalize(input);

          final result = await tfliteService.predict(normalized);

          currentPose.value = labels[result];

          giveFeedback();
        }
      } catch (e) {
        print("Pose error: $e");
      }

      isProcessing = false;
    });
  }

  /// Feedback benar / salah
  /// Feedback benar / salah (hanya TTS, tanpa update UI)
  void giveFeedback() {
    totalFrames.value++;

    bool isCorrect = currentPose.value == targetPose;

    if (isCorrect) {
      correctFrames.value++;
    }

    /// Cooldown TTS 3 detik supaya tidak spam
    if (DateTime.now().difference(lastSpeak).inSeconds > 3) {
      if (isCorrect) {
        speak("Gerakan benar");
      } else {
        speak("Gerakan salah");
      }
      lastSpeak = DateTime.now();
    }

    /// Tidak perlu update feedback.value
  }

  /// Text to Speech
  void speak(String text) async {
    await tts.setLanguage("id-ID");
    await tts.setSpeechRate(0.45);
    await tts.setPitch(1.0);

    await tts.speak(text);
  }

  /// SIMPAN HISTORI LATIHAN
  Future<void> simpanHistori(double akurasi, String label) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final token = prefs.getString('auth_token'); // ambil token JWT

    if (userId == null || token == null || token.isEmpty) {
      Get.snackbar("Error", "User ID atau token tidak ditemukan");
      return;
    }

    final body = {
      "user_id": userId,
      "label": label,
      "accuracy": akurasi,
      "tanggal": DateTime.now().toIso8601String(),
    };

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.historiUrl}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ wajib
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        // Refresh histori
        if (Get.isRegistered<HistoriController>()) {
          await Get.find<HistoriController>().fetchHistory();
        } else {
          await Get.put(HistoriController()).fetchHistory();
        }

        // Update statistik Home
        HomeController homeController;
        if (Get.isRegistered<HomeController>()) {
          homeController = Get.find<HomeController>();
        } else {
          homeController = Get.put(HomeController());
        }
        await homeController.getTotalLatihanDanWaktu();

        Get.snackbar("Sukses", "Histori latihan tersimpan");
      } else if (response.statusCode == 401) {
        Get.snackbar(
            "Gagal", "Token kadaluarsa atau tidak valid, silakan login ulang");
      } else {
        Get.snackbar("Gagal", "Gagal menyimpan histori: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  /// Dialog hasil latihan
  void showResultDialog({bool isManualStop = false}) {
    Get.dialog(
      AlertDialog(
        title: Text(isManualStop ? "Latihan Dihentikan" : "Latihan Selesai"),
        content: Obx(() => Text(
              "Akurasi Gerakan: ${accuracy.value.toStringAsFixed(1)} %",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // tutup dialog
              Get.back(); // kembali dari SenamAiView ke SenamView
            },
            child: const Text("Tutup"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    cameraController?.dispose();
    timer?.cancel();

    super.onClose();
  }

  /// Hentikan latihan sebelum waktunya habis
  void stopExercise() async {
    timer?.cancel();
    await cameraController?.stopImageStream();

    if (totalFrames.value > 0) {
      accuracy.value = (correctFrames.value / totalFrames.value) * 100;
    } else {
      accuracy.value = 0;
    }

    await simpanHistori(accuracy.value, targetPose);

    speak(
        "Latihan dihentikan. Akurasi kamu ${accuracy.value.toStringAsFixed(1)} persen");

    /// Panggil dialog dengan parameter manual
    showResultDialog(isManualStop: true);
  }
}
