import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompletionPopup extends StatelessWidget {
  const CompletionPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selamat!!!"),
      content: const Text("Anda telah menyelesaikan terapi."),
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text("Selesai"),
        ),
      ],
    );
  }
}
