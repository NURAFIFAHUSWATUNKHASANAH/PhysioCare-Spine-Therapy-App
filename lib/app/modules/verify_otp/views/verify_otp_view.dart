import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {
  const VerifyOtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Verifikasi OTP'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.blue[900],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Colors.blue[900]),
            const SizedBox(height: 20),
            Text(
              "Masukkan kode OTP yang dikirim ke email Anda",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.blue[900],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // OTP Input
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                hintText: "Masukkan OTP",
                counterText: "",
                prefixIcon: Icon(Icons.verified_user_outlined, color: Colors.blue[900]),
                hintStyle: TextStyle(color: Colors.blue[900]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.blue[900]!),
                ),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue[900],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Button or Loading
            Obx(() {
              return controller.isLoading.value
                  ? CircularProgressIndicator(color: Colors.blue[900])
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: controller.verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text(
                          "Verifikasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
