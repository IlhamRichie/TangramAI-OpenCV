import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tangramai/app/routes/app_pages.dart';
import '../../../data/models/level_model.dart';
import '../../../data/services/level_service.dart'; // Ganti dengan path routes Anda

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _startLoading(); // Mulai proses saat widget sudah siap
  }

  Future<void> _startLoading() async {
    await Future.delayed(const Duration(seconds: 3));

    try {
      final List<Level> allLevels = await loadLevels();
      print("🎉 ${allLevels.length} level berhasil dimuat, navigasi ke Halaman Utama...");
      
      Get.offAllNamed(Routes.HOME);

    } catch (e) {
      print("❌ Error saat memuat data: $e");
      
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Oh, Tidak!',
          message:
              'Gagal memuat data puzzle. Pastikan file aset Anda sudah benar.',
          contentType: ContentType.failure,
        ),
      );

      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      }
    }
  }
}