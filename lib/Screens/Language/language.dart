import 'package:pricedot/Local_Storage/shared_pre.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Utils/session.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Colors.dart';

class LanguageScreen extends StatefulWidget {
  final bool isProfile;

  const LanguageScreen({super.key, required this.isProfile});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedLang = "2";
  getlang() async {
    selectedLang = await SharedPre.getStringValue(SharedPre.language) ?? "2";
    print(selectedLang);
    setState(() {});
  }

  @override
  void initState() {
    widget.isProfile ? getlang() : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:FlexibleSpace,

        leading: widget.isProfile
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                ))
            : null,
        title: Text(
          "Choose your language".tr,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.greyColor.withOpacity(.1),
                    AppColors.greyColor.withOpacity(.5),
                  ]),
                  borderRadius: BorderRadius.circular(12)),
              width: double.infinity,
              child: DottedBorder(
                color: AppColors.primary,
                strokeWidth: 1,
                dashPattern: const [3, 5],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        "हिन्दी",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Spacer(),
                      Checkbox(
                        activeColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        value: selectedLang == '1' ? true : false,
                        onChanged: (val) {
                          setState(() {
                            selectedLang = '1';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.transparent),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                  AppColors.greyColor.withOpacity(.1),
                  AppColors.greyColor.withOpacity(.5),
                  ]),
                  borderRadius: BorderRadius.circular(12)),
              width: double.infinity,
              child: DottedBorder(
                color: AppColors.primary,
                strokeWidth: 1,
                dashPattern: const [3, 5],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        "English",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Spacer(),
                      Checkbox(
                        activeColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        value: selectedLang == '2' ? true : false,
                        onChanged: (val) {
                          setState(() {
                            selectedLang = '2';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.transparent),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.greyColor.withOpacity(.1),
                    AppColors.greyColor.withOpacity(.5),
                  ]),
                  borderRadius: BorderRadius.circular(12)),
              width: double.infinity,
              child: DottedBorder(
                color: AppColors.primary,
                strokeWidth: 1,
                dashPattern: const [3, 5],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        "தமிழ்",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Spacer(),
                      Checkbox(
                        activeColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        value: selectedLang == '3' ? true : false,
                        onChanged: (val) {
                          setState(() {
                            selectedLang = '3';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.transparent),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.greyColor.withOpacity(.1),
                    AppColors.greyColor.withOpacity(.5),
                  ]),
                  borderRadius: BorderRadius.circular(12)),
              width: double.infinity,
              child: DottedBorder(
                color: AppColors.primary,
                strokeWidth: 1,
                dashPattern: const [3, 5],
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        "డెల్గు",
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      Spacer(),
                      Checkbox(
                        activeColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        value: selectedLang == '4' ? true : false,
                        onChanged: (val) {
                          setState(() {
                            selectedLang = '4';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () async {
                  switch (selectedLang) {
                    case '1':
                      Get.updateLocale(Locale('hi', 'IN'));
                      break;
                    case '2':
                      Get.updateLocale(Locale('en', 'US'));
                      break;
                    case '3':
                      Get.updateLocale(Locale('ta', 'IN'));
                      break;
                    case '4':
                      Get.updateLocale(Locale('te', 'IN'));
                      break;
                    default:
                      Get.updateLocale(Locale('en', 'US'));
                      break;
                  }
                  print(selectedLang);
                  await SharedPre.setValue(SharedPre.language, selectedLang);
                  String n = await SharedPre.getStringValue(SharedPre.language);
                  print(n + "...........");
                  widget.isProfile
                      ? Navigator.pop(context)
                      : Get.toNamed(loginScreen);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    fixedSize: Size(double.maxFinite, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: Text(
                  widget.isProfile ? "SELECT".tr : "CONTINUE".tr,
                  style: TextStyle(color: Colors.white),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            )
          ],
        ),
      ),
    );
  }
}
