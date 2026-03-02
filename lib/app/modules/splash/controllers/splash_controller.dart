import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  var currentPage = 0.obs;
  PageController pageController = PageController();

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
