import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

class IDScanner extends StatefulWidget {
  @override
  _IDScannerState createState() => _IDScannerState();
}

class _IDScannerState extends State<IDScanner> {
  CameraController? _cameraController;
  late List<CameraDescription> cameras;
  final TextRecognizer _textRecognizer = TextRecognizer();
  bool _isProcessing = false;
  bool _isScanning = true;
  String? _scannedID;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium, enableAudio: false);
    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});

    // Start the camera stream for real-time scanning
    _cameraController!.startImageStream((CameraImage cameraImage) {
      if (!_isProcessing && _isScanning) {
        _processImage(cameraImage);
      }
    });
  }


  // Process each camera frame and perform OCR
  Future<void> _processImage(CameraImage cameraImage) async {
    _isProcessing = true;

    final bytes = _convertCameraImageToUint8List(cameraImage);
    final image = img.decodeImage(Uint8List.fromList(bytes));

    if (image == null) {
      print("Image is null");
      return;
    }

    // Crop to the scan area (for ID card)
    final croppedImage = _cropToScanArea(image);

    // Convert cropped image to InputImage for ML Kit
    final inputImage = _convertToInputImage(croppedImage);

    // Perform text recognition
    final recognizedText = await _textRecognizer.processImage(inputImage);

    print("Recognized Text: ${recognizedText.text}");

    // Use Regex to match ID pattern
    RegExp idRegex = RegExp(r'(\d{1})\s*(\d{7})\s*(\d{1})');
    final match = idRegex.firstMatch(recognizedText.text);

    if (match != null) {
      setState(() {
        _scannedID = match.group(0);
        _isScanning = false; // Stop scanning after successful recognition
      });

      _cameraController!.stopImageStream();
    }

    _isProcessing = false;
  }

  // Convert YUV camera image to RGB Uint8List
  Uint8List _convertCameraImageToUint8List(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;
    final List<int> bytes = cameraImage.planes[0].bytes; // Typically Y-plane for grayscale
    final int rowStride = cameraImage.planes[0].bytesPerRow;
    final int pixelStride = cameraImage.planes[0].bytesPerPixel ?? 1;

    print("Width: $width, Height: $height, Bytes Length: ${bytes.length}");

    final img.Image image = img.Image(width: width, height: height, numChannels: 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int byteIndex = y * rowStride + x * pixelStride;
        if (byteIndex < bytes.length) {
          final int pixelValue = bytes[byteIndex];
          image.setPixel(x, y, img.ColorInt8.rgb(pixelValue, pixelValue, pixelValue));
        }
      }
    }

    return Uint8List.fromList(img.encodeJpg(image));
  }

  // Crop the image to the scanning area
  img.Image _cropToScanArea(img.Image image) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scanAreaSize = screenWidth * 0.8;
    final offsetX = (screenWidth - scanAreaSize) / 2;
    final offsetY = (screenHeight - scanAreaSize) / 3;

    final cropX = (offsetX / screenWidth * image.width).toInt();
    final cropY = (offsetY / screenHeight * image.height).toInt();
    final cropSize = (scanAreaSize / screenWidth * image.width).toInt();

    return img.copyCrop(image, x: cropX, y: cropY, width: cropSize, height: cropSize);
  }

  // Convert img.Image to InputImage
  InputImage _convertToInputImage(img.Image image) {
    final bytes = Uint8List.fromList(img.encodeJpg(image));
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,  // Adjust format as per your image
        bytesPerRow: image.width * 3,
      ),
    );
  }
  InputImage convertCameraImageToInputImage(CameraImage image) {
    // Step 1: Create a WriteBuffer to concatenate all planes.
    final WriteBuffer buffer = WriteBuffer();

    // Concatenate all planes
    for (final Plane plane in image.planes) {
      buffer.putUint8List(plane.bytes);
    }

    final Uint8List bytes = buffer.done().buffer.asUint8List();

    // Step 2: Get the metadata for the InputImage
    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),  // Image dimensions
      rotation: InputImageRotation.rotation0deg,  // Adjust if needed based on device orientation
      format: InputImageFormat.yuv420,  // YUV format is used by camera
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    // Step 3: Create InputImage using bytes and metadata
    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan ID Number")),
      body: Stack(
        children: [
          if (_cameraController != null && _cameraController!.value.isInitialized)
            CameraPreview(_cameraController!),
          Center(child: CustomPaint(size: Size(double.infinity, double.infinity), painter: BorderPainter())),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (_scannedID != null)
                  Text("Scanned ID: $_scannedID", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double borderSize = size.width * 0.8;
    final double borderWidth = 5.0;
    final Paint borderPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    final double left = (size.width - borderSize) / 2;
    final double top = (size.height - borderSize) / 3;

    final Rect rect = Rect.fromLTWH(left, top, borderSize, borderSize);
    canvas.drawRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
