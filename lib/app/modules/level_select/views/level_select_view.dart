import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/level_model.dart';
import '../controllers/level_select_controller.dart';

class LevelSelectView extends GetView<LevelSelectController> {
  const LevelSelectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Pilih Level',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white.withOpacity(0.1),
        elevation: 0,
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
        // Gunakan Obx untuk membuat UI bereaksi terhadap perubahan state di controller
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 15,
            ));
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 120, 16, 32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 kolom
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9, // Mengatur rasio tinggi-lebar kartu
            ),
            itemCount: controller.levelList.length,
            itemBuilder: (context, index) {
              final level = controller.levelList[index];
              return LevelCard(
                level: level,
                onTap: () => controller.selectLevel(level),
              )
                  // Animasi untuk setiap kartu yang muncul
                  .animate()
                  .fade(delay: (index * 40).ms, duration: 400.ms)
                  .slideY(
                      begin: 0.5,
                      delay: (index * 40).ms,
                      duration: 400.ms,
                      curve: Curves.easeOut);
            },
          );
        }),
      ),
    );
  }
}

// Custom Widget untuk kartu level agar lebih rapi
class LevelCard extends StatelessWidget {
  final Level level;
  final VoidCallback onTap;

  const LevelCard({super.key, required this.level, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  level.level.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  level.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}