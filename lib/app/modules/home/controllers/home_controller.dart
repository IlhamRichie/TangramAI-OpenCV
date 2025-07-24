import 'package:get/get.dart';
import 'package:tangramai/app/routes/app_pages.dart'; // Sesuaikan path
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {

  // URL toko online Anda
  final Uri productUrl = Uri.parse('https://www.tokopedia.com/toko-anda');

  void goToLevelSelect() {
    Get.toNamed(Routes.LEVEL_SELECT);
  }

  void goToLeaderboard() {
    // Arahkan ke halaman leaderboard jika sudah dibuat
    // Get.toNamed(Routes.LEADERBOARD);
    print("Navigasi ke Leaderboard"); // Placeholder
  }

  void goToSettings() {
    // Arahkan ke halaman pengaturan jika sudah dibuat
    // Get.toNamed(Routes.SETTINGS);
    print("Navigasi ke Pengaturan"); // Placeholder
  }

  Future<void> launchProductUrl() async {
    // Menggunakan package url_launcher untuk membuka link toko
    if (!await launchUrl(productUrl)) {
      Get.snackbar(
        'Gagal Membuka Link',
        'Tidak dapat membuka halaman toko. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}