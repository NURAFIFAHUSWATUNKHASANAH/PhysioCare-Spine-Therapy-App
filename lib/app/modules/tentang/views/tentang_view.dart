import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TentangView extends StatelessWidget {
  const TentangView({super.key});

  @override
  Widget build(BuildContext context) {
    const navyColor = Color(0xFF0C2D57);

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Tentang PregMate',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: navyColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Header dengan Logo/Ikon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: navyColor.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.pregnant_woman_rounded, size: 48, color: navyColor),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "PregMate",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: navyColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Aplikasi pintar untuk memantau kehamilan dan mendukung ibu dalam proses persalinan dengan fitur yang lengkap dan personal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 2. Feature Section (Grid atau List)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fitur Unggulan PregMate",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: navyColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.child_friendly_rounded,
                    "Status Kehamilan",
                    "Pantau usia janin, trimester, HPL, dan perkembangan kehamilan setiap saat.",
                  ),
                  _buildFeatureItem(
                    Icons.monitor_weight,
                    "Berat Badan & Kesehatan",
                    "Catat berat badan, nutrisi, dan kondisi kesehatan ibu dan janin.",
                  ),
                  _buildFeatureItem(
                    Icons.spa,
                    "Senam & Relaksasi",
                    "Panduan senam hamil dan latihan relaksasi untuk ibu hamil.",
                  ),
                  _buildFeatureItem(
                    Icons.calendar_month,
                    "Pengingat & Jadwal",
                    "Notifikasi cerdas untuk jadwal check-up, obat, dan aktivitas harian.",
                  ),
                  _buildFeatureItem(
                    Icons.description_rounded,
                    "Edukasi & Artikel",
                    "Akses artikel edukatif untuk menambah pengetahuan ibu dan keluarga.",
                  ),
                  _buildFeatureItem(
                    Icons.forum,
                    "Forum Ibu & Pendamping",
                    "Diskusi dengan ibu hamil lainnya atau pendamping untuk berbagi pengalaman.",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 3. Footer / Slogan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 20),
                  Text(
                    "💙 PregMate",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: navyColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Pantau Kehamilan, Dukung Ibu, Sehat Bersama",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0C2D57).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF0C2D57), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0C2D57),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}