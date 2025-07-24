import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    // Memanggil controller sekali agar GetX tahu view ini aktif
    // (meskipun tidak ada state reaktif, ini praktik yang baik)
    Get.find<SplashController>();

    return Scaffold(
      body: Container(
        // Memberi latar belakang gradasi yang modern
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2c3e50), Color(0xff34495e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. IKON PUZZLE
              const Icon(
                CupertinoIcons.arrowtriangle_left_square_fill,
                size: 100,
                color: Colors.white,
              )
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
              
              const SizedBox(height: 24),

              // 2. JUDUL GAME
              Text(
                'Tangram Master',
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              )
                  .animate()
                  .fade(delay: 500.ms, duration: 800.ms)
                  .slideY(begin: 0.5, duration: 700.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 8),

              // 3. SUBTITLE / TAGLINE
              Text(
                'Asah Otak, Susun Bentuk',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              )
                  .animate()
                  .fade(delay: 800.ms, duration: 900.ms)
                  .then(duration: 1000.ms) // Jeda sebelum efek shimmer
                  .shimmer(color: Colors.white.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}