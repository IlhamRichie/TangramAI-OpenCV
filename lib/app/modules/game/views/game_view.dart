// File: app/modules/game/views/game_view.dart

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Level ${controller.level.level}: ${controller.level.name}',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2c3e50), Color(0xff34495e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // Menggunakan SingleChildScrollView untuk menghindari overflow
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // Agar tidak bisa di-scroll manual
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- AREA 1: BENTUK TARGET ---
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3, // 30% tinggi layar
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Image.asset(controller.level.imagePath),
                    ),
                  ),

                  // --- AREA 2: PREVIEW KAMERA ---
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45, // 45% tinggi layar
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Obx(() {
                        if (!controller.isCameraInitialized.value) {
                          return const Center(child: CupertinoActivityIndicator(color: Colors.white));
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AspectRatio(
                            aspectRatio: controller.cameraController!.value.aspectRatio,
                            child: CameraPreview(controller.cameraController!),
                          ),
                        );
                      }),
                    ),
                  ),

                  // --- AREA 3: KONTROL & TIMER (KODE YANG HILANG) ---
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15, // 15% tinggi layar
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      // ### AWAL DARI KODE YANG HILANG ###
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Tampilan Timer
                          Column(
                            mainAxisSize: MainAxisSize.min,
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
                                      fontSize: 42,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                          
                          // Tombol Scan yang Reaktif
                          Obx(
                            () => SizedBox(
                              width: 150,
                              height: 60,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xff2c3e50),
                                  disabledBackgroundColor: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: controller.isProcessing.value
                                    ? null
                                    : () => controller.scanPuzzle(),
                                icon: controller.isProcessing.value
                                    ? const CupertinoActivityIndicator(
                                        color: Color(0xff2c3e50),
                                      )
                                    : const Icon(CupertinoIcons.camera_viewfinder,
                                        size: 28),
                                label: Text(
                                  controller.isProcessing.value ? 'Proses...' : 'Scan',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ### AKHIR DARI KODE YANG HILANG ###
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}