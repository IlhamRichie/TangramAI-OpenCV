import 'package:get/get.dart';
import 'package:tangramai/app/routes/app_pages.dart';
import '../../../data/models/level_model.dart';
import '../../../data/services/level_service.dart';

class LevelSelectController extends GetxController {
  // Gunakan .obs agar UI bisa bereaksi secara otomatis terhadap perubahan data
  final RxBool isLoading = true.obs;
  final RxList<Level> levelList = <Level>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchLevels(); // Panggil fungsi untuk memuat level saat controller siap
  }

  Future<void> _fetchLevels() async {
    try {
      isLoading.value = true;
      // Panggil fungsi global yang sudah kita buat sebelumnya
      final levels = await loadLevels();
      levelList.value = levels;
    } catch (e) {
      print("Error fetching levels: $e");
      Get.snackbar('Error', 'Gagal memuat daftar level.');
    } finally {
      isLoading.value = false; // Sembunyikan loading indicator
    }
  }

  void selectLevel(Level level) {
    print("Level ${level.level}: ${level.name} dipilih.");
    // Navigasi ke GamePage dan kirim seluruh objek 'level' sebagai argumen
    Get.toNamed(Routes.GAME, arguments: level);
  }
}