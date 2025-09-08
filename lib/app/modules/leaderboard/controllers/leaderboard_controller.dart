import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/level_model.dart';
import '../../../data/models/score_model.dart';
import '../../../data/services/level_service.dart';

class LeaderboardController extends GetxController {
  final box = GetStorage();
  
  // State untuk daftar semua level (untuk dropdown)
  final RxList<Level> allLevels = <Level>[].obs;
  
  // State untuk level yang sedang dipilih
  final Rx<Level?> selectedLevel = Rx<Level?>(null);
  
  // State untuk daftar skor yang akan ditampilkan
  final RxList<ScoreEntry> scoresForSelectedLevel = <ScoreEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAllLevels();
  }

  Future<void> _loadAllLevels() async {
    allLevels.value = await loadLevels();
    // Jika ada level, otomatis pilih level pertama
    if (allLevels.isNotEmpty) {
      changeSelectedLevel(allLevels.first);
    }
  }

  void changeSelectedLevel(Level? newLevel) {
    if (newLevel == null) return;
    selectedLevel.value = newLevel;
    _loadScoresForLevel(newLevel.level);
  }

  void _loadScoresForLevel(int levelId) {
    final String key = 'scores_level_$levelId';
    final List<dynamic> rawScores = box.read<List<dynamic>>(key) ?? [];
    
    final List<ScoreEntry> loadedScores =
        rawScores.map((score) => ScoreEntry.fromJson(score as Map<String, dynamic>)).toList();
        
    scoresForSelectedLevel.value = loadedScores;
  }
}