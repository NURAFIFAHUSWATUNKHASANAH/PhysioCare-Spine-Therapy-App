import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color kMidnightBlue = Color(0xFF0C2D57);
    const Color kRosePink = Color(0xFFFF8E9E);
    const Color kBgSoft = Color(0xFFFAFBFF);

    return Obx(() {
      final isFirstPage = controller.currentPage.value == 0;

      return Scaffold(
        backgroundColor: isFirstPage ? kMidnightBlue : kBgSoft,
        body: Stack(
          children: [
            // --- 1. ANIMATED BACKGROUND DECORATION ---
            _AnimatedBackground(
              isFirstPage: isFirstPage, 
              blue: kMidnightBlue, 
              pink: kRosePink
            ),

            // --- 2. MAIN CONTENT PAGEVIEW ---
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildPage(
                  image: 'assets/splash1.png',
                  title: 'PregMate',
                  subtitle: 'Dari Dua Hati, Menyambut Satu Kehidupan',
                  isDark: true,
                  brandColor: kRosePink,
                ),
                _buildPage(
                  image: 'assets/splash2.png',
                  title: 'Pantau Kehamilan',
                  subtitle: 'Lacak perkembangan janin, usia kehamilan,\ndan dapatkan pengingat serta edukasi\nkesehatan untuk Bunda.',
                  isDark: false,
                  brandColor: kMidnightBlue,
                ),
                _buildPage(
                  image: 'assets/splash3.png',
                  title: 'Sehat & Nyaman',
                  subtitle: 'Lakukan yoga prenatal, relaksasi,\nserta berbagi pengalaman bersama\nkomunitas Bunda.',
                  isDark: false,
                  brandColor: kMidnightBlue,
                  showButton: true,
                ),
              ],
            ),

            // --- 3. BOTTOM NAVIGATION (Indicators & Skip) ---
            Positioned(
              bottom: 60,
              left: 30,
              right: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: controller.currentPage.value == index ? 32 : 8,
                        decoration: BoxDecoration(
                          color: isFirstPage 
                              ? (controller.currentPage.value == index ? kRosePink : Colors.white24)
                              : (controller.currentPage.value == index ? kMidnightBlue : kMidnightBlue.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  if (controller.currentPage.value < 2)
                    TextButton(
                      onPressed: () => controller.pageController.animateToPage(2, 
                          duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn),
                      child: Text(
                        "Lewati",
                        style: TextStyle(
                          color: isFirstPage ? Colors.white70 : kMidnightBlue.withOpacity(0.5),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPage({
    required String image,
    required String title,
    required String subtitle,
    required bool isDark,
    required Color brandColor,
    bool showButton = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _FloatingElement(
            child: Container(
              height: 280,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!isDark)
                    _BlurDot(color: brandColor.withOpacity(0.1), size: 220),
                  Image.asset(image, height: 260),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          _FadeInUp(
            delay: 0.2,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF0C2D57),
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 15),
          _FadeInUp(
            delay: 0.4,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.white.withOpacity(0.85) : Colors.blueGrey.shade600,
                height: 1.5,
              ),
            ),
          ),
          if (showButton) ...[
            const SizedBox(height: 45),
            _FadeInUp(
              delay: 0.6,
              child: _PulseButton(
                onPressed: () => Get.offAllNamed('/login'),
                color: const Color(0xFF0C2D57),
                text: 'Mulai Sekarang',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// --- SUPPORTING ANIMATED COMPONENTS ---

class _AnimatedBackground extends StatelessWidget {
  final bool isFirstPage;
  final Color blue;
  final Color pink;
  const _AnimatedBackground({required this.isFirstPage, required this.blue, required this.pink});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isFirstPage) ...[
          Positioned(
            top: -80,
            right: -40,
            child: _FloatingElement(
              duration: 7,
              offset: 25,
              child: _BlurDot(color: pink.withOpacity(0.12), size: 280),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -60,
            child: _FloatingElement(
              duration: 9,
              offset: -35,
              child: _BlurDot(color: pink.withOpacity(0.08), size: 220),
            ),
          ),
          Positioned(
            top: 200,
            left: 10,
            child: _FloatingElement(
              duration: 5,
              offset: 12,
              child: _BlurDot(color: pink.withOpacity(0.06), size: 100),
            ),
          ),
        ],

        if (!isFirstPage) ...[
          Positioned(
            top: -40,
            right: -40,
            child: _FloatingElement(
              duration: 5,
              offset: 15,
              child: Container(
                width: 220, height: 220, 
                decoration: BoxDecoration(shape: BoxShape.circle, color: blue.withOpacity(0.025))
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            left: -20,
            child: _FloatingElement(
              duration: 6,
              offset: -12,
              child: Container(
                width: 130, height: 130, 
                decoration: BoxDecoration(shape: BoxShape.circle, color: pink.withOpacity(0.04))
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _FadeInUp extends StatelessWidget {
  final Widget child;
  final double delay;
  const _FadeInUp({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: (600 * (1 + delay)).toInt()),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 25 * (1 - value)), child: child),
        );
      },
      child: child,
    );
  }
}

class _FloatingElement extends StatefulWidget {
  final Widget child;
  final double offset;
  final int duration;
  const _FloatingElement({required this.child, this.offset = 10, this.duration = 3});

  @override
  State<_FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<_FloatingElement> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    _ctrl = AnimationController(vsync: this, duration: Duration(seconds: widget.duration))..repeat(reverse: true);
    super.initState();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, widget.offset * _ctrl.value),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _PulseButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  const _PulseButton({required this.onPressed, required this.color, required this.text});

  @override
  State<_PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<_PulseButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    super.initState();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(0.15 + (0.15 * _ctrl.value)),
              blurRadius: 12 + (8 * _ctrl.value),
              spreadRadius: 1 * _ctrl.value,
            )
          ],
        ),
        child: child,
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          elevation: 0,
        ),
        child: Text(widget.text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _BlurDot extends StatelessWidget {
  final Color color;
  final double size;
  const _BlurDot({required this.color, required this.size});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, 
      height: size, 
      decoration: BoxDecoration(
        shape: BoxShape.circle, 
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size / 1.8,
            spreadRadius: size / 5,
          )
        ]
      )
    );
  }
}