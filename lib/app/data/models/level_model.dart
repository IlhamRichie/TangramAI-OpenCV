// app/data/models/level_model.dart

class Level {
  final int level;
  final String name;
  final String difficulty;
  final String imagePath;
  final String contourPath;
  final double matchThreshold;

  Level({
    required this.level,
    required this.name,
    required this.difficulty,
    required this.imagePath,
    required this.contourPath,
    required this.matchThreshold,
  });

  /// Factory constructor untuk membuat instance Level dari data JSON.
  /// JSON (Map<String, dynamic>) diubah menjadi objek Level.
  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      level: json['level'] as int,
      name: json['name'] as String,
      difficulty: json['difficulty'] as String,
      imagePath: json['imagePath'] as String,
      contourPath: json['contourPath'] as String,
      // Konversi 'num' dari JSON ke 'double' untuk keamanan tipe data.
      matchThreshold: (json['matchThreshold'] as num).toDouble(),
    );
  }
}