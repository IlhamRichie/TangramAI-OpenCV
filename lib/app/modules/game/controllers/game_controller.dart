import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

import '../../../data/models/level_model.dart';
import '../../../data/services/contour_loader.dart';
import '../../../routes/app_pages.dart';

class GameController extends GetxController {
  // --- State Utama Game ---
  late Level level;
  Timer? _timer;
  final RxInt elapsedTime = 0.obs;
  final RxString formattedTime = '00:00'.obs;
  
  // --- State Kamera & Pemrosesan Real-time ---
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  bool _isProcessingFrame = false;
  int _consecutiveMatches = 0;
  final int _requiredMatches = 5;

  // --- State untuk Umpan Balik Visual ---
  final RxDouble currentSimilarity = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    level = Get.arguments as Level;
    _initializeCamera();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    cameraController?.stopImageStream();
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
          (cam) => cam.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first);

      cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;

      cameraController!.startImageStream((image) {
        if (!_isProcessingFrame) {
          _isProcessingFrame = true;
          _processCameraImage(image);
        }
      });
    } catch (e) {
      print("Error initializing camera: $e");
      Get.snackbar('Error Kamera', 'Tidak dapat mengakses kamera.');
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final masterContour = await ContourLoaderService.loadContourFromFile(level.contourPath);
      if (masterContour.isEmpty) throw Exception("Kontur master gagal dimuat.");
      
      // --- PERBAIKAN UTAMA: Konversi YUV ke Grayscale secara manual ---
      final cv.Mat grayImg = _convertYUVtoGrayscale(image);
      
      // Rotasi 90 derajat karena stream kamera Android biasanya lanskap
      final rotatedImg = cv.rotate(grayImg, cv.ROTATE_90_CLOCKWISE);
      
      final (_, thresh) = cv.threshold(rotatedImg, 127, 255, cv.THRESH_BINARY_INV);
      final (contours, _) = cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);

      if (contours.isNotEmpty) {
        final userContour = contours.reduce((a, b) => cv.contourArea(a) > cv.contourArea(b) ? a : b);
        final double similarity = cv.matchShapes(masterContour, userContour, cv.CONTOURS_MATCH_I1, 0);
        currentSimilarity.value = similarity;

        if (similarity < level.matchThreshold) {
          _consecutiveMatches++;
          if (_consecutiveMatches >= _requiredMatches) {
            stopTimer();
            await cameraController?.stopImageStream();
            Get.offNamed(Routes.RESULT, arguments: {'level': level, 'time': elapsedTime.value});
          }
        } else {
          _consecutiveMatches = 0;
        }
      } else {
        currentSimilarity.value = 1.0;
        _consecutiveMatches = 0;
      }
    } catch (e) {
      print("Error processing frame: $e");
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      _isProcessingFrame = false;
    }
  }

  /// Fungsi helper untuk mengonversi format YUV420 dari CameraImage ke Grayscale Mat
  cv.Mat _convertYUVtoGrayscale(CameraImage image) {
    // Plane 0 adalah Y (Luminance), yang pada dasarnya adalah representasi grayscale dari gambar.
    // Kita bisa langsung menggunakan plane ini untuk efisiensi.
    final yPlane = image.planes[0];
    final img = cv.Mat.fromList(
      image.height,
      yPlane.bytesPerRow, // Gunakan bytesPerRow untuk lebar yang benar
      cv.MatType.CV_8UC1, // 8-bit unsigned, 1 channel (grayscale)
      yPlane.bytes,
    );
    // Jika lebarnya tidak sama (karena padding), kita perlu crop.
    if (yPlane.bytesPerRow != image.width){
      return img.colRange(0, image.width);
    }
    return img;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedTime.value++;
      _updateFormattedTime();
    });
  }

  void _updateFormattedTime() {
    final int minutes = elapsedTime.value ~/ 60;
    final int seconds = elapsedTime.value % 60;
    formattedTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void stopTimer() {
    _timer?.cancel();
  }
}