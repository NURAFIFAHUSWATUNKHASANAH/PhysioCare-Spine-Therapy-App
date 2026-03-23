import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteService {

  Interpreter? interpreter;

  Future loadModel() async {

    interpreter = await Interpreter.fromAsset(
      "assets/model/model_pyshiocare.tflite",
    );
  }

  Future<int> predict(List<double> input) async {

    var inputTensor = [input];

    var output = List.generate(
      1,
      (_) => List.filled(4, 0.0),
    );

    interpreter!.run(inputTensor, output);

    List result = output[0];

    int index = 0;
    double max = result[0];

    for (int i = 1; i < result.length; i++) {

      if (result[i] > max) {

        max = result[i];
        index = i;

      }
    }

    return index;
  }
}