// app/data/services/level_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/level_model.dart'; // Sesuaikan path jika berbeda

/// Fungsi ini bertugas membaca file 'levels.json' dari assets,
/// mengubahnya menjadi list, dan mengembalikannya sebagai List<Level>.
Future<List<Level>> loadLevels() async {
  // 1. Memuat konten file JSON sebagai string.
  final String response = await rootBundle.loadString('assets/levels.json');
  
  // 2. Mengubah string JSON menjadi struktur data Dart (List of Maps).
  final List<dynamic> data = json.decode(response);
  
  // 3. Memetakan setiap item di list menjadi objek Level menggunakan factory constructor.
  return data.map((json) => Level.fromJson(json)).toList();
}