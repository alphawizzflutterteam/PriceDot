import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_transition_mixin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widgets/designConfig.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
      body: Column(
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
                    dimension: MediaQuery.of(context).size.height * .15,
                    child: Image.asset("assets/images/contact.png")),
                Text(
                  "How can we help you?".tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              launchUrl(Uri.parse('mailto:contact@drawmoney.in'));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 3),
                    color: Colors.black.withOpacity(.05))
              ], color: Colors.white, borderRadius: BorderRadius.circular(7)),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              launchUrl(Uri.parse('tel:9876543210'));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 3),
                    color: Colors.black.withOpacity(.05))
              ], color: Colors.white, borderRadius: BorderRadius.circular(7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.phone,
                    color: AppColors.iconColor,
                  ),
                  SizedBox(width: 15),
                  Text(
                    "+91 9876543210",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            onTap: ()async {
              // var whatsapp = "+919926202390";
              var whatsappURl_android = "whatsapp://send?phone=" +'+919876543210' +
                  "&text=${"Pricedot"}";
              await launch(whatsappURl_android);
              // if (await canLaunch(whatsappURl_android)) {

            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 3),
                    color: Colors.black.withOpacity(.05))
              ], color: Colors.white, borderRadius: BorderRadius.circular(7)),
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
                    "Whatsapp",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        ],
      ),
    );
  }
}
