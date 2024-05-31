import 'dart:convert';
import 'dart:developer';

import 'package:pricedot/Constants.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pricedot/Widgets/designConfig.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/my_lottery_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../../Services/api_services/apiStrings.dart';
import '../../Utils/Colors.dart';
import 'package:http/http.dart' as http;

class Result {
  final String rank;
  final String coupon;
  final bool res;
  final String price;

  Result(this.rank, this.coupon, this.res, this.price);
}

class LotteryDetails extends StatefulWidget {
  final String gId;
  final List<String> lotteriItems;
  final Lottery lot;
  final int index;
  const LotteryDetails(
      {super.key,
      required this.gId,
      required this.lotteriItems,
      required this.index,
      required this.lot});
  @override
  State<LotteryDetails> createState() => _LotteryDetailsState();
}

class _LotteryDetailsState extends State<LotteryDetails> {
  late Future my;
  @override
  initState() {
    // TODO: implement initState
    widget.lotteriItems.forEach((element) {
      print("Length==>${element}");
    });

    super.initState();
    my = getUser();
  }

  String formatDate(String date) {
    print(date.toString() + "date from api");
    var dateee;
    try {
      dateee = DateTime.parse(date);
    } catch (stacktrace, error) {
      dateee = DateTime.now();
    }
    print(dateee);
    String formatteddate = DateFormat('dd/MM/yyyy').format(dateee);
    print(formatteddate);
    return formatteddate;
  }

  List<Result> results = [];

  bool isLoading = false;

  calResult() {
    setState(() {
      isLoading = true;
    });

    widget.lotteriItems.forEach((element2) {
      bool win = false;
      var indx =
          winner.indexWhere((element) => element.lotteryNumber == element2);
      print("indx====> ${indx}");
      var list =
          winner.where((element) => element.lotteryNumber == element2).toList();
      if (list.isNotEmpty) {
        win = true;
      }
      print(win.toString() + "Stacktravcer winner");
      try {
        results.add(Result(widget.lot.winners[indx].winPosition ?? "", element2,
            win, widget.lot.winners[indx].winnerPrice.toString()));
      } catch (stackTrace) {
        results.add(Result("", element2, false, "0"));
        print(stackTrace.toString() + "Stacktravcer");
      }
    });
    results.sort((a, b) =>
        int.parse(b.price.toString()).compareTo(int.parse(a.price.toString())));
    results.forEach((element) {
      print(
          "${element.rank}  ${element.coupon} ${element.res} ${element.price}");
    });
    setState(() {
      isLoading = false;
    });
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
        title: Text(
          "Result".tr,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: FutureBuilder(
        future: my,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColors.primary,
                ))
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        color: AppColors.secondary1.withOpacity(.2),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Text(
                              widget.lot.gameName.toString(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Entry Fees".tr,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "₹${widget.lot.ticketPrice.toString()}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      color: AppColors.bgColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: Text(
                              "Rank".tr,
                              style: TextStyle(
                                  color: AppColors.fontColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: Text(
                              "Coupon No.".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.fontColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: Text(
                              "Result".tr,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: AppColors.fontColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: ListView.builder(
                          itemCount: results.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              color: index % 2 != 0
                                  ? AppColors.bgColor
                                  : Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  !results[index].res
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                        )
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .3,
                                          child: Text(
                                            "${results[index].rank}",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .3,
                                    child: Text(
                                      "${results[index].coupon}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Spacer(),
                                  if (results[index].res &&
                                      widget.lot.resultStatus != '0')
                                    Image.asset(
                                      "assets/images/winner1.png",
                                      scale: 1.2,
                                    ),
                                  SizedBox(width: 5),
                                  widget.lot.resultStatus == '0'
                                      ? Text("Waiting...".tr)
                                      : !results[index].res
                                          ? Text("Looser",
                                              style: const TextStyle(
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold))
                                          : SizedBox(
                                    width:MediaQuery.of(context).size.width*.23,
                                            child: Text(
                                               (numericRegex.hasMatch("${results[index].price}")?"₹":"") +'${results[index].price}',
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                    color: AppColors.fntClr,
                                                    fontWeight: FontWeight.bold),

                                              ),
                                          ),
                                ],
                              ),
                            );
                          }),
                    )),
                  ],
                );
          //       : Container(
          //           child: ListView.builder(
          //               itemCount: widget.lotteriItems.length,
          //               itemBuilder: (context, i) {

          //                 return Padding(
          //                   padding: const EdgeInsets.symmetric(
          //                       horizontal: 8, vertical: 16),
          //                   child: Card(
          //                     shape: RoundedRectangleBorder(
          //                         borderRadius: BorderRadius.circular(10)),
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                           color: AppColors.whit,
          //                           borderRadius: BorderRadius.circular(10)),
          //                       child: Column(
          //                         children: [
          //                           Padding(
          //                             padding: const EdgeInsets.only(
          //                                 left: 10, right: 10, top: 10),
          //                             child: Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 SizedBox(
          //                                   width: MediaQuery.of(context)
          //                                           .size
          //                                           .width *
          //                                       .35,
          //                                   child: Text(
          //                                     "${widget.lot.gameName}",
          //                                     maxLines: 2,
          //                                     textAlign: TextAlign.center,
          //                                     overflow: TextOverflow.ellipsis,
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .bodyMedium!
          //                                         .copyWith(
          //                                             color: Color(0Xff171717),
          //                                             fontSize: 14,
          //                                             fontWeight:
          //                                                 FontWeight.bold),
          //                                   ),
          //                                 ),
          //                                 Container(
          //                                   padding: const EdgeInsets.symmetric(
          //                                       horizontal: 5, vertical: 5),
          //                                   decoration: BoxDecoration(
          //                                       color: const Color(0XffF8B782),
          //                                       borderRadius:
          //                                           BorderRadius.circular(7)),
          //                                   child: Row(
          //                                     children: [
          //                                       Text(
          //                                         "Result:",
          //                                         style: Theme.of(context)
          //                                             .textTheme
          //                                             .bodyMedium!
          //                                             .copyWith(
          //                                                 fontSize: 12,
          //                                                 fontWeight:
          //                                                     FontWeight.w400),
          //                                       ),
          //                                       Text(
          //                                         formatDate(widget
          //                                             .lot.resultDate
          //                                             .toString()),
          //                                         style: Theme.of(context)
          //                                             .textTheme
          //                                             .bodyMedium!
          //                                             .copyWith(
          //                                                 fontSize: 12,
          //                                                 fontWeight:
          //                                                     FontWeight.w400),
          //                                       ),
          //                                       Text(
          //                                         " ${widget.lot.resultTime}",
          //                                         style: Theme.of(context)
          //                                             .textTheme
          //                                             .bodyMedium!
          //                                             .copyWith(
          //                                                 fontSize: 12,
          //                                                 fontWeight:
          //                                                     FontWeight.w400),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 )
          //                               ],
          //                             ),
          //                           ),

          //                           // Padding(
          //                           //   padding: const EdgeInsets.only(
          //                           //       left: 5, right: 5, top: 10),
          //                           //   child: Row(
          //                           //     mainAxisAlignment:
          //                           //         MainAxisAlignment.spaceBetween,
          //                           //     children: [
          //                           //       Row(
          //                           //         children: [
          //                           //           Text(
          //                           //             "Result Date :",
          //                           //             style: TextStyle(
          //                           //                 color: AppColors.fntClr,
          //                           //                 fontSize: 12),
          //                           //           ),
          //                           //           SizedBox(
          //                           //             width: 2,
          //                           //           ),
          //                           //           Text(
          //                           //             "${DateFormat('dd-MM-yyyy').format(DateTime.parse('${getResultModel!.data!.lotteries![index].resultDate} 00:00:00'))}",
          //                           //             style: TextStyle(
          //                           //                 color: AppColors.fntClr,
          //                           //                 fontSize: 12),
          //                           //           )
          //                           //         ],
          //                           //       ),
          //                           //       Row(
          //                           //         children: [
          //                           //           SizedBox(
          //                           //             height: 12,
          //                           //           ),
          //                           //           Text(
          //                           //             "Result Time:",
          //                           //             style: TextStyle(
          //                           //                 color: AppColors.fntClr,
          //                           //                 fontSize: 12),
          //                           //           ),
          //                           //           SizedBox(
          //                           //             width: 2,
          //                           //           ),
          //                           //           Text(
          //                           //             "${getResultModel!.data!.lotteries![index].resultTime}",
          //                           //             style: TextStyle(
          //                           //                 color: AppColors.fntClr,
          //                           //                 fontSize: 12),
          //                           //           )
          //                           //         ],
          //                           //       ),
          //                           //     ],
          //                           //   ),
          //                           // ),
          //                           Divider(color: AppColors.subTxtClr),
          //                           Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Text(
          //                                     "Win Price : ${indx == -1 ? "0" : widget.lot.winners[indx].winnerPrice}",
          //                                     style: TextStyle(
          //                                         color: AppColors.fntClr
          //                                             .withOpacity(0.7),
          //                                         fontSize: 16,
          //                                         fontWeight: FontWeight.w700)),
          //                                 Container(
          //                                   height: 45,
          //                                   width: 50,
          //                                   child: ClipRRect(
          //                                       borderRadius:
          //                                           BorderRadius.circular(10),
          //                                       child: Image.network(
          //                                         "${widget.lot.image}",
          //                                         fit: BoxFit.fill,
          //                                       )),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),

          //                           Container(
          //                             height: 34,
          //                             width: double.infinity,
          //                             padding: const EdgeInsets.symmetric(
          //                                 horizontal: 8),
          //                             decoration: BoxDecoration(
          //                                 color: Color(0XffF9B5B5)
          //                                     .withOpacity(0.3),
          //                                 borderRadius: BorderRadius.only(
          //                                     bottomLeft: Radius.circular(10),
          //                                     bottomRight:
          //                                         Radius.circular(10))),
          //                             child: Row(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.center,
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Text(
          //                                     "Coupon Number: ${widget.lotteriItems[i]}",
          //                                     style: TextStyle(
          //                                         color: AppColors.fntClr
          //                                             .withOpacity(0.7),
          //                                         fontSize: 14,
          //                                         fontWeight: FontWeight.w500)),
          //                                 widget.lot.resultStatus == '0'
          //                                     ? Text("Wait For the result...!",
          //                                         style: TextStyle(
          //                                             color: Colors.grey,
          //                                             fontSize: 12,
          //                                             fontWeight:
          //                                                 FontWeight.w500))
          //                                     : win
          //                                         ? Center(
          //                                             child: widget.lot.winners
          //                                                     .isNotEmpty
          //                                                 ? Text(
          //                                                     indx == -1
          //                                                         ? ""
          //                                                         : "Win Position : ${widget.lot.winners[indx].winPosition}",
          //                                                     style: TextStyle(
          //                                                         color: Colors
          //                                                             .green,
          //                                                         fontSize: 12,
          //                                                         fontWeight:
          //                                                             FontWeight
          //                                                                 .w500))
          //                                                 : SizedBox.shrink(),
          //                                           )
          //                                         : Center(
          //                                             child: Text(
          //                                               "Looser",
          //                                               style: TextStyle(
          //                                                   color: Colors.red,
          //                                                   fontSize: 12,
          //                                                   fontWeight:
          //                                                       FontWeight
          //                                                           .w500),
          //                                             ),
          //                                           )
          //                               ],
          //                             ),
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 );
          //                 //   return Padding(
          //                 //     padding: const EdgeInsets.symmetric(
          //                 //         horizontal: 8, vertical: 16),
          //                 //     child: Card(
          //                 //         child: Column(
          //                 //       children: [
          //                 //         Container(
          //                 //           height: 30,
          //                 //           decoration: BoxDecoration(
          //                 //             borderRadius: BorderRadius.only(
          //                 //                 topLeft: Radius.circular(8),
          //                 //                 topRight: Radius.circular(8)),
          //                 //             color: AppColors.secondary,
          //                 //           ),
          //                 //           child: Padding(
          //                 //             padding: const EdgeInsets.only(
          //                 //                 left: 5, right: 5),
          //                 //             child: Row(
          //                 //               mainAxisAlignment:
          //                 //                   MainAxisAlignment.spaceBetween,
          //                 //               children: [
          //                 //                 Row(
          //                 //                   children: [
          //                 //                     const Text(
          //                 //                       "Result Date :",
          //                 //                       style: TextStyle(
          //                 //                           color: AppColors.whit,
          //                 //                           fontSize: 12),
          //                 //                     ),
          //                 //                     const SizedBox(
          //                 //                       width: 2,
          //                 //                     ),
          //                 //                     Text(
          //                 //                       '${DateFormat('dd-MM-yyyy').format(DateTime.parse('${widget.lot.resultDate} 00:00:00'))}',
          //                 //                       style: TextStyle(
          //                 //                           color: AppColors.whit,
          //                 //                           fontSize: 12),
          //                 //                     )
          //                 //                   ],
          //                 //                 ),
          //                 //                 Row(
          //                 //                   children: [
          //                 //                     SizedBox(
          //                 //                       height: 25,
          //                 //                     ),
          //                 //                     Text(
          //                 //                       "Result Time:",
          //                 //                       style: TextStyle(
          //                 //                           color: AppColors.whit,
          //                 //                           fontSize: 12),
          //                 //                     ),
          //                 //                     SizedBox(
          //                 //                       width: 2,
          //                 //                     ),
          //                 //                     widget.lot.resultTime == null
          //                 //                         ? Text("")
          //                 //                         : Text(
          //                 //                             "${widget.lot.resultTime}",
          //                 //                             style: TextStyle(
          //                 //                                 color: AppColors
          //                 //                                     .whit,
          //                 //                                 fontSize: 12),
          //                 //                           )
          //                 //                   ],
          //                 //                 ),
          //                 //               ],
          //                 //             ),
          //                 //           ),
          //                 //         ),
          //                 //         Padding(
          //                 //           padding: const EdgeInsets.all(8.0),
          //                 //           child: Row(
          //                 //             mainAxisAlignment:
          //                 //                 MainAxisAlignment.spaceBetween,
          //                 //             children: [
          //                 //               Column(
          //                 //                 crossAxisAlignment:
          //                 //                     CrossAxisAlignment.start,
          //                 //                 children: [
          //                 //                   Text("${widget.lot.gameName}",
          //                 //                       style: TextStyle(
          //                 //                           color: AppColors.fntClr
          //                 //                               .withOpacity(0.7),
          //                 //                           fontSize: 12,
          //                 //                           fontWeight:
          //                 //                               FontWeight.w500)),
          //                 //                   const SizedBox(
          //                 //                     height: 3,
          //                 //                   ),
          //                 // Text(
          //                 //     "Price : ${widget.lot.ticketPrice}",
          //                 //     style: TextStyle(
          //                 //         color: AppColors.fntClr
          //                 //             .withOpacity(0.7),
          //                 //         fontSize: 12,
          //                 //         fontWeight:
          //                 //             FontWeight.w500)),
          //                 //                   const SizedBox(
          //                 //                     height: 3,
          //                 //                   ),
          //                 // Text(
          //                 //     "Coupon Number: ${widget.lotteriItems[i]}",
          //                 //     style: TextStyle(
          //                 //         color: AppColors.fntClr
          //                 //             .withOpacity(0.7),
          //                 //         fontSize: 16,
          //                 //         fontWeight:
          //                 //             FontWeight.w700)),
          //                 //                   const SizedBox(
          //                 //                     height: 5,
          //                 //                   ),
          //                 //     widget.lot.resultStatus == '0'
          //                 //         ? Text(
          //                 //             "Wait For the result...!",
          //                 //             style: TextStyle(
          //                 //                 color: Colors.grey,
          //                 //                 fontSize: 12,
          //                 //                 fontWeight:
          //                 //                     FontWeight
          //                 //                         .w500))
          //                 //         : Column(
          //                 //             children: [
          //                 //               win
          //                 //                   ? Text("Winner",
          //                 //                       style: TextStyle(
          //                 //                           color: Colors
          //                 //                               .green,
          //                 //                           fontSize:
          //                 //                               12,
          //                 //                           fontWeight:
          //                 //                               FontWeight
          //                 //                                   .w500))
          //                 //                   : Text(
          //                 //                       "Looser",
          //                 //                       style: TextStyle(
          //                 //                           color: Colors
          //                 //                               .red,
          //                 //                           fontSize:
          //                 //                               12,
          //                 //                           fontWeight:
          //                 //                               FontWeight
          //                 //                                   .w500),
          //                 //                     )
          //                 //             ],
          //                 //           )
          //                 //   ],
          //                 // ),
          //                 //               SizedBox(
          //                 //                 height: 45,
          //                 //                 width: 50,
          //                 //                 child: ClipRRect(
          //                 //                     borderRadius:
          //                 //                         BorderRadius.circular(10),
          //                 //                     child: Image.network(
          //                 //                       "${widget.lot.image}",
          //                 //                       fit: BoxFit.fill,
          //                 //                     )),
          //                 //               ),
          //                 //             ],
          //                 //           ),
          //                 //         ),
          //                 //       ],
          //                 //     )),
          //                 //   );
          //               }),
          //         );
        },
      ),
    );
  }

  String? Name;

  String? userId;
  getUser() async {
    userId = await SharedPre.getStringValue('userId');
    print("username: $userId");
    await getLottery();
  }

  List<Winner> winner = [];

  getLottery() async {
    try {
      var request = http.Request(
          'POST', Uri.parse('$baseUrl1/Apicontroller/getLotteries'));
      request.body = json.encode({"game_id": widget.gId, "user_id": userId});

      print('${request.body}');
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        log('${result}__________');
        var finalResult = MyLotteryModel.fromJson(jsonDecode(result));

        winner = finalResult.data!.lotteries[widget.index].winners;

        calResult();
        // Fluttertoast.showToast(msg: "${finalResult.msg}");
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      throw Exception(e);
    }
  }
}
