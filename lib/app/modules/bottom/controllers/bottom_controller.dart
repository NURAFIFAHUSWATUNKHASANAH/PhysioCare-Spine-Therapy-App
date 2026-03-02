import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
class BottomController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Ambil argument dari Get dan set index jika ada
    final arg = Get.arguments;
    if (arg != null && arg is int && arg >= 0 && arg < 4) {
      selectedIndex.value = arg;
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
  void openArtikelVisualisasi() async {
    final Uri url = Uri.parse(
      'https://physiocare-afifah22090161-2n2f5vdmcpcqq95t8hleyq.streamlit.app/',
    );

    bool launched = await launchUrl(url, mode: LaunchMode.platformDefault);

    if (!launched) {
      Get.snackbar("Gagal", "Tidak bisa membuka link.");
    }
  }
}
