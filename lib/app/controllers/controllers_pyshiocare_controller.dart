import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class PyshiocareController extends GetxController {
  late Interpreter _interpreter;

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/model_pyshiocare.tflite');
      print('Model loaded successfully');
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  // Contoh fungsi prediksi
  List predict(List input) {
    var output = List.filled(1 * 1, 0).reshape([1, 1]);
    _interpreter.run(input, output);
    return output;
  }

  @override
  void onClose() {
    _interpreter.close();
    super.onClose();
  }
}
