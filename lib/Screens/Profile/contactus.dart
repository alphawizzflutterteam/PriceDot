import 'dart:convert';
import 'dart:ui';

import 'package:pricedot/Models/SettingsModel.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_transition_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/PrefUtils.dart';
import '../../Widgets/designConfig.dart';

class ContactUsScreen extends StatelessWidget {
  SettingsModel? data;
  getSettingsFromPref() async {
    try {
      String jsonString = PreferenceUtils.getString(PrefKeys.settings);
      print(jsonString);
      data = await SettingsModel.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>);
      print(data!.data.first.address);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text("Contact Us".tr,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder(
          future: getSettingsFromPref(),
          builder: (context, snap) {
            return snap.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: AppColors.secondary1.withOpacity(.1),
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox.square(
                                dimension:
                                    MediaQuery.of(context).size.height * .15,
                                child:
                                    Image.asset("assets/images/contact.png")),
                            Text(
                              "How can we help you?".tr,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "It looks like you have a problem with our systems. We are here to help you, so please get in touch with us."
                                  .tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          launchUrl(
                              Uri.parse('mailto:${data!.data.first.email1}'));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 12,
                                    offset: Offset(0, 3),
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.mail_rounded,
                                color: AppColors.iconColor,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Email".tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          launchUrl(
                              Uri.parse('tel:${data!.data.first.email1}'));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 12,
                                    offset: Offset(0, 3),
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.phone,
                                color: AppColors.iconColor,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Call Us".tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          // var whatsapp = "+919926202390";
                          var whatsappURl_android = "whatsapp://send?phone=" +
                              '+91${data!.data.first.whatsappNo}' +
                              "&text=${"Pricedot"}";
                          await launch(whatsappURl_android);
                          // if (await canLaunch(whatsappURl_android)) {
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 12,
                                    offset: Offset(0, 3),
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImageIcon(
                                AssetImage("assets/icons/whatsapp.png"),
                                size: 25,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 15),
                              Text(
                                "Connect On Whatsapp".tr,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        // margin: const EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  offset: Offset(1,1),
                                  blurRadius: 5
                              ),
                            ]
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: (){
                                launchUrl(Uri.parse('${data!.data.first.instagram}'));
                              },
                              child: Column(
                                children: [
                                  ImageIcon(AssetImage('assets/icons/instagram.png'),size: 20,color: AppColors.primary,),
                                  Text('Instagram',style: TextStyle(fontSize: 10),),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                launchUrl(Uri.parse('${data!.data.first.facebook}'));
                              },
                              child: Column(
                                children: [
                                  ImageIcon(AssetImage('assets/icons/facebook.png'),size: 20,color: AppColors.primary,),
                                  Text('Facebook',style: TextStyle(fontSize: 10),),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                launchUrl(Uri.parse('${data!.data.first.twitter}'));
                              },
                              child: Column(
                                children: [
                                  ImageIcon(AssetImage('assets/icons/twitter.png'),size: 20,color: AppColors.primary,),
                                  Text('Twitter',style: TextStyle(fontSize: 10),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
          }),
    );
  }
}
