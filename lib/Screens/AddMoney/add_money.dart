import 'dart:convert';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Services/api_services/apiConstants.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/Widgets/shimmer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

import '../../Local_Storage/shared_pre.dart';
import 'package:http/http.dart' as http;

class AddMoney extends StatefulWidget {
  const AddMoney({
    Key? key,
  }) : super(key: key);

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    balanceUser();
  }

  bool _isLoading = false;
  String? userBalance, userId;
  balanceUser() async {
    userBalance = await SharedPre.getStringValue('balanceUser');
    userId = await SharedPre.getStringValue('userId');
    setState(() {
      getWalletBallace();
    });
  }

  String wallet = '';
  getWalletBallace() async {
    setState(() {
      _isLoading = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=dc01298267f1df677d56b79b00289958a862e530'
    };
    var request = http.Request('POST',
        Uri.parse('${baseUrl}/Apicontroller/getWalletBalance'));
    request.body = json.encode({"user_id": userId});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      setState(() {
        wallet = finalResult['wallet_balance'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        title: Text("Add Cash".tr,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .2,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.greyColor.withOpacity(.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width:MediaQuery.of(context).size.width*.65,
                  child: Text(
                    "Add Money to wallet".tr,
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Fugazone',
                        color: AppColors.buttonColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height*.1,
                      child: Image.asset("assets/images/addCash.png")),
                ),
              ],
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                // color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  // Top-left corner radius
                  topRight: Radius.circular(30),
                  // Top-right corner radius
                ),
              ),
              child: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 2), () {
                    //  getLottery();
                  });
                },
                child: SingleChildScrollView(
                    child: Column(
                  children: [showContent()],
                )),
              )),
        ],
      ),
    );
  }

  StateSetter? dialogState;
  final _formKey = GlobalKey<FormState>();
  TextEditingController amtC = TextEditingController();
  TextEditingController msgC = TextEditingController();
  ScrollController controller = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  showContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Total Balance'.tr,
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.fntClr,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: _isLoading
                  ? ShimmerWidget(
                      color: Colors.grey.shade300,
                    )
                  : Text(
                      "₹ ${wallet}",
                      style: TextStyle(
                          fontSize: 22,
                          color: AppColors.fntClr,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    gradient: LinearGradient(
                        colors: [

                          AppColors.primary,
                          AppColors.secondary,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dctx) => _showDialog(dctx),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    child: Text(
                      "ADD MONEY".tr,
                      style: TextStyle(
                          fontFamily: 'Gilroy',
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            // AppButton1(
            //   onTap: () {
            //     _showDialog();
            //   },
            //   title: "Add Money",
            // )
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext ctx) {
    bool payWarn = false;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
              child: Text(
                "ADD MONEY".tr,
                style: TextStyle(color: AppColors.fntClr),
              ),
            ),
            // Divider(color: Theme.of(context).colorScheme.lightBlack),
            Form(
              key: _formKey,
              child: Flexible(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                          child: TextFormField(
                            maxLength: 8,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter amount".tr;
                              }
                              return null;
                            },
                            style: const TextStyle(
                              color: AppColors.fntClr,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Enter Amount'.tr,
                              hintStyle: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.normal),
                            ),
                            controller: amtC,
                          )),
                      // Padding(
                      //     padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      //     child: TextFormField(
                      //       autovalidateMode:
                      //           AutovalidateMode.onUserInteraction,
                      //       style: const TextStyle(
                      //         color: AppColors.activeBorder,
                      //       ),
                      //       decoration: InputDecoration(
                      //         hintText: "Message".tr,
                      //         hintStyle: TextStyle(
                      //             color: AppColors.primary,
                      //             fontWeight: FontWeight.normal),
                      //       ),
                      //       controller: msgC,
                      //     )),
                      //Divider(),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 5),
                      //   child: Text(
                      //     "Select Payment Method",
                      //     style: Theme.of(context).textTheme.subtitle2,
                      //   ),
                      // ),
                      Divider(),
                    ])),
              ),
            )
          ]),
      actions: <Widget>[
        TextButton(
            child: Text(
              'Cancel'.tr,
              style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                  color: AppColors.fntClr, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(ctx);
            }),
        TextButton(
            child: Text(
              'Send'.tr,
              style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                  color: AppColors.fntClr, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
             addMoney().then((value) => Navigator.pop(ctx));
              }
              //  openCheckout(amtC.text);
            })
      ],
    );
  }

  Future<void> addMoney()async{
    try{

      var request = http.MultipartRequest('POST', Uri.parse('${baseUrl}Apicontroller/apiAddMoneyViaUpi'));
      request.fields.addAll({
        'user_id': CURR_USR.toString(),
        'amount': amtC.text,
        'txn_id': DateTime.now().millisecondsSinceEpoch.toString()
      });
      http.StreamedResponse response = await request.send();
     var json=jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200&& json['status']) {
        balanceUser();
        Fluttertoast.showToast(msg: json['msg']);
      }
      else {
        Fluttertoast.showToast(msg: json['msg']);
        print(response.reasonPhrase);
      }

    }catch(e){
      throw Exception(e);
    }
  }

  dialogAnimate(BuildContext context, Widget dialge) {
    return showGeneralDialog(
        barrierColor: AppColors.fntClr,
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: dialge),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        // pageBuilder: null
        pageBuilder: (context, animation1, animation2) {
          return Container();
        } //as Widget Function(BuildContext, Animation<double>, Animation<double>)
        );
  }
}
