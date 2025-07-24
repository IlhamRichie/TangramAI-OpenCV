import 'dart:async';
import 'dart:typed_data'; // Untuk Uint8List
import 'package:camera/camera.dart';
import 'package:flutter/material.dart'; // Untuk dialog
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;


import '../../../data/models/level_model.dart';
import '../../../data/services/contour_loader.dart';
import '../../../routes/app_pages.dart'; //

class GameController extends GetxController {
  late Level level;
  Timer? _timer;
  final RxInt elapsedTime = 0.obs;
  final RxString formattedTime = '00:00'.obs;
  final RxBool isProcessing = false.obs;

  // --- Variabel Baru untuk Kamera ---
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    level = Get.arguments as Level;
    _initializeCamera(); // Inisialisasi kamera
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    cameraController?.dispose(); // WAJIB: Lepaskan kamera saat halaman ditutup
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first; // Biasanya kamera belakang

      cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high, // Gunakan resolusi tinggi untuk akurasi
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      print("Error initializing camera: $e");
      Get.snackbar('Error Kamera', 'Tidak dapat mengakses kamera.');
    }
  }

  Future<void> scanPuzzle() async {
    if (isProcessing.value || !isCameraInitialized.value) return;

    try {
      isProcessing.value = true;
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      // Ambil gambar dari controller kamera, bukan image_picker lagi
      final XFile imageFile = await cameraController!.takePicture();
      
      final imageBytes = await imageFile.readAsBytes();
      final masterContour = await ContourLoaderService.loadContourFromFile(level.contourPath);

      if (masterContour.isEmpty) throw Exception("Kontur master gagal dimuat.");
      
      final userContour = _processImageToGetContour(imageBytes);

      if (userContour.isEmpty) throw Exception("Bentuk tidak terdeteksi pada gambar.");
      
      final double similarity = cv.matchShapes(masterContour, userContour, cv.CONTOURS_MATCH_I1, 0);
      print("Similarity Score: $similarity (Target: < ${level.matchThreshold})");
      
      Get.back();

      if (similarity < level.matchThreshold) {
        stopTimer();
        Get.toNamed(Routes.RESULT, arguments: {'level': level, 'time': elapsedTime.value});
      } else {
        Get.snackbar('Coba Lagi!', 'Bentuknya belum mirip, perbaiki susunanmu.',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      print("Error during puzzle scan: $e");
      Get.snackbar('Error', 'Terjadi kesalahan saat memproses gambar.');
    } finally {
      isProcessing.value = false;
    }
  }

  cv.VecPoint _processImageToGetContour(Uint8List imageBytes) {
    final img = cv.imdecode(imageBytes, cv.IMREAD_COLOR);
    final grayImg = cv.cvtColor(img, cv.COLOR_BGR2GRAY);
    
    // --- PERBAIKAN BUG TIPE DATA ---
    final (_, thresh) = cv.threshold(grayImg, 127, 255, cv.THRESH_BINARY_INV);
    
    final (contours, _) = cv.findContours(thresh, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);

    if (contours.isEmpty) return cv.VecPoint.fromList([]);
    return contours.reduce((a, b) => cv.contourArea(a) > cv.contourArea(b) ? a : b);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedTime.value++; // Tambah detik
      _updateFormattedTime(); // Perbarui teks waktu
    });
  }

  void _updateFormattedTime() {
    final int minutes = elapsedTime.value ~/ 60; // Dapatkan menit
    final int seconds = elapsedTime.value % 60; // Dapatkan sisa detik
    formattedTime.value =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void stopTimer() {
    _timer?.cancel();
  }
}