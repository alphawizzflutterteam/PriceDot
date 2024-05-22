import 'dart:convert';

import 'package:pricedot/Screens/Bookings/my_booking_controller.dart';
import 'package:pricedot/Services/api_services/apiStrings.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:pricedot/Widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/my_lottery_model.dart';
import '../../Services/api_services/apiConstants.dart';
import 'package:http/http.dart' as http;

import '../../Widgets/auth_custom_design.dart';
import 'lottery_details.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key, this.isFrom}) : super(key: key);
  final bool? isFrom;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  String? userId;

  getUser() async {
    userId = await SharedPre.getStringValue('userId');
    getLottery();
  }

  String formatDate(String date) {
    var dateee;
    try {
      dateee = DateTime.parse(date);
    } catch (stacktrace, error) {
      dateee = DateTime.now();
    }

    String formatteddate = DateFormat('dd/MM/yyyy').format(dateee);
    return formatteddate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            )),
        title: const Text("My Coupon",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
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
          child: RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration(seconds: 2), () {
                getLottery();
              });
            },
            child: myLotteryModel == null
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: myLotteryModel!.data!.lotteries.length,
                    // itemCount:2,
                    itemBuilder: (context, index) {
                      print("Index====> $index");
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LotteryDetails(
                                          gId: myLotteryModel!
                                              .data!.lotteries[index].gameId
                                              .toString(),
                                          lotteriItems: myLotteryModel!.data!
                                              .lotteries[index].lotteryNumbers!
                                              .split(',')
                                            ..sort(),
                                          lot: myLotteryModel!
                                              .data!.lotteries[index],
                                          index: index,
                                        )));
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultDetailsScreen(gId:myLotteryModel!.data!.lotteries![index].gameId)));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: AppColors.whit,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .35,
                                            child: Text(
                                              "${myLotteryModel!.data!.lotteries[index].gameName}",
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: AppColors.primary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: const Color(0XffF8B782),
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Result:",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                Text(
                                                  formatDate(myLotteryModel!
                                                      .data!
                                                      .lotteries![index]
                                                      .resultDate
                                                      .toString()),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                Text(
                                                  " ${myLotteryModel!.data!.lotteries[index].resultTime}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(color: AppColors.greyColor),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Entry Fees: ₹ ${myLotteryModel!.data!.lotteries[index].ticketPrice}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Container(
                                            height: 45,
                                            width: 45,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  "${myLotteryModel!.data!.lotteries[index].image}",
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 34,
                                      width: double.infinity,
                                      padding: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                          color: Color(0XffE5FFF1),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: myLotteryModel!
                                                  .data!
                                                  .lotteries[index]
                                                  .resultStatus ==
                                              "1"
                                          ? Text("Result Decleared",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                          : Text(
                                              "Result not declared yet",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    }),
          )),
    );
  }

  MyLotteryModel? myLotteryModel;

  getLottery() async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=4b8b6274f26a280877c08cfedab1d6e9b46e4d2d'
    };
    var request =
        http.Request('POST', Uri.parse('$baseUrl1/Apicontroller/getLotteries'));
    request.body = json.encode({"user_id": userId});
    print('_____request.body_____${request.body}_________');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = MyLotteryModel.fromJson(jsonDecode(result));
      setState(() {
        myLotteryModel = finalResult;
      });
      // Fluttertoast.showToast(msg: "${finalResult.msg}");
    } else {
      print(response.reasonPhrase);
    }
  }
}
