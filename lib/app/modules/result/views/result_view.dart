import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background Gradasi
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c3e50), Color(0xff34495e)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Konten Halaman
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // --- HEADER ---
                  Column(
                    children: [
                      Text(
                        'BERHASIL!',
                        style: GoogleFonts.montserrat(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade300,
                          shadows: [
                            const Shadow(blurRadius: 10, color: Colors.black38)
                          ],
                        ),
                      ),
                      Text(
                        'Kamu menyelesaikan Level ${controller.completedLevel.level}',
                        style: GoogleFonts.montserrat(
                            fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ).animate().fade(duration: 500.ms).slideY(begin: -0.5),

                  // --- KARTU STATISTIK ---
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatRow('Waktu Selesai', controller.formattedTime),
                        const Divider(color: Colors.white24, height: 24),
                        _buildStatRow('Bintang Diraih', ''),
                        const SizedBox(height: 8),
                        Obx(() => RatingBar.builder(
                              initialRating: controller.starRating.value.toDouble(),
                              itemCount: 3,
                              itemBuilder: (context, _) =>
                                  const Icon(Icons.star_rounded, color: Colors.amber),
                              onRatingUpdate: (rating) {},
                              ignoreGestures: true,
                            )
                                .animate()
                                .scale(delay: 500.ms, curve: Curves.elasticOut)
                                .shake(delay: 700.ms)),
                      ],
                    ),
                  ).animate().fade(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),

                  // --- TOMBOL NAVIGASI ---
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xff2c3e50),
                          ),
                          onPressed: () => controller.nextLevel(),
                          icon: const Icon(CupertinoIcons.arrow_right),
                          label: Text('PILIH LEVEL LAIN',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                              onPressed: () => controller.retryLevel(),
                              child: const Text('Ulangi'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                              ),
                              onPressed: () => controller.goToHome(),
                              child: const Text('Menu Utama'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ).animate().fade(delay: 600.ms).slideY(begin: 0.5),
                ],
              ),
            ),
          ),
          
          // Efek Konfeti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controller.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk baris statistik
  Widget _buildStatRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(value,
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}