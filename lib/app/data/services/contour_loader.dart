import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class ContourLoaderService {
  /// Membaca file JSON dari path aset dan mengubahnya menjadi objek kontur OpenCV.
  static Future<cv.VecPoint> loadContourFromFile(String path) async {
    try {
      // 1. Baca file JSON sebagai string
      final String jsonString = await rootBundle.loadString(path);
      
      // 2. Decode string JSON menjadi Map
      final Map<String, dynamic> data = json.decode(jsonString);
      
      // 3. Ambil list of points
      final List<dynamic> pointsData = data['points'];
      
      // 4. Ubah setiap point menjadi Point dari OpenCV dan kumpulkan
      final points = pointsData.map((p) {
        return cv.Point(p['x'], p['y']);
      }).toList();

      // 5. Kembalikan sebagai VecPoint (tipe data kontur di opencv_dart)
      return cv.VecPoint.fromList(points);

    } catch (e) {
      print("Error loading contour from $path: $e");
      // Kembalikan kontur kosong jika terjadi error
      return cv.VecPoint.fromList([]);
    }
  }
}