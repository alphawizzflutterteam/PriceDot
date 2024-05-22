import 'dart:convert';

import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../Services/api_services/apiConstants.dart';
import '../../Services/api_services/apiStrings.dart';
import '../../Utils/Colors.dart';
import 'package:http/http.dart' as http;

import '../../Widgets/designConfig.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getPrivacy();
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
        title: Text("Privacy Policy".tr,
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xfff6f6f6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            // Top-left corner radius
            topRight: Radius.circular(30),
            // Top-right corner radius
          ),
        ),
        child: privacyPolicy == null
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Html(data: "${privacyPolicy}")),
              ),
      ),
    );
  }

  String? privacyPolicy;

  getPrivacy() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=8144c3169cc147b811c9d62284d8e56afb722df6'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseUrl1/Apicontroller/apiGetContent'));
    request.body = json.encode({"content": "privacy_policy"});
    print('_____request.body_____${request.body}_________');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final jsonResponse = json.decode(result);
      setState(() {
        privacyPolicy = jsonResponse['content'][0]['name'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
