import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:typed_data';

class IDScannerScreen extends StatefulWidget {
  @override
  _IDScannerScreenState createState() => _IDScannerScreenState();
}

class _IDScannerScreenState extends State<IDScannerScreen> {
  late CameraController _controller;
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  void _startCamera() {
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    setState(() {});  // Trigger a rebuild so CameraPreview can show
    _controller.startImageStream((image) {
      if (!isProcessing) {
        isProcessing = true;
        _processImage(image);
      }
    });
  }

  Future<void> _processImage(CameraImage image) async {
    final inputImage = convertCameraImageToInputImage(image);
    // Process image (recognition logic goes here if needed)
    //  final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    //  print('Detected text: ${recognizedText.text}');



    // print('Detected text: ${recognizedText.text}');

    isProcessing = false;
  }

  InputImage convertCameraImageToInputImage(CameraImage image) {
    final WriteBuffer buffer = WriteBuffer();
    for (final Plane plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    final Uint8List bytes = buffer.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.yuv420,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('ID Scanner')),
        body: CameraPreview(_controller),
      );
    } else {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}

class IDScannerScreenc extends StatefulWidget {
  @override
  _IDScannerScreenStatec createState() => _IDScannerScreenStatec();
}

class _IDScannerScreenStatec extends State<IDScannerScreen> {
  late CameraController _controller;
  TextRecognizer _textRecognizer  = TextRecognizer(script: TextRecognitionScript.latin);
  bool isProcessing = false;

  @override
  void initState() async{
    super.initState();

    await _initializeCamera();

  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    _controller.startImageStream((image) {
      if (!isProcessing) {
        isProcessing = true;
        _processImage(image);
      }
    });
  }

  Future<void> _processImage(CameraImage image) async {
    final inputImage = convertCameraImageToInputImage(image);

   // final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
 //   print('Detected text: ${recognizedText.text}');



   // print('Detected text: ${recognizedText.text}');

    isProcessing = false;
  }

  InputImage convertCameraImageToInputImage(CameraImage image) {
    final WriteBuffer buffer = WriteBuffer();
    for (final Plane plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }
    final Uint8List bytes = buffer.done().buffer.asUint8List();

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotation.rotation0deg,  // Adjust this if needed
      format: InputImageFormat.yuv420,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }


  @override
  void dispose() {
    _controller.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('ID Scanner')),
      body: CameraPreview(_controller),
    );
  }
}
