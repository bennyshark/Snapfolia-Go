import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import '../models/obj_detection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(
    home: ScanPage(cameras: cameras),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
  ));
}

class ScanPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ScanPage({Key? key, required this.cameras}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late CameraController cameraController;
  late ObjectDetectionModel detectionModel;

  CameraImage? cameraImage;
  List<Map<String, dynamic>> detectionResults = [];
  bool isLoaded = false;
  bool isDetecting = false;
  final double confidenceThreshold = 0.5;

  // Timer for clearing stale detections
  Timer? _detectionTimer;
  DateTime _lastDetectionTime = DateTime.now();

  bool _isProcessing = false; // throttle overlapping frames

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await cameraController.initialize();

    detectionModel = ObjectDetectionModel();
    await detectionModel.initModel();

    setState(() {
      isLoaded = true;
    });
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
      _detectionTimer?.cancel();
      _lastDetectionTime = DateTime.now();
    });

    _detectionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (now.difference(_lastDetectionTime).inSeconds >= 3 && detectionResults.isNotEmpty) {
        setState(() {
          detectionResults.clear();
        });
      }
    });

    if (cameraController.value.isStreamingImages) return;

    await cameraController.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        await processDetection();
      }
    });
  }

  Future<void> processDetection() async {
    if (cameraImage == null || !isDetecting || _isProcessing) return;
    _isProcessing = true;

    final results = await detectionModel.processFrame(cameraImage!, confidenceThreshold);

    if (!mounted || !isDetecting) {
      _isProcessing = false;
      return;
    }

    if (results.isNotEmpty) {
      setState(() {
        detectionResults = results;
        _lastDetectionTime = DateTime.now();
      });
    }

    _isProcessing = false;
  }

  void stopDetection() async {
    if (!mounted) return;

    _detectionTimer?.cancel();
    _detectionTimer = null;

    setState(() {
      isDetecting = false;
      detectionResults.clear();
    });

    if (cameraController.value.isStreamingImages) {
      await cameraController.stopImageStream();
    }
  }

  List<Widget> displayBoundingBoxes(Size screenSize) {
    if (detectionResults.isEmpty || cameraImage == null) return [];

    double factorX = screenSize.width / cameraImage!.height;
    double factorY = screenSize.height / cameraImage!.width;

    return detectionResults.map((result) {
      double objectX = result['box'][0] * factorX;
      double objectY = result['box'][1] * factorY;
      double objectWidth = (result['box'][2] - result['box'][0]) * factorX;
      double objectHeight = (result['box'][3] - result['box'][1]) * factorY;
      double confidence = result['box'][4];

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(confidence * 100).toStringAsFixed(1)}%",
            style: const TextStyle(
              backgroundColor: Colors.green,
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    if (!isLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Loading camera and YOLOv8 model...",
                  style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26.withOpacity(.5),
        title: Text("Snapfolia Go"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(cameraController),
          ...displayBoundingBoxes(screenSize),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
                ),
                child: isDetecting
                    ? IconButton(
                  onPressed: stopDetection,
                  icon: const Icon(Icons.stop, color: Colors.red),
                  iconSize: 50,
                )
                    : IconButton(
                  onPressed: startDetection,
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  iconSize: 50,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isDetecting ? "Detection Active" : "Detection Paused",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    cameraController.dispose();
    detectionModel.dispose();
    super.dispose();
  }
}
