import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';

class ObjectDetectionModel {
  late FlutterVision vision;
  bool isModelLoaded = false;

  // Initialize the YOLOv8 model
  Future<void> initModel() async {
    vision = FlutterVision();
    await loadYoloModel();
  }

  // Load the YOLOv8 model
  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels36class.txt',
      modelPath: 'assets/best36.tflite',
      modelVersion: "yolov8",
      numThreads: 1,
      useGpu: true,
    );
    isModelLoaded = true;
  }

  // Process a frame from the camera and detect objects
  Future<List<Map<String, dynamic>>> processFrame(CameraImage cameraImage, double confidenceThreshold) async {
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: confidenceThreshold,
      classThreshold: 0.5,
    );

    return result;
  }

  // Dispose resources when done
  void dispose() async {
    await vision.closeYoloModel();
  }
}