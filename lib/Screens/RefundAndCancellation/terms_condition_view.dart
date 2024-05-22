import 'dart:convert';

import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pricedot/Widgets/designConfig.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Utils/Colors.dart';

class RefundAndCancellationScreen extends StatefulWidget {
  const RefundAndCancellationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RefundAndCancellationScreen> createState() =>
      _RefundAndCancellationScreenState();
}

class _RefundAndCancellationScreenState
    extends State<RefundAndCancellationScreen> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getTermsApi();
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
        title: Text("Refund And Cancellation".tr,
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
        child: termsAndCondition == null
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Html(data: "${termsAndCondition}")),
              ),
      ),
    );
  }

  String? termsAndCondition;
  getTermsApi() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=8144c3169cc147b811c9d62284d8e56afb722df6'
    };
    var request = http.Request(
        'POST', Uri.parse('$baseUrl1/Apicontroller/apiGetContent'));
    request.body = json.encode({"content": "refund_cancellation"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final jsonResponse = json.decode(result);
      setState(() {
        termsAndCondition = jsonResponse['content'][0]['name'];
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
