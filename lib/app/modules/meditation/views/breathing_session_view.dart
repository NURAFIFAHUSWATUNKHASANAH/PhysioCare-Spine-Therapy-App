import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:ui';

class BreathingSessionView extends StatefulWidget {
  final String title;
  final int duration;

  const BreathingSessionView({
    super.key,
    required this.title,
    required this.duration,
  });

  @override
  State<BreathingSessionView> createState() => _BreathingSessionViewState();
}

class _BreathingSessionViewState extends State<BreathingSessionView>
    with SingleTickerProviderStateMixin {
  // Kontrol Animasi
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  // Kontrol Waktu
  Timer? _sessionTimer;
  Timer? _breathingTimer;

  int remainingSeconds = 0;
  int breathingCounter = 4;
  String breathingText = "Siap?";
  bool isInhaling = true;
  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.duration;

    // Inisialisasi Kontroler (Durasi 4 detik untuk satu fase napas)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Animasi ukuran lingkaran agar terasa organik
    _sizeAnimation = Tween<double>(begin: 140, end: 260).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    // Animasi rotasi halus
    _rotationAnimation =
        Tween<double>(begin: 0, end: math.pi).animate(_controller);

    // Listener untuk perpindahan fase Tarik/Hembus
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          breathingText = "Hembuskan";
          isInhaling = false;
          breathingCounter = 4;
        });
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (isStarted) {
          setState(() {
            breathingText = "Tarik Napas";
            isInhaling = true;
            breathingCounter = 4;
          });
          _controller.forward();
        }
      }
    });
  }

  // --- LOGIKA SESI ---

  void startSession() {
    setState(() {
      isStarted = true;
      breathingText = "Tarik Napas";
    });
    _controller.forward();
    _startSessionTimer();
    _startBreathingCounter();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        timer.cancel();
        _controller.stop();
        _showCompletionDialog();
      }
    });
  }

  void _startBreathingCounter() {
    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (breathingCounter > 1) {
          breathingCounter--;
        } else {
          breathingCounter = 4;
        }
      });
    });
  }

  void _showCompletionDialog() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Sesi Selesai", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Luar biasa Bunda! Anda telah meluangkan waktu untuk ketenangan diri."),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Tutup Dialog
              Get.back(); // Kembali ke List
            },
            child: const Text("SAMA-SAMA", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _controller.dispose();
    _sessionTimer?.cancel();
    _breathingTimer?.cancel();
    super.dispose();
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    const Color kMidnightBlue = Color(0xFF0C2D57);
    const Color kRosePink = Color(0xFFFF8E9E);
    double progress = 1 - (remainingSeconds / widget.duration);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT DYNAMIS
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isInhaling
                    ? [kMidnightBlue, const Color(0xFF1A4D8C)]
                    : [const Color(0xFF1A4D8C), kMidnightBlue],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Timer Sesi
                Text(formatTime(remainingSeconds),
                    style: const TextStyle(color: Colors.white70, fontSize: 18, letterSpacing: 2)),
                const SizedBox(height: 20),
                
                // Progress Bar Halus
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    color: kRosePink.withOpacity(0.8),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 50),

                // Teks Instruksi
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    breathingText,
                    key: ValueKey(breathingText),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                
                // Counter Detik Napas
                Text(
                  isStarted ? breathingCounter.toString() : "-",
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                
                const SizedBox(height: 60),

                // 2. LINGKARAN ANIMASI
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        _buildRipple(size: _sizeAnimation.value + 45, opacity: 0.1, color: kRosePink),
                        _buildRipple(size: _sizeAnimation.value + 20, opacity: 0.2, color: kRosePink),
                        Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Container(
                            width: _sizeAnimation.value,
                            height: _sizeAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [kRosePink, Color(0xFFFFB5C0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kRosePink.withOpacity(0.4),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: const Icon(Icons.self_improvement, color: Colors.white, size: 45),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 100),
                
                // Tombol Batal/Selesai Manual
                _buildSelesaiButton(),
              ],
            ),
          ),

          // 3. OVERLAY BLUR SEBELUM MULAI
          if (!isStarted)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: kMidnightBlue.withOpacity(0.6),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.spa_outlined, color: kRosePink, size: 80),
                        const SizedBox(height: 20),
                        const Text(
                          "Ambil Posisi Nyaman",
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Tekan tombol di bawah untuk memulai",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: startSession,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kRosePink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 15,
                            shadowColor: kRosePink.withOpacity(0.5),
                          ),
                          child: const Text(
                            "MULAI SEKARANG",
                            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildRipple({required double size, required double opacity, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }

  Widget _buildSelesaiButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "BATALKAN",
                style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w600, letterSpacing: 1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}