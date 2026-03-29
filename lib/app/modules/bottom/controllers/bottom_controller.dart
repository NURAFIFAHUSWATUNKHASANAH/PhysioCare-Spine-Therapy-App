import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';

class BottomController extends GetxController {

  var selectedIndex = 0.obs;
  var role = "".obs;

  @override
  void onInit() async {
    super.onInit();

final box = GetStorage();
role.value = box.read("user_role") ?? "";

    final arg = Get.arguments;
    if (arg != null && arg is int && arg >= 0 && arg < 3) {
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

    bool launched = await launchUrl(url);

    if (!launched) {
      Get.snackbar("Gagal", "Tidak bisa membuka link.");
    }
  }
}