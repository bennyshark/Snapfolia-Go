import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(
    home: YoloCamera(cameras: cameras),
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
  ));
}

class YoloCamera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const YoloCamera({Key? key, required this.cameras}) : super(key: key);

  @override
  State<YoloCamera> createState() => _YoloCameraState();
}

class _YoloCameraState extends State<YoloCamera> {
  late CameraController cameraController;
  late ObjectDetectionModel detectionModel;

  CameraImage? cameraImage;
  List<Map<String, dynamic>> detectionResults = [];
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    // Initialize camera
    cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );
    await cameraController.initialize();

    // Initialize model
    detectionModel = ObjectDetectionModel();
    await detectionModel.initModel();

    setState(() {
      isLoaded = true;
    });
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });

    if (cameraController.value.isStreamingImages) return;

    await cameraController.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        processDetection();
      }
    });
  }

  Future<void> processDetection() async {
    if (cameraImage == null || !isDetecting) return;

    final results = await detectionModel.processFrame(cameraImage!, confidenceThreshold);

    if (results.isNotEmpty && mounted) {
      setState(() {
        detectionResults = results;
      });
    }
  }

  void stopDetection() async {
    if (!mounted) return;

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

    // Calculate scaling factors to map the model coordinates to screen coordinates
    double factorX = screenSize.width / cameraImage!.height;
    double factorY = screenSize.height / cameraImage!.width;

    return detectionResults.map((result) {
      // Extract object coordinates and dimensions
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;
      double confidence = result["box"][4];

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
            style: TextStyle(
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
        title: const Text("YOLOv8 Object Detection"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Show confidence threshold slider
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Detection Settings"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Confidence Threshold: ${confidenceThreshold.toStringAsFixed(2)}"),
                      Slider(
                        value: confidenceThreshold,
                        min: 0.1,
                        max: 0.9,
                        divisions: 8,
                        onChanged: (value) {
                          setState(() {
                            confidenceThreshold = value;
                          });
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          CameraPreview(cameraController),

          // Bounding boxes for detected objects
          ...displayBoundingBoxes(screenSize),

          // Camera control button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
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

          // Detection status
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
    cameraController.dispose();
    detectionModel.dispose();
    super.dispose();
  }
}