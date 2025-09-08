class ScoreEntry {
  final String player;
  final int timeInSeconds;
  late final String formattedTime;

  ScoreEntry({required this.player, required this.timeInSeconds}) {
    final int minutes = timeInSeconds ~/ 60;
    final int seconds = timeInSeconds % 60;
    formattedTime =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  factory ScoreEntry.fromJson(Map<String, dynamic> json) {
    return ScoreEntry(
      player: json['player'] ?? 'Player',
      timeInSeconds: json['time'] ?? 0,
    );
  }
}