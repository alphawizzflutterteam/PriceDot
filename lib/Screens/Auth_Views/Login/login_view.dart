import 'package:pricedot/Constants.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Screens/Auth_Views/Login/login_controller.dart';
import 'package:pricedot/Screens/Home/home_view.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Utils/extentions.dart';
import 'package:pricedot/Utils/session.dart';
import 'package:pricedot/Widgets/app_button.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _ref = TextEditingController();
  bool isEighteenPlus = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      builder: (controller) => Scaffold(
        body: Form(
          key: _formkey,
          child: Container(
              height: MediaQuery.of(context).size.height,
              // color: AppColors.bgColor,
              decoration: const BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage("assets/images/bg.png"),
                //   fit: BoxFit.fill,
                // ),
                gradient: LinearGradient(colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],begin: Alignment.topLeft,end: Alignment.bottomRight),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*.1,
                      ),
                      Image.asset(
                        "assets/icons/logo.png",
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height*.2,
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.whit.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Login/Register".tr,
                                style: TextStyle(
                                    color: AppColors.whit,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              //("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic",style: TextStyle(color: AppColors.subTxtClr,fontWeight: FontWeight.normal,fontSize: 15),),
                              const SizedBox(
                                height: 40,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                width: double.maxFinite,
                                height: 50,
                                decoration:
                                    CustomBoxDecoration.myCustomDecoration(),
                                child: TextFormField(
                                  maxLength: 10,
                                  controller: _mobile,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 15),
                                      counterText: "",
                                      hintText: "Mobile Number".tr,
                                      prefixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 10),
                                          Icon(
                                            Icons.phone,
                                            color: Color(0xFFA0A0A0),
                                          ),
                                          SizedBox(width: 5),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Text(
                                              "+91",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                      ),
                                      // contentPadding: EdgeInsets.all(10),
                                      //  prefixIcon: Icon(Icons.call),
                                      border: InputBorder.none),
                                  style: const TextStyle(fontSize: 14),

                                  // validator: (val) {
                                  //
                                  //   if (val!.isEmpty) {
                                  //     return "Mobile cannot be empty";
                                  //   } else if (val.length < 10) {
                                  //     return "Please enter mobile must 10 digit";
                                  //   }
                                  // },
                                ),
                              ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   margin:
                              //       const EdgeInsets.symmetric(horizontal: 20),
                              //   width: double.maxFinite,
                              //   height: 50,
                              //   decoration:
                              //       CustomBoxDecoration.myCustomDecoration(),
                              //   child: TextFormField(
                              //     controller: _ref,
                              //     decoration: InputDecoration(
                              //         contentPadding: EdgeInsets.only(top: 15),
                              //         counterText: "",
                              //         hintText: "Referral Code (Optional)".tr,
                              //         prefixIcon: Icon(
                              //           Icons.group,
                              //           color: Color(0xFFA0A0A0),
                              //         ),
                              //         // contentPadding: EdgeInsets.all(10),
                              //         //  prefixIcon: Icon(Icons.call),
                              //         border: InputBorder.none),
                              //     style: const TextStyle(fontSize: 14),
                              //   ),
                              // ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isEighteenPlus,
                                    onChanged: (val) {
                                      if (val != null) {
                                        isEighteenPlus = val;
                                        setState(() {});
                                      }
                                    },
                                    checkColor: AppColors.whit,
                                    activeColor: AppColors.buttonColor,
                                    hoverColor: AppColors.whit,
                                    side: const BorderSide(
                                      color: AppColors
                                          .whit, //your desire colour here
                                      width: 1.5,
                                    ),
                                  ),
                                  Text(
                                    "I confirm that I am 18+ year in age".tr,
                                    style: TextStyle(
                                        color: AppColors.whit, fontSize: 12),
                                  )
                                ],
                              ),

                              const SizedBox(
                                height: 32,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: controller.isLoading == true
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : AppButton(
                                        title: 'SEND OTP'.tr,
                                        onTap: () {
                                          if (_mobile.text.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please enter mobile number"
                                                        .tr);
                                          } else if (_mobile.text.length < 10) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please enter 10 digit mobile number"
                                                        .tr);
                                          } else if (!isEighteenPlus) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please confirm that you are 18+"
                                                        .tr);
                                          } else {
                                            controller.sendOtp(
                                                mobile: _mobile.text,
                                                referral_code: _ref.text);
                                          }
                                        }),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
