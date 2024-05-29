import 'dart:convert';

import 'package:pricedot/Controllers/app_base_controller/app_base_controller.dart';
import 'package:pricedot/Local_Storage/shared_pre.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Services/api_services/apiStrings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pricedot/Utils/PrefUtils.dart';
import '../../../Routes/routes.dart';

class OTPVerifyController extends AppBaseController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    data = Get.arguments;
    print(data.toString());
    otp = data[1].toString();
    getFcm();
    print('______otp____${otp}_________');
  }

  RxBool isLoading = false.obs;
  List data = [];
  var otp;
  var textotp;
  String? token;

  Future<void> verifyOTP() async {
    isLoading.value = true;

    var param = {
      'mobile': data[0].toString(),
      'otp': otp.toString(),
      // 'fcm_id': '',
      'fcm_id': token,
    };

    apiBaseHelper.postAPICall(verifyOTPAPI, param).then((getData) async {
      
      bool status = getData['status'];
      String msg = getData['msg'];
      print('data---------${getData}');

      if (status) {
        SharedPre.setValue('userData', getData['user_name']);
        SharedPre.setValue('userMobile', getData['mobile']);
        SharedPre.setValue('userReferCode', getData['referral_code']);
        SharedPre.setValue('balanceUser', getData['wallet_balance']);
        SharedPre.setValue('userId', getData['user_id'].toString());
        SharedPre.setValue(SharedPre.isLogin, true);
       await PreferenceUtils.setString(PrefKeys.isLogin, "true");
        var id = await SharedPre.getStringValue('userId');
        CURR_USR = id;
        print('______getData____${getData['wallet_balance']}_________');
        print(id + "VERIFIAITO ");

        Fluttertoast.showToast(msg: msg);
        Get.offAllNamed(bottomBar);
      } else {
        Fluttertoast.showToast(msg: msg);
      }
      isLoading.value = false;
    });
  }

  Future<void> getFcm() async {
    try {
      token = await FirebaseMessaging.instance.getToken();
      print("-----------token:-----${token}");
    } on FirebaseException {
      print('__________FirebaseException_____________');
    }
  }

  Future<void> sendOtp({required String mobile}) async {
    isLoading.value = true;

    var param = {
      'mobile': mobile,
      'app_key':
          "#63Y@#)KLO57991(\$457D9(JE4dY3d2250f\$%#(mhgamesapp!xyz!punjablottery)8fm834(HKU8)5grefgr48mg1"
    };
    apiBaseHelper.postAPICall(sendOTPAPI, param).then((getData) {
      bool status = getData['status'];
      String msg = getData['msg'];
      otp = getData['otp'].toString();

      print('_____otp____${otp}_________');

      update();
      Fluttertoast.showToast(msg: msg);
      // if (status) {
      //   // Fluttertoast.showToast(msg: msg);
      //
      // } else {
      //   Fluttertoast.showToast(msg: msg);
      // }
      isLoading.value = false;
    });
  }
  // Future<void> resendSendOtp() async {
  //   update();
  //   var param = {
  //     'mobile': data[0].toString(),
  //     'app_key':"#63Y@#)KLO57991(\$457D9(JE4dY3d2250f\$%#(mhgamesapp!xyz!punjablottery)8fm834(HKU8)5grefgr48mg1"
  //   };
  //   apiBaseHelper.postAPICall(sendOTPAPI, param).then((getData) {
  //     bool status = getData['status'];
  //     String msg = getData['msg'];
  //     otp = getData['otp'].toString();
  //
  //     update();
  //     if (status) {
  //       Fluttertoast.showToast(msg: msg);
  //       update();
  //     } else {
  //     }
  //   });
  // }
}
