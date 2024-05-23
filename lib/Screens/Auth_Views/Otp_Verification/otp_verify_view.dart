import 'package:pricedot/Constants.dart';
import 'package:pricedot/Screens/Auth_Views/Otp_Verification/otp_verify_controller.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/app_button.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pricedot/Widgets/designConfig.dart';

import '../../../Routes/routes.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _Otp();
}

class _Otp extends State<OTPVerificationScreen> {
  String? newPin;
  int _seconds = 60;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OTPVerifyController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              flexibleSpace:FlexibleSpace,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text("Verification".tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              centerTitle: true,
              backgroundColor: AppColors.appbar,
            ),
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Stack(
                children: [
                  // customAuthOtp(context, ''),
                  Padding(
                    // padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/3.1),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 6),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          // Top-left corner radius
                          topRight: Radius.circular(30),
                          // Top-right corner radius
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 20, left: 20, top: 10),
                        child: Column(
                          children: [
                            Text(
                              'Enter the verification code that we sent you through your phone number, code has been sent to '
                                  .tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.fntClr, fontSize: 16),
                            ),
                            // const Text(
                            //   'Code has been sent to',
                            //   style: TextStyle(color: AppColors.fntClr),
                            // ),
                            Text(
                              "+91 ${controller.data[0].toString()}",
                              style: const TextStyle(
                                  fontSize: 20, color: AppColors.fntClr),
                            ),
                            Text(
                              "OTP: ${controller.otp}",
                              style: const TextStyle(
                                  fontSize: 20, color: AppColors.fntClr),
                            ),
                            // Text('OTP: ${controller.otp}',style: const TextStyle(fontSize: 20,color: AppColors.fntClr),),
                            const SizedBox(
                              height: 50,
                            ),
                            PinCodeTextField(

                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                controller.otp = value.toString();
                              },
                              textStyle:
                                  const TextStyle(color: AppColors.fntClr),
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                activeColor: AppColors.fntClr,
                                inactiveColor: AppColors.fntClr,
                                selectedColor: AppColors.primary,
                                fieldHeight: 60,
                                fieldWidth: 60,
                                inactiveFillColor: AppColors.fntClr,
                                activeFillColor: AppColors.fntClr,
                              ),
                              //pinBoxRadius:20,
                              appContext: context, length: 4,
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Haven't received the verification code?".tr,
                              style: TextStyle(
                                  color: AppColors.fntClr, fontSize: 16),
                            ),
                            InkWell(
                              onTap: () {
                                if (_seconds == 0) {
                                  _seconds = 60;
                                  controller.sendOtp(
                                      mobile: controller.data[0].toString());
                                  setState(() {});
                                }
                              },
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  Future.delayed(Duration(seconds: 1), () {
                                    if (_seconds > 0) {
                                      setState(() {
                                        _seconds--;
                                      });
                                      setState;
                                    }
                                  });
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Resend'.tr,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _seconds > 0
                                                ? Colors.grey
                                                : AppColors.primary),
                                      ),
                                      SizedBox(width: 3),
                                      _seconds > 0
                                          ? Text(
                                              '(${_seconds}s)',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.primary),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            // Obx(() => Padding(padding: const EdgeInsets.only(left: 25, right: 25), child: controller.isLoading.value ? const Center(child: CircularProgressIndicator(color: AppColors.primary),) :
                            //
                            // )
                            AppButton(
                                onTap: () {
                                  controller.verifyOTP();
                                  // if(newPin == controller.otp){
                                  //   controller.verifyOTP();
                                  // }else {
                                  //   Fluttertoast.showToast(msg: "Please enter pin");
                                  // }
                                },
                                title: 'VERIFY OTP'.tr)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
