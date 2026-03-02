import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      body: Stack(
        children: [
          // Dekorasi Background (Aksen Halus)
          Positioned(
            top: -50,
            left: -50,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: const Color(0xFF0C2D57).withOpacity(0.05),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      const Text(
                        "Daftar Akun",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0C2D57),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Mulailah perjalanan pemulihan Anda dengan PhysioCare.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 35),

                      // Input Email
                      _buildLabel("Email"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.emailController,
                        hint: "Contoh: user@email.com",
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 20),

                      // Input Nama
                      _buildLabel("Nama Lengkap"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.nameController,
                        hint: "Masukkan nama lengkap Anda",
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 20),

                      // Input Password
                      _buildLabel("Kata Sandi"),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: controller.passwordController,
                        hint: "••••••••",
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                      ),
                      const SizedBox(height: 40),

                      // Tombol Daftar
                      _buildRegisterButton(),
                      
                      const SizedBox(height: 32),

                      // Footer: Link ke Login
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.toNamed('/login'),
                          child: RichText(
                            text: TextSpan(
                              text: "Sudah punya akun? ",
                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              children: const [
                                TextSpan(
                                  text: "Masuk Disini",
                                  style: TextStyle(
                                    color: Color(0xFF0C2D57),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

  // --- Widget Helpers ---

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0C2D57),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF0C2D57), size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF0C2D57), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0C2D57).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: controller.register,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0C2D57),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text(
          "Buat Akun",
          style: TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}