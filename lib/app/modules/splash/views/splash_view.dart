import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0C2D57);
    const Color accentColor = Color(0xFF235BAD);

    return Obx(() {
      final isFirstPage = controller.currentPage.value == 0;

      return Scaffold(
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            // SP 1 menggunakan Gradient, SP 2 & 3 menggunakan Soft White
            gradient: isFirstPage
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, accentColor],
                  )
                : const LinearGradient(
                    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
                  ),
          ),
          child: Stack(
            children: [
              // --- DEKORASI BACKGROUND (Agar tidak polos) ---
              if (!isFirstPage) ...[
                Positioned(
                  top: -100,
                  right: -100,
                  child: _buildCircle(primaryColor.withOpacity(0.03), 300),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: _buildCircle(primaryColor.withOpacity(0.05), 200),
                ),
              ],

              // 1. PageView Konten
              PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildPage(
                    image: 'assets/splash1.png',
                    title: 'PhysioCare',
                    subtitle: 'Gerak Lebih Baik,\nPulih Lebih Cepat',
                    isDark: true,
                  ),
                  _buildPage(
                    image: 'assets/splash2.png',
                    title: 'Selamat Datang',
                    subtitle: 'Panduan terapi personal yang dirancang khusus untuk kebutuhan pemulihan Anda.',
                    isDark: false,
                  ),
                  _buildPage(
                    image: 'assets/splash3.png',
                    title: 'Analisis AI',
                    subtitle: 'Teknologi AI cerdas untuk menganalisis dan mengoreksi setiap gerakan terapi Anda.',
                    isDark: false,
                    showButton: true,
                  ),
                ],
              ),

              // 2. Custom Indicator & Navigation
              Positioned(
                bottom: 50,
                left: 30,
                right: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Modern Dot Indicators
                    Row(
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 6,
                          width: controller.currentPage.value == index ? 28 : 8,
                          decoration: BoxDecoration(
                            color: isFirstPage 
                                ? (controller.currentPage.value == index ? Colors.white : Colors.white30)
                                : (controller.currentPage.value == index ? primaryColor : Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    
                    // Tombol Skip (Hanya muncul jika bukan halaman terakhir)
                    if (controller.currentPage.value < 2)
                      TextButton(
                        onPressed: () => controller.pageController.animateToPage(
                          2, 
                          duration: const Duration(milliseconds: 800), 
                          curve: Curves.fastOutSlowIn
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: isFirstPage ? Colors.white : primaryColor,
                        ),
                        child: const Text(
                          "Lewati",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Widget Dekoratif Lingkaran
  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String subtitle,
    required bool isDark,
    bool showButton = false,
  }) {
    final textColor = isDark ? Colors.white : const Color(0xFF0C2D57);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar dengan animasi floating sederhana
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: !isDark ? BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0C2D57).withOpacity(0.08),
                    blurRadius: 50,
                    offset: const Offset(0, 20),
                  )
                ],
              ) : null,
              child: Image.asset(image, height: 260),
            ),
          ),
          const SizedBox(height: 60),
          
          // Judul
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: -1.2,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          
          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: textColor.withOpacity(isDark ? 0.85 : 0.7),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          
          if (showButton) ...[
            const SizedBox(height: 50),
            _buildGetStartedButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C2D57).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Get.offAllNamed('/login'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C2D57),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mulai Pemulihan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}