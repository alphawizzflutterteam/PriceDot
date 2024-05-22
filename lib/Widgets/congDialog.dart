import 'package:pricedot/Local_Storage/shared_pre.dart';
import 'package:pricedot/Screens/Dashboard/dashboard_view.dart';
import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class YourWidget extends StatefulWidget {
  final String gId;
  final String amount;
  final String val;

  const YourWidget(
      {super.key, required this.gId, required this.amount, required this.val});

  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    payWallet(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Future<void> payWallet(BuildContext ctx) async {
    var user_id = await SharedPre.getStringValue('userId');
    var request = http.Request(
        'POST', Uri.parse('$baseUrl1/Apicontroller/buyLotterybywallet'));
    request.body = json.encode({
      "user_id": user_id,
      "game_id": widget.gId,
      "amount": widget.amount,
      "lottery_numbers": widget.amount,
      "order_number": "2675db01c965",
      "txn_id": "2675db01c965ijbdhgd"
    });
    print('${request.body}___________');

    setState(() {
      _isLoading = true;
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(result);
      print(jsonResponse.toString());

      if (jsonResponse['status'] == false) {
        Fluttertoast.showToast(msg: "${jsonResponse['msg']}");
        Navigator.pop(context);
      } else {
        await SharedPre.setValue('drawNo', "");
        await SharedPre.setValue('orderId', "");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (c) {
              Future.delayed(const Duration(seconds: 3)).then((value) {
                Navigator.pop(c);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashBoardScreen(),
                    ),
                    (route) => false);
              });
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: AppColors.bgColor),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 150,
                      child: Stack(
                        children: [
                          Lottie.asset('assets/images/confetti.json'),
                          if (_isLoading) // Show loader only if _isLoading is true
                            Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary),
                            ),
                          Center(
                            child: Builder(builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox.square(
                                      dimension:
                                          MediaQuery.of(context).size.height *
                                              .07,
                                      child: Image.asset(
                                          "assets/icons/confetti.png")),
                                  Image.asset("assets/icons/congo.png"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Your Coupon No. ",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        widget.val,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      }
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
