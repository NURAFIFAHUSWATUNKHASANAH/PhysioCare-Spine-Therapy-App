import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseService {

  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(
      mode: PoseDetectionMode.stream,
    ),
  );

  Map<String, dynamic>? scaler;

  Future loadScaler() async {

    final jsonString =
        await rootBundle.loadString("assets/model/scaler_params.json");

    scaler = json.decode(jsonString);
  }

  Future<Pose?> detectPose(CameraImage image) async {

    final WriteBuffer allBytes = WriteBuffer();

    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );

    final poses = await poseDetector.processImage(inputImage);

    if (poses.isEmpty) return null;

    return poses.first;
  }

  List<double> extractLandmarks(Pose pose) {

    List<double> landmarks = [];

    for (var l in PoseLandmarkType.values) {

      final landmark = pose.landmarks[l];

      if (landmark != null) {

        landmarks.add(landmark.x);
        landmarks.add(landmark.y);
        landmarks.add(landmark.z);

      } else {

        landmarks.add(0);
        landmarks.add(0);
        landmarks.add(0);

      }

    }

    return landmarks;
  }

  Future<List<double>> normalize(List<double> input) async {

  if (scaler == null) {
    await loadScaler();
  }

  List mean = scaler!["mean"];
  List std = scaler!["std"];

  List<double> normalized = [];

  for (int i = 0; i < input.length; i++) {

    normalized.add((input[i] - mean[i]) / std[i]);

  }

  return normalized;
}
}