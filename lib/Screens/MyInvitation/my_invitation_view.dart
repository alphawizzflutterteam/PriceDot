import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:pricedot/Constants.dart';
import 'package:pricedot/Models/referModel.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/Widgets/nodatafound.dart';
import 'package:pricedot/Widgets/shimmer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/get_invaite_model.dart';
import '../../Services/api_services/apiConstants.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;

class MyInvitation extends StatefulWidget {
  const MyInvitation({
    Key? key,
  }) : super(key: key);

  @override
  State<MyInvitation> createState() => _MyInvitationState();
}

class _MyInvitationState extends State<MyInvitation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getrefamount();
    referCode();
    //getInvatation();
  }

  bool visible = true;
  bool loding = false;
  bool isloding = false;
  String refer = '';
  List<ReferData> refers = [];

  getReferralList() async {
    try {
      refers.clear();
      var userId = await SharedPre.getStringValue('userId');
      setState(() {
        loding = true;
        visible = false;
      });
      var request = http.MultipartRequest('POST',
          Uri.parse('https://admin.drawmoney.in/Apicontroller/getReferrals'));
      print(userId);
      request.fields.addAll({'user_id': userId.toString()});
      http.StreamedResponse response = await request.send();
      var json = jsonDecode(await response.stream.bytesToString());
      print(json.toString());
      if (response.statusCode == 200) {
        ReferralModel referModel = ReferralModel.fromJson(json);
        log(json.toString());
        refers = referModel.data;
        setState(() {
          loding = false;
        });
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, st) {
      print(st);
      throw Exception(e);
    }
  }

  getrefamount() async {
    try {
      setState(() {
        isloding = true;
      });
      var request = http.Request('GET',
          Uri.parse('https://admin.drawmoney.in/Apicontroller/settings'));

      http.StreamedResponse response = await request.send();
      var json = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        setState(() {
          refer = json['data'][0]['reffer'].toString();
          isloding = false;
        });
      } else {
        setState(() {
          isloding = false;
        });
        print(response.reasonPhrase);
      }
    } catch (e, st) {
      print(st);
      throw Exception(e);
    }
  }

  void copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text)); // Copying text to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
            'Referral code copied to clipboard'), // Showing a snackbar on success
      ),
    );
  }

  String? userReferCode;
  referCode() async {
    userReferCode = await SharedPre.getStringValue('referralCode');
    setState(() {
      getInvatation();
    });
    String lang = await SharedPre.getStringValue(SharedPre.language);
    print("Lang: $lang");
    getImage(lang);
  }

  String image = '';
  getImage(String lang) {
    switch (lang) {
      case '1':
        image = "assets/images/hi.png";
        break;
      case '2':
        image = "assets/images/referWork.png";
        break;
      case '3':
        image = "assets/images/gu.png";
        break;
      default:
        image = "assets/images/referWork.png";
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpace,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        centerTitle: true,
        title: Text(
          "Refer & Earn".tr,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            // height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                        child: Image.asset("assets/images/refer.png")),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Invite Friends & Earn".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        isloding
                            ? ShimmerWidget()
                            : Text(
                                "₹${refer}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .08,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: DottedBorder(
                      radius: Radius.circular(8),
                      dashPattern: const [3, 5],
                      borderType: BorderType.RRect,
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Your Referral Code".tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  userReferCode.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Spacer(),
                            VerticalDivider(
                              color: Colors.grey.shade400,
                              thickness: 1.5,
                              indent: 5,
                              endIndent: 5,
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    new ClipboardData(text: "$userReferCode"));
                                // setSnackbar('Refercode Copied to clipboard');
                                Fluttertoast.showToast(
                                    msg: 'Refercode Copied to clipboard'.tr);
                                // Share.share("$userReferCode",
                                //     subject: 'Use my refer code');
                              },
                              child: Text(
                                "Tap to copy".tr,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Icon(
                              Icons.copy,
                              size: 20,
                            ),
                            Spacer(),
                            VerticalDivider(
                              color: Colors.grey.shade400,
                              thickness: 1.5,
                              indent: 5,
                              endIndent: 5,
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                share();
                              },
                              child: Text(
                                "Share".tr,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: Icon(
                                Icons.reply,
                                size: 20,
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    getReferralList();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        // Define the colors
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "VIEW REFERRAL LIST".tr,
                          style: TextStyle(
                            color: AppColors.whit,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [],
          ),
          Visibility(
            visible: visible,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50),
                Text(
                  "How it works".tr,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(image),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !visible,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  "Referral member & amount".tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: loding
                ? Visibility(
                    visible: !visible,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)))
                : refers.isEmpty
                    ? Visibility(
                        visible: !visible,
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox.square(
                              dimension:
                                  MediaQuery.of(context).size.height * .25,
                              child: NoDataFound()),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: refers.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                            refers[index].userName == ''
                                ? refers[index].mobile.toString()
                                : refers[index].userName.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                refers[index].insertDate.toString())),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text(
                            "₹${refers[index].amount.toString()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'Invite Friend',
      text:
          'Drawmoney\nYou can finf our app from below URL \nAndroid\n${'https://play.google.com/store/apps/details?id=com.drawmoney'}\nReferral Code : ${userReferCode}',
    );
  }

  GetInvaiteModel? myInvationModel;
  getInvatation() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=cefaa9477065503c4ca2ed67af58f3c87c6bfab4'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseUrl1/Apicontroller/apiGetInvitees'));
    request.body = json.encode({
      // "referred_by":userReferCode
      "referred_by": '2675db01c965'
    });
    print('___request.body_______${request.body}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetInvaiteModel.fromJson(json.decode(result));
      setState(() {
        myInvationModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}

class InvitationCodeGenerator {
  static String generateInvitationCode() {
    // Using the uuid package to generate a unique identifier
    final uuid = Uuid();
    return uuid.v4().substring(0, 8); // You can adjust the length as needed
  }
}
