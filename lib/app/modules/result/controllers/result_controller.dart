import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage
import '../../../data/models/level_model.dart';
import '../../../routes/app_pages.dart';

class ResultController extends GetxController {
  // Instance of GetStorage for persistent storage
  final GetStorage box = GetStorage();

  // Data yang diterima dari GamePage
  late Level completedLevel;
  late int timeTaken; // dalam detik
  late String formattedTime;

  // State reaktif untuk rating bintang
  final RxInt starRating = 0.obs;

  // Controller untuk animasi konfeti
  late ConfettiController confettiController;

  @override
  void onInit() {
    super.onInit();
    // 1. Ambil data argumen dari GamePage
    final arguments = Get.arguments as Map<String, dynamic>;
    completedLevel = arguments['level'] as Level;
    timeTaken = arguments['time'] as int;
    _saveScore();

    // 2. Inisialisasi controller konfeti
    confettiController = ConfettiController(duration: const Duration(seconds: 2));

    // 3. Kalkulasi dan format data
    _calculateStars();
    _formatTime();
    
    // 4. Mainkan animasi konfeti
    confettiController.play();
  }

  @override
  void onClose() {
    // 5. Wajib hentikan controller konfeti saat halaman ditutup
    confettiController.dispose();
    super.onClose();
  }

  void _calculateStars() {
    // Logika penentuan bintang berdasarkan waktu (bisa disesuaikan)
    if (timeTaken <= 30) {
      starRating.value = 3;
    } else if (timeTaken <= 90) {
      starRating.value = 2;
    } else {
      starRating.value = 1;
    }
  }

  void _formatTime() {
    final int minutes = timeTaken ~/ 60;
    final int seconds = timeTaken % 60;
    formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void retryLevel() {
    // Ganti halaman Result dengan GamePage untuk level yang sama
    Get.offNamed(Routes.GAME, arguments: completedLevel);
  }

  void nextLevel() {
    // Kembali ke halaman pemilihan level.
    // Nantinya bisa dikembangkan untuk langsung ke level selanjutnya.
    Get.offAllNamed(Routes.LEVEL_SELECT);
  }

  void goToHome() {
    // Kembali ke menu utama, hapus semua halaman sebelumnya dari tumpukan
    Get.offAllNamed(Routes.HOME);
  }

  void _saveScore() {
    // Buat kunci unik untuk setiap level, misal: 'scores_level_1'
    final String key = 'scores_level_${completedLevel.level}';
    
    // Ambil daftar skor yang sudah ada untuk level ini
    final List<dynamic> existingScores = box.read<List<dynamic>>(key) ?? [];
    
    // Tambahkan skor baru
    existingScores.add({
      'player': 'Player 1', // Bisa dikembangkan nanti
      'time': timeTaken,
    });
    
    // Urutkan berdasarkan waktu tercepat (ascending)
    existingScores.sort((a, b) => (a['time'] as int).compareTo(b['time'] as int));
    
    // Simpan kembali daftar skor yang sudah diurutkan
    box.write(key, existingScores);
    print("Skor untuk level ${completedLevel.level} berhasil disimpan!");
  }
}