import 'dart:convert';

import 'package:pricedot/Local_Storage/shared_pre.dart';
import 'package:pricedot/Screens/Kyc/add_file_card.dart';
import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pricedot/Widgets/designConfig.dart';

class KycScreen extends StatefulWidget {
  final String adf;
  final String adb;
  final String pan;

  const KycScreen(
      {super.key, required this.adf, required this.adb, required this.pan});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  String? af;
  String? ab;
  String? panf;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    print(widget.pan);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: Text("KYC Verification".tr,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .18,
              color: AppColors.secondary1.withOpacity(0.3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Verify KYC".tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "For Better Exprience".tr,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Image.asset("assets/images/kyc.png")),
                ],
              ),
            ),
            Divider(color: Colors.transparent),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Upload Aadhar Card".tr,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .15,
                child: Row(
                  children: [
                    Expanded(
                      child: DottedBorder(
                        color: Color(0xFF707070),
                        strokeWidth: 1,
                        dashPattern: const [3, 5],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        child: widget.adf == ''
                            ? AddFileCard(
                                title: 'Aadhar Card Front'.tr,
                                file: (value) {
                                  print(value.path.toString());
                                  af = value.path.toString();
                                },
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: double.maxFinite,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.adf,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                            color: AppColors.primary),
                                      ),
                                    )),
                              ),
                      ),
                    ),
                    const VerticalDivider(color: Colors.transparent),
                    Expanded(
                      child: DottedBorder(
                        color: Color(0xFF707070),
                        strokeWidth: 1,
                        dashPattern: const [3, 5],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        child: widget.adb == ''
                            ? AddFileCard(
                                title: 'Aadhar Card Back'.tr,
                                file: (value) {
                                  print(value.path.toString());
                                  ab = value.path.toString();
                                },
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: double.maxFinite,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.adb,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: CircularProgressIndicator(
                                            color: AppColors.primary),
                                      ),
                                    )),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.transparent),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Upload PAN Card",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .24,
                width: double.maxFinite,
                child: DottedBorder(
                    color: Color(0xFF707070),
                    strokeWidth: 1,
                    dashPattern: const [3, 5],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: widget.pan == ''
                        ? AddFileCard(
                            title: 'PAN Card'.tr,
                            file: (value) {
                              print(value.path.toString());
                              panf = value.path.toString();
                            },
                          )
                        : Container(
                            width: double.maxFinite,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: widget.pan,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                        color: AppColors.primary),
                                  ),
                                )),
                          )),
              ),
            ),
            const Divider(color: Colors.transparent),
            (widget.adb == '' && widget.adf == '' && widget.pan == '')
                ? Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:AppColors.buttonColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          fixedSize: Size.fromWidth(
                              MediaQuery.of(context).size.width * .85)),
                      child: isloading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "SUBMIT".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                      onPressed: () {
                        SubmitKyc(
                            aadharf: af.toString(),
                            aadharb: ab.toString(),
                            panf: panf.toString());
                      },
                    ),
                  )
                : Center(
                    child: Text(
                      "KYC pending for approval".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
            const Divider(color: Colors.transparent),
          ],
        ),
      ),
    );
  }

  Future<void> SubmitKyc({
    required String aadharf,
    required String aadharb,
    required String panf,
  }) async {
    try {
      setState(() {
        isloading = true;
      });
      var userId = await SharedPre.getStringValue('userId');
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl1/Apicontroller/upload_kyc'));
      request.fields.addAll({'user_id': userId.toString()});
      request.files.add(await http.MultipartFile.fromPath('adf', aadharf));
      request.files.add(await http.MultipartFile.fromPath('adb', aadharb));
      request.files.add(await http.MultipartFile.fromPath('pan', panf));

      http.StreamedResponse response = await request.send();
      var json = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: json['msg']);
        setState(() {
          isloading = false;
        });
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: json['msg']);
        setState(() {
          isloading = false;
        });
        print(response.reasonPhrase);
      }
    } catch (e, StackTrace) {
      print(StackTrace);
      throw Exception(e);
    }
  }
}
