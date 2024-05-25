import 'dart:convert';
import 'dart:developer';

import 'package:pricedot/Constants.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Screens/AboutUs/AboutUs.dart';
import 'package:pricedot/Screens/Kyc/kycScreen.dart';
import 'package:pricedot/Screens/Language/language.dart';
import 'package:pricedot/Screens/Profile/contactus.dart';
import 'package:pricedot/Screens/Profile/profile_controller.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Screens/Withdrawal/withdrawal_view.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Utils/custom_clip_path.dart';
import 'package:pricedot/Widgets/button.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pricedot/Widgets/designConfig.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/get_profile_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../../Services/api_services/apiStrings.dart';
import '../../Widgets/auth_custom_design.dart';
import '../Auth_Views/Login/login_view.dart';
import '../FaQ/faq_view.dart';
import '../My Transaction/transaction_view.dart';
import 'package:http/http.dart' as http;

import '../RefundAndCancellation/terms_condition_view.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, this.isFrom}) : super(key: key);
  final bool? isFrom;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditProfile = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    referCode();
  }

  String? mobile, userId, userName, userBalance;
  referCode() async {
    mobile = await SharedPre.getStringValue('userMobile');
    userName = await SharedPre.getStringValue('userData');
    userId = await SharedPre.getStringValue('userId');
    userBalance = await SharedPre.getStringValue('balanceUser');
    print("refer");
    getProfile();
  }

  GetProfileModel? getProfileModel;

  getProfile() async {
    try {
      setState(() {
        getProfileModel = null;
      });
      var request = http.Request(
          'POST', Uri.parse('$baseUrl1/Apicontroller/apiGetProfile'));
      request.body = json.encode({"user_id": userId.toString()});
      print(request.body);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        var finalResult = GetProfileModel.fromJson(json.decode(result));
        setState(() {
          getProfileModel = finalResult;
          SharedPre.setValue(
              'referralCode', getProfileModel!.profile!.referralCode! ?? "");

          SharedPre.setValue('profile', getProfileModel);
        });
        // Fluttertoast.showToast(msg: "${finalResult.msg}");
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, StackTrace) {
      print(StackTrace);
      throw Exception(e);
    }
  }

  getDeco() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 3),
            color: Colors.black.withOpacity(.05))
      ],
      borderRadius: BorderRadius.circular(10),
      // border: Border.all(color: AppColors.fntClr)
    );
  }

  getSaved() async {
    var pro = await SharedPre.getStringValue('profile');
    getProfileModel = GetProfileModel.fromJson(jsonDecode(pro));
    setState(() {});
  }

  deleteAccount() async {
    try {
      userId = await SharedPre.getStringValue('userId');
      var request = http.MultipartRequest('POST',
          Uri.parse('${baseUrl}/Apicontroller/delete_account'));
      request.fields.addAll({'user_id': userId.toString()});
      http.StreamedResponse response = await request.send();
      var json = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        if (json['status'] == true) {
          Fluttertoast.showToast(msg: json['message']);
          await SharedPre.setValue(SharedPre.isLogin,false);

          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.pop(context);
          Get.offAllNamed(loginScreen);
        } else {
          Fluttertoast.showToast(msg: json['message']);
        }
      } else {
        Fluttertoast.showToast(msg: 'Something went wrong');
        print(response.reasonPhrase);
      }
    } catch (e, stacktrace) {
      print(stacktrace);
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: FlexibleSpace,
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          title: Text(
            "My Account".tr,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          // padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/3.1),
          padding: const EdgeInsets.only(top: 0),
          child: bodyWidget(
            context,
          ),
        ));
  }

  Widget bodyWidget(
    BuildContext context,
  ) {
    return getProfileModel == null || getProfileModel == " "
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary))
        : RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 2), () {
                getProfile();
              });
            },
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, i) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // color: AppColors.iconColor,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: RadialGradient(
                                  radius: 1.5,
                                  // begin: Alignment.centerLeft,
                                  // end: Alignment.centerRight,
                                  colors: [
                                AppColors.bgColor,
                                AppColors.fntClr.withOpacity(0.5),
                                AppColors.iconColor.withOpacity(0.5)
                              ])),
                        ),
                        //Text("My Account",style: TextStyle(color: AppColors.whit,fontSize: 20,fontWeight: FontWeight.bold),),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.bgColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 5, color: AppColors.whit),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          getProfileModel!.profile!.image
                                              .toString())),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Text(
                                    "${getProfileModel?.profile?.userName}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.fntClr),
                                  )),
                                  //  Center(child: Text("${getProfileModel?.profile?.email}",style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: AppColors.fntClr),)),
                                  Center(
                                      child: Text(
                                    "+91 ${getProfileModel?.profile?.mobile}",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.fntClr),
                                  )),
                                  // getProfileModel!.profile!.verified == '1'
                                  //     ? Center(
                                  //         child: Row(
                                  //         children: [
                                  //           Image.asset(
                                  //             'assets/icons/verify .png',
                                  //             height: 20,
                                  //             width: 20,
                                  //           ),
                                  //           const SizedBox(width: 3),
                                  //           const Text(
                                  //             "Verified",
                                  //             style: TextStyle(
                                  //                 fontSize: 15,
                                  //                 fontWeight: FontWeight.w500,
                                  //                 color: AppColors.fntClr),
                                  //           ),
                                  //         ],
                                  //       ))
                                  //     : const SizedBox.shrink(),
                                  Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfileScreen(
                                                  getProfileModel:
                                                      getProfileModel,
                                                ),
                                              ),
                                            ).then((value) {
                                              getProfile();
                                            });
                                          },
                                          child: Text(
                                            "Edit Profile".tr,
                                            style: TextStyle(
                                                color: AppColors.fntClr,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal),
                                          ))),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // getProfileModel!.profile!.verified == '1'
                              //     ? const SizedBox.shrink()
                              //     : CURR_USR == '243'
                              //         ? const SizedBox.shrink()
                              //         : GestureDetector(
                              //             onTap: () {
                              //               Navigator.push(
                              //                   context,
                              //                   MaterialPageRoute(
                              //                     builder: (context) =>
                              //                         KycScreen(
                              //                       adb: getProfileModel
                              //                               ?.profile?.adb ??
                              //                           '',
                              //                       adf: getProfileModel
                              //                               ?.profile?.adf ??
                              //                           '',
                              //                       pan: getProfileModel
                              //                               ?.profile?.pan ??
                              //                           '',
                              //                     ),
                              //                   )).then((val) {
                              //                 if (val) {
                              //                   getProfile();
                              //                 }
                              //               });
                              //             },
                              //             child: Container(
                              //
                              //               decoration: getDeco(),
                              //               child: Padding(
                              //                 padding:
                              //                     const EdgeInsets.symmetric(
                              //                         horizontal: 16,
                              //                         vertical: 10),
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     Row(
                              //                       children: [
                              //                         Padding(
                              //                           padding:
                              //                               const EdgeInsets
                              //                                   .only(left: 6),
                              //                           child: Image.asset(
                              //                             "assets/icons/kyc.png",
                              //                             height: 20,
                              //                             color: AppColors
                              //                                 .iconColor,
                              //                           ),
                              //                         ),
                              //                         const SizedBox(
                              //                           width: 10,
                              //                         ),
                              //                         Text(
                              //                           "KYC".tr,
                              //                           style: TextStyle(
                              //                               color: AppColors
                              //                                   .fntClr,
                              //                               fontWeight:
                              //                                   FontWeight
                              //                                       .bold),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     const Icon(
                              //                       Icons
                              //                           .arrow_forward_ios_outlined,
                              //                       color: AppColors.greyColor,
                              //                       size: 17,
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           ),

                              const SizedBox(
                                height: 8,
                              ),

                              CURR_USR == '243'
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        Get.toNamed(addMoney);
                                      },
                                      child: Container(
                                        
                                        decoration: getDeco(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6),
                                                    child: Image.asset(
                                                      "assets/images/Add Money.png",
                                                      height: 20,
                                                      color:
                                                          AppColors.iconColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Add Cash".tr,
                                                    style: TextStyle(
                                                        color: AppColors.fntClr,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: AppColors.greyColor,
                                                size: 17,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                              const SizedBox(
                                height: 8,
                              ),
                              CURR_USR == '243'
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        Get.toNamed(resultScreen,
                                            arguments: true);
                                      },
                                      child: Container(
                                        
                                        decoration: getDeco(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6),
                                                    child: Image.asset(
                                                      "assets/images/My Lottery.png",
                                                      height: 20,
                                                      color:
                                                          AppColors.iconColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "My Contest".tr,
                                                    style: TextStyle(
                                                        color: AppColors.fntClr,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: AppColors.greyColor,
                                                size: 17,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Get.toNamed(invitation);
                              //   },
                              //   child: Container(
                              //     
                              //     decoration: getDeco(),
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 16, vertical: 8),
                              //       child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Row(
                              //             children: [
                              //               Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     left: 6),
                              //                 child: Image.asset(
                              //                   "assets/images/My Invitation.png",
                              //                   color: AppColors.iconColor,
                              //                 ),
                              //               ),
                              //               const SizedBox(
                              //                 width: 10,
                              //               ),
                              //               Text(
                              //                 "Refer & Earn".tr,
                              //                 style: TextStyle(
                              //                     color: AppColors.fntClr,
                              //                     fontWeight: FontWeight.bold),
                              //               ),
                              //             ],
                              //           ),
                              //           const Icon(
                              //             Icons.arrow_forward_ios_outlined,
                              //             color: AppColors.greyColor,
                              //             size: 17,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              const SizedBox(height: 8),
                              CURR_USR == '243'
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TransactionScreen()));
                                      },
                                      child: Container(
                                        
                                        decoration: getDeco(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 6),
                                                    child: Image.asset(
                                                      "assets/images/My Transaction.png",
                                                      height: 20,
                                                      color:
                                                          AppColors.iconColor,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "My Transaction".tr,
                                                    style: TextStyle(
                                                        color: AppColors.fntClr,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: AppColors.greyColor,
                                                size: 17,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                              const SizedBox(
                                height: 8,
                              ),
                              CURR_USR == '243'
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    WithdrawalScreen(
                                                      isVerified: getProfileModel!
                                                                  .profile!
                                                                  .verified ==
                                                              "1"
                                                          ? true
                                                          : false,
                                                    )));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(left: 8),
                                        
                                        decoration: getDeco(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/Withdrawal.png",
                                                    height: 15,
                                                    color: AppColors.iconColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Withdrawal".tr,
                                                    style: TextStyle(
                                                        color: AppColors.fntClr,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: AppColors.greyColor,
                                                size: 17,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LanguageScreen(
                                          isProfile: true,
                                        ),
                                      ));
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Image.asset(
                                                "assets/icons/lang.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Change Language".tr,
                                              style: TextStyle(
                                                  color: AppColors.fntClr,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RefundAndCancellationScreen()));
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Image.asset(
                                                "assets/images/Refund and Cancellation.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*.7,
                                              child: Text(
                                                "Refund & Cancellation".tr,
                                                style: TextStyle(
                                                    color: AppColors.fntClr,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AboutUsScreen()));
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Image.asset(
                                                "assets/images/about us.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "About Us".tr,
                                              style: TextStyle(
                                                  color: AppColors.fntClr,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(privacyScreen);
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Image.asset(
                                                "assets/images/Privacy Policy.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Privacy Policy".tr,
                                              style: TextStyle(
                                                  color: AppColors.fntClr,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(termConditionScreen);
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Image.asset(
                                                "assets/images/Terms & Conditions.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width*.7,
                                              child: Text(
                                                "Terms And Condition".tr,
                                                style: TextStyle(
                                                    color: AppColors.fntClr,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(faq);
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 7),
                                              child: Image.asset(
                                                "assets/images/FAQ.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "FAQs".tr,
                                              style: TextStyle(
                                                  color: AppColors.fntClr,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactUsScreen(),
                                      ));
                                },
                                child: Container(
                                  
                                  decoration: getDeco(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Image.asset(
                                                "assets/icons/support.png",
                                                height: 20,
                                                color: AppColors.iconColor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Contact Us".tr,
                                              style: TextStyle(
                                                  color: AppColors.fntClr,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: AppColors.greyColor,
                                          size: 17,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),

                              CURR_USR == '243'
                                  ? const SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            String contentText = "";
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  content: Text(
                                                    "Are you sure you want to delete your account?"
                                                        .tr,
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text("Cancel".tr,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7)),
                                                        backgroundColor:
                                                            AppColors.buttonColor,
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.pop(context);
                                                        deleteAccount();
                                                      },
                                                      child: Text("Delete".tr,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        
                                        decoration: getDeco(),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 6),
                                                      child: Icon(
                                                        Icons.delete_forever,
                                                        color:
                                                            AppColors.iconColor,
                                                      )),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Delete Account".tr,
                                                    style: TextStyle(
                                                        color: AppColors.fntClr,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: AppColors.greyColor,
                                                size: 17,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                              const SizedBox(
                                height: 12,
                              ),

                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      String contentText = "";
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                            "Are you sure you want to Logout"
                                                .tr),
                                        content: Text(contentText),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "Cancel".tr,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              backgroundColor: AppColors.buttonColor,
                                            ),
                                            onPressed: () async {
                                              SharedPre.setValue(
                                                  SharedPre.isLogin, false);
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500));
                                              Navigator.pop(context);
                                              Get.offAllNamed(loginScreen);
                                            },
                                            child: Text(
                                              "LOGOUT".tr,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 55,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 12,
                                          offset: Offset(0, 3),
                                          color: Colors.black.withOpacity(.05))
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary,
                                      ],
                                      // Define the colors
                                      begin: Alignment.topLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "LOGOUT".tr,
                                        style: TextStyle(
                                            color: AppColors.whit,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // AppButton1(
                              //   title: "Logout",
                              //
                              // ),

                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Invite Friend',
        text: 'Invite Friend',
        linkUrl:
            'https://www.youtube.com/watch?v=jqxz7QvdWk8&list=PLjVLYmrlmjGfGLShoW0vVX_tcyT8u1Y3E',
        chooserTitle: 'Invite Friend');
  }

// Function to execute when the user confirms logout
  Widget logOut(context) {
    return AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Logout'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget textContainer(IconData icon, String title, String data) {
    return Container(
      height: 90,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.whit,
          border: Border.all(color: AppColors.iconColor),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, 0), // changes position of shadow
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            )
          ]),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.iconColor,
            size: 30,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Text(data,
                  style: const TextStyle(
                      color: AppColors.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget textFieldContainer(
      IconData icon,
      String title,
      ProfileController controller,
      TextEditingController textEditingController) {
    return Column(
      children: [
        textviewRow(title, icon),
        otherTextField(controller: textEditingController),
      ],
    );
  }

  Widget textviewRow(String title, IconData icon) {
    return Row(children: [
      Icon(
        icon,
        color: AppColors.iconColor,
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      )
    ]);
  }

  Future showOptions(BuildContext context, ProfileController controller) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              controller.getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              controller.getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
}
