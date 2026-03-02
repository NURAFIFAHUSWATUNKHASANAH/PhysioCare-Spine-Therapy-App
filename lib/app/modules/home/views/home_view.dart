import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pyhsiocare/app/modules/artikel/views/article_detail_view.dart';
import 'package:pyhsiocare/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pyhsiocare/app/modules/jadwal/controllers/jadwal_controller.dart';
import 'package:pyhsiocare/app/modules/keluhan/controllers/keluhan_controller.dart';
import 'package:pyhsiocare/app/modules/profil/controllers/profil_controller.dart';
import 'package:pyhsiocare/app/widgets/keluhan_dialog.dart';
import '../controllers/home_controller.dart';
import 'package:pyhsiocare/app/modules/artikel/controllers/artikel_controller.dart';
import 'package:pyhsiocare/app/modules/artikel/views/all_articles_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => KeluhanController());
    final profileController = Get.find<ProfileController>();
    final JadwalController jadwalController = Get.put(JadwalController());
    final ArtikelController artikelController = Get.put(ArtikelController());
    artikelController.fetchArtikels();

    _updateTokenFCM();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8), // Background medis yang segar
      body: Stack(
        children: [
          // Background Decor (Lingkaran abstrak untuk kesan modern)
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: const Color(0xFF0C2D57).withOpacity(0.05),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Header & Profile Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Pagi,",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14),
                            ),
                            Obx(() => Text(
                                  profileController.namaC.value,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0C2D57),
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10)
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person_outline,
                                color: Color(0xFF0C2D57)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Hero Image (Visual Utama)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0C2D57), Color(0xFF2196F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: AssetImage('assets/home.png'),
                        fit: BoxFit.cover,
                        opacity: 0.3, // Membuat gambar menyatu dengan gradient
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kesehatan Tulang Belakang\nAdalah Prioritas Utama.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Pantau Progress Anda",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // 3. Stats Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Ringkasan Aktivitas",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155)),
                        ),
                        const SizedBox(height: 15),
                        Obx(() => Row(
                              children: [
                                Expanded(
                                  child: _buildModernStatCard(
                                    title: "Total Latihan",
                                    value:
                                        "${controller.totalLatihan.value ?? 0}",
                                    sub: "Sesi Selesai",
                                    icon: Icons.bolt_rounded,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildModernStatCard(
                                    title: "Waktu Terapi",
                                    sub: controller.totalWaktuLatihan.value
                                            .contains('jam')
                                        ? 'Jam Total'
                                        : 'Menit Total',
                                    value: controller
                                            .totalWaktuLatihan.value.isNotEmpty
                                        ? controller.totalWaktuLatihan.value
                                            .split(' ')[0]
                                        : '0',
                                    icon: Icons.history_toggle_off_rounded,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),

                // 4. Action Buttons (Grid Style)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            onPressed: () => Get.dialog(KeluhanDialog()),
                            label: "Cek Keluhan",
                            icon: Icons.search_rounded,
                            color: const Color(0xFF0C2D57),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildActionButton(
                            onPressed: () =>
                                jadwalController.showJadwalDialog(),
                            label: "Buat Jadwal",
                            icon: Icons.calendar_month_rounded,
                            color: Colors.white,
                            textColor: const Color(0xFF0C2D57),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. Article Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Edukasi Spine Care",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF334155)),
                            ),
                            TextButton(
                              onPressed: () => Get.to(() => AllArtikelView()),
                              child: const Text("Lihat Semua"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          if (artikelController.isLoading.value)
                            return const CircularProgressIndicator();
                          return SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: artikelController.artikels.length > 5
                                  ? 5
                                  : artikelController.artikels.length,
                              itemBuilder: (context, index) {
                                final artikel =
                                    artikelController.artikels[index];
                                return _buildModernArticleCard(artikel);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Stat Card Modern
  Widget _buildModernStatCard(
      {required String title,
      required String value,
      required String sub,
      required IconData icon,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 15),
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(sub, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }

  // Helper Widget: Action Button Modern
  Widget _buildActionButton(
      {required VoidCallback onPressed,
      required String label,
      required IconData icon,
      required Color color,
      Color? textColor}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: color == Colors.white
              ? [const BoxShadow(color: Colors.black12, blurRadius: 10)]
              : [
                  BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ],
        ),
        child: Column(
          children: [
            Icon(icon, color: textColor ?? Colors.white),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Article Card Modern
  Widget _buildModernArticleCard(artikel) {
    return GestureDetector(
      onTap: () => Get.to(() => ArtikelDetailView(id: artikel.id)),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: artikel.imageUrl.isNotEmpty
                    ? Image.network(artikel.imageUrl,
                        fit: BoxFit.cover, width: double.infinity)
                    : Container(color: Colors.grey[200]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.title,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text("Baca Selengkapnya",
                      style: TextStyle(color: Colors.blue[700], fontSize: 11)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateTokenFCM() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('_id');
    if (userId == null || userId.isEmpty) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse(ApiConfig.updateTokenUri),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'user_id': userId, 'token': token}),
        );
      }
    } catch (e) {
      debugPrint('Error update token: $e');
    }
  }
}
