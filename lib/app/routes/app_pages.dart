import 'package:get/get.dart';
import 'package:pyhsiocare/app/modules/rekomendasi/bindings/rekomendasi_binding.dart';
import 'package:pyhsiocare/app/modules/rekomendasi/views/rekomendasi_view.dart';

import '../modules/artikel/views/all_articles_view.dart';
import '../modules/bottom/bindings/bottom_binding.dart';
import '../modules/bottom/views/bottom_view.dart';
import '../modules/edit_profil/bindings/edit_profil_binding.dart';
import '../modules/edit_profil/views/edit_profil_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/histori/bindings/histori_binding.dart';
import '../modules/histori/views/histori_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/jadwal/bindings/jadwal_binding.dart';
import '../modules/jadwal/views/jadwal_dialog.dart';
import '../modules/keluhan/bindings/keluhan_binding.dart';
import '../modules/keluhan/views/keluhan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tentang/bindings/tentang_binding.dart';
import '../modules/tentang/views/tentang_view.dart';
import '../modules/terapi/bindings/terapi_binding.dart';
import '../modules/terapi/views/terapi_view.dart';
import '../modules/verify_otp/bindings/verify_otp_binding.dart';
import '../modules/verify_otp/views/verify_otp_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TERAPI,
      page: () => TerapiView(),
      binding: TerapiBinding(),
    ),
    GetPage(
      name: _Paths.HISTORI,
      page: () => HistoriView(),
      binding: HistoriBinding(),
    ),
    GetPage(
      name: Routes.PROFIL,
      page: () => ProfileView(),
      binding: ProfilBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM,
      page: () => BottomScreen(),
      binding: BottomBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    // GetPage(
    //   name: _Paths.REKOMENDASI,
    //   page: () => RekomendasiDialog(), // Ganti sesuai nama view kamu
    //   binding: RekomendasiBinding(),
    // ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.KELUHAN,
      page: () => KeluhanView(),
      binding: KeluhanBinding(),
    ),
    GetPage(
      name: _Paths.JADWAL,
      page: () => JadwalDialog(),
      binding: JadwalBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFIL,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.TENTANG,
      page: () => const TentangView(),
      binding: TentangBinding(),
    ),
    GetPage(name: _Paths.ALL_ARTICLES, page: () => AllArtikelView()),
    GetPage(name: '/artikel', page: () => AllArtikelView()),
    GetPage(name: '/article_detail', page: () => AllArtikelView()),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: VerifyOtpBinding(),
    ),
  ];
}
