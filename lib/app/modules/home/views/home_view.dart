import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Menggunakan background gradasi yang sama dengan Splash Screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff2c3e50), Color(0xff34495e)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- BAGIAN HEADER ---
                Column(
                  children: [
                    const Icon(
                      CupertinoIcons.arrowtriangle_left_square_fill,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selamat Datang',
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Pilih mode untuk memulai petualanganmu',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ).animate().fade(duration: 500.ms).slideY(begin: -0.2),

                // --- BAGIAN TOMBOL MENU UTAMA ---
                Column(
                  children: [
                    MenuButton(
                      text: 'Mulai Bermain',
                      icon: CupertinoIcons.play_arrow_solid,
                      onPressed: () => controller.goToLevelSelect(),
                      isPrimary: true,
                    ),
                    const SizedBox(height: 16),
                    MenuButton(
                      text: 'Papan Peringkat',
                      icon: CupertinoIcons.list_number,
                      onPressed: () => controller.goToLeaderboard(),
                    ),
                    const SizedBox(height: 16),
                    MenuButton(
                      text: 'Pengaturan',
                      icon: CupertinoIcons.settings_solid,
                      onPressed: () => controller.goToSettings(),
                    ),
                  ],
                )
                    .animate() // Memberi jeda antar animasi tombol
                    .fade(delay: 300.ms, duration: 500.ms)
                    .slideX(begin: -0.5, duration: 400.ms, curve: Curves.easeOut),
                
                // --- BAGIAN TOMBOL PEMBELIAN PRODUK ---
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff2c3e50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () => controller.launchProductUrl(),
                  icon: const Icon(CupertinoIcons.shopping_cart),
                  label: Text(
                    'Dapatkan Tangram Fisik!',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  ),
                )
                    .animate()
                    .fade(delay: 800.ms, duration: 600.ms)
                    .shake(delay: 1000.ms, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Widget untuk tombol agar kode tidak berulang
class MenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const MenuButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isPrimary ? Colors.white : Colors.white.withOpacity(0.2),
          foregroundColor: isPrimary ? const Color(0xff2c3e50) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}