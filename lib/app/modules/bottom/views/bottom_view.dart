import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pyhsiocare/app/modules/bottom/controllers/bottom_controller.dart';
import 'package:pyhsiocare/app/modules/histori/views/histori_view.dart';
import 'package:pyhsiocare/app/modules/home/views/home_view.dart';
import 'package:pyhsiocare/app/modules/profil/views/profil_view.dart';
import 'package:pyhsiocare/app/modules/terapi/views/terapi_view.dart';

class BottomScreen extends GetView<BottomController> {
  // Menghapus 'const' dari dalam list agar tidak terjadi error compile
  final List<Widget> pages = [
    const HomeView(),
    TerapiView(),
    HistoriView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody memungkinkan konten halaman mengalir di belakang navbar yang melayang
      extendBody: true,
      body: Obx(() => pages[controller.selectedIndex.value]),
      
      // 1. Navigation Bar Gaya Floating Modern
      bottomNavigationBar: Obx(
        () => Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 25), // Memberikan jarak dari tepi layar
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0C2D57).withOpacity(0.15),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF0C2D57), // Senada dengan Dashboard
              unselectedItemColor: const Color(0xFF94A3B8),
              showSelectedLabels: true,
              showUnselectedLabels: false, // Membuat tampilan lebih clean
              selectedFontSize: 12,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
              elevation: 0,
              items: [
                _buildNavItem(Icons.grid_view_rounded, "Home"),
                _buildNavItem(Icons.volunteer_activism_rounded, "Terapi"),
                _buildNavItem(Icons.history_rounded, "Histori"),
                _buildNavItem(Icons.person_rounded, "Profil"),
              ],
            ),
          ),
        ),
      ),

      // 2. Floating Action Button Estetik (Di atas Navbar)
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 95), // Posisi tepat di atas navbar melayang
      //   child: FloatingActionButton.extended(
      //     onPressed: controller.openArtikelVisualisasi,
      //     elevation: 4,
      //     backgroundColor: const Color(0xFF0C2D57),
      //     icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
      //     label: const Text(
      //       "Visualisasi Artikel",
      //       style: TextStyle(
      //         color: Colors.white,
      //         fontWeight: FontWeight.bold,
      //         letterSpacing: 0.5,
      //       ),
      //     ),
      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      //   ),
      // ),
    );
  }

  // Fungsi pembantu untuk icon yang lebih interaktif
  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 24),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0C2D57).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF0C2D57), size: 24),
      ),
      label: label,
    );
  }
}