import 'dart:async';
import 'dart:io';
import 'package:pricedot/Controllers/app_base_controller/app_base_controller.dart';
import 'package:pricedot/Local_Storage/shared_pre.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Utils/PrefUtils.dart';

String CURR_USR = '';

class SplashController extends AppBaseController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // checkLogin();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    checkLogin();
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        checkLogin();
      }
    } on SocketException catch (_) {
      print('not connected');
      // Get.offAllNamed(noInterNetScreen);
    }
  }

  checkLogin() async {
    Timer(const Duration(seconds: 3), () async {
      var id = await SharedPre.getStringValue('userId');
      String lang = PreferenceUtils.getString(PrefKeys.language);
      CURR_USR = id;
      String isLogin = PreferenceUtils.getString(PrefKeys.isLogin);
      print('is login-----${isLogin}  Lang: $lang');
      switch (lang.toString()) {
        case "1":
          Get.updateLocale(Locale('hi', 'IN'));
          break;
        case "2":
          Get.updateLocale(Locale('en', 'US'));
          break;
        case "3":
          Get.updateLocale(Locale('gu', 'IN'));
          break;
        default:
          Get.updateLocale(Locale('en', 'US'));
          break;
      }
      if (isLogin=='true') {
        Get.offAllNamed(bottomBar);
      } else {
        Get.offAllNamed(selectLang);
      }
    });
  }
}
