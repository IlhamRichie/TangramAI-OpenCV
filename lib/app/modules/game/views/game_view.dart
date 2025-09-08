import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/game_controller.dart';

class GameView extends GetView<GameController> {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // ... (AppBar tetap sama)
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2c3e50), Color(0xff34495e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- AREA 1: BENTUK TARGET ---
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(controller.level.imagePath),
                ),
              ),

              // --- AREA 2: PREVIEW KAMERA DENGAN FEEDBACK ---
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  // Gunakan Stack untuk menumpuk border di atas preview kamera
                  child: Obx(() {
                    // Tentukan warna border berdasarkan tingkat kemiripan
                    Color borderColor = Colors.red.withOpacity(0.7);
                    if (controller.currentSimilarity.value < (controller.level.matchThreshold * 2)) {
                      borderColor = Colors.yellow.withOpacity(0.7);
                    }
                    if (controller.currentSimilarity.value < controller.level.matchThreshold) {
                      borderColor = Colors.green.withOpacity(0.7);
                    }

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Preview Kamera
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: controller.isCameraInitialized.value
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CameraPreview(controller.cameraController!),
                                )
                              : const Center(child: CupertinoActivityIndicator(color: Colors.white)),
                        ),
                        // Border Feedback Animasi
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: borderColor, width: 6),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // --- AREA 3: TIMER (TANPA TOMBOL SCAN) ---
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'WAKTU',
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Obx(() => Text(
                          controller.formattedTime.value,
                          style: GoogleFonts.montserrat(
                            fontSize: 52, // Perbesar ukuran timer
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}