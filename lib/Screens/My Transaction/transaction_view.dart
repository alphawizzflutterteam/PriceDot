import 'dart:convert';

import 'package:pricedot/Models/TransactionModel.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/Widgets/nodatafound.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/Get_transaction_model.dart';
import '../../Services/api_services/apiConstants.dart';
import 'package:http/http.dart' as http;

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key, this.isFrom, this.gId}) : super(key: key);
  final bool? isFrom;
  String? gId;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  late Future my;
  void initState() {
    super.initState();
    getUser();
    my = get();
  }

  int selectedFilter = -1;
  List<TransactionData> filterList = [];
  void filterData({required String value}) {
    filterList.clear();
    if (value == '1' || value == '2') {
      data.forEach((element) {
        print("objectId : ${element.transactionType}");
        if (element.transactionType.toString() == value) {
          filterList.add(element);
        }
      });
    }
    if (value == '5') {
      DateTime lastWeekDate =DateTime.now();
      data.forEach((element) {

        DateTime dateOnly = DateTime.parse(element.insertDate.toString());
        print("objectId : ${dateOnly.subtract(Duration(hours: dateOnly.hour,minutes: dateOnly.minute,seconds: dateOnly.second))} ${lastWeekDate}");
        if (dateOnly.subtract(Duration(hours: dateOnly.hour,minutes: dateOnly.minute,seconds: dateOnly.second))
            .isAtSameMomentAs(lastWeekDate)) {
          filterList.add(element);
        }
      });
    }
    if (value == '3') {
      DateTime lastWeekDate = DateTime.now().subtract(Duration(days: 7));
      data.forEach((element) {
        print("objectId : ${element.insertDate}");
        if (DateTime.parse(element.insertDate.toString())
            .isAfter(lastWeekDate)) {
          filterList.add(element);
        }
      });
    }
    if (value == '4') {
      DateTime lastWeekDate = DateTime.now().subtract(Duration(days: 30));
      data.forEach((element) {
        print("objectId : ${element.insertDate}");
        if (DateTime.parse(element.insertDate.toString())
            .isAfter(lastWeekDate)) {
          filterList.add(element);
        }
      });
    }

    setState(() {});
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
          title: Text("My Transaction".tr,
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
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.whit,
            onRefresh: () async {
              return Future.delayed(Duration(seconds: 3))
                  .then((value) => get());
            },
            child: FutureBuilder(
                future: my,
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary))
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: data.length == 0
                            ? Center(
                                child:NoDataFound()
                              )
                            : Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(Icons.filter_alt_rounded),
                                      VerticalDivider(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .66,
                                        height: 35,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                selectedFilter = 0;
                                                filterData(value: "2");
                                              },
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  child: Text(
                                                    "Credit",
                                                    style: TextStyle(
                                                        color:
                                                            selectedFilter == 0
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: selectedFilter == 0
                                                        ? AppColors.primary
                                                        : Colors.white,
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                selectedFilter = 1;
                                                filterData(value: "1");
                                              },
                                              child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  child: Text(
                                                    "Debit",
                                                    style: TextStyle(
                                                        color:
                                                            selectedFilter == 1
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: selectedFilter == 1
                                                        ? AppColors.primary
                                                        : Colors.white,
                                                  )),
                                            ),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     selectedFilter = 5;
                                            //     filterData(value: "5");
                                            //   },
                                            //   child: Container(
                                            //       margin: const EdgeInsets.only(
                                            //           right: 5),
                                            //       padding: const EdgeInsets
                                            //           .symmetric(
                                            //           horizontal: 16,
                                            //           vertical: 8),
                                            //       child: Text(
                                            //         "Today",
                                            //         style: TextStyle(
                                            //             color:
                                            //                 selectedFilter == 5
                                            //                     ? Colors.white
                                            //                     : Colors.black),
                                            //       ),
                                            //       decoration: BoxDecoration(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 20),
                                            //         color: selectedFilter == 5
                                            //             ? AppColors.primary
                                            //             : Colors.white,
                                            //       )),
                                            // ),
                                            GestureDetector(
                                              onTap: () {
                                                selectedFilter = 2;
                                                filterData(value: "3");
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: Text(
                                                    "Weekly",
                                                    style: TextStyle(
                                                        color:
                                                            selectedFilter == 2
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: selectedFilter == 2
                                                        ? AppColors.primary
                                                        : Colors.white,
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                selectedFilter = 3;
                                                filterData(value: "4");
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  child: Text(
                                                    "Monthly",
                                                    style: TextStyle(
                                                        color:
                                                            selectedFilter == 3
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: selectedFilter == 3
                                                        ? AppColors.primary
                                                        : Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            filterList.clear();
                                            filterList.addAll(data);
                                            selectedFilter = -1;
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.cancel_rounded)),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height * .8,
                                    child: filterList.length == 0
                                        ? Center(
                                            child: NoDataFound()
                                          )
                                        : ListView.builder(
                                            itemCount: filterList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                Container(
                                              padding: const EdgeInsets.all(8),
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(7)),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 16),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                        color:
                                                            AppColors.bgColor),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          DateFormat('d MMM')
                                                              .format(
                                                            DateTime.parse(
                                                              filterList[index]
                                                                  .insertDate
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          DateFormat('hh:mm a')
                                                              .format(
                                                            DateTime.parse(
                                                              filterList[index]
                                                                  .insertDate
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .4,
                                                        child: Text(
                                                          filterList[index]
                                                              .transactionNote
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Text("Id:" +
                                                          filterList[index]
                                                              .txnId
                                                              .toString()),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "${filterList[index].transactionType == '1' ? '-' : '+'}₹${filterList[index].amount}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: filterList[index]
                                                                  .transactionType ==
                                                              '1'
                                                          ? Colors.red
                                                          : Colors.green,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                      )),
          ),
        ));
  }

  Widget getStatus(String status) {
    switch (status) {
      case '0':
        return Row(
          children: [
            Icon(
              Icons.replay_outlined,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              "Pending",
              style: TextStyle(color: Colors.black),
            )
          ],
        );
      case '2':
        return Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
            ),
            SizedBox(width: 5),
            Text(
              "Accepted",
              style: TextStyle(color: Colors.green),
            )
          ],
        );
      case '1':
        return Row(
          children: [
            Icon(
              Icons.close,
              color: Colors.red,
            ),
            SizedBox(width: 5),
            Text(
              "Declined",
              style: TextStyle(color: Colors.red),
            )
          ],
        );

      default:
        return Row(
          children: [
            Icon(
              Icons.replay_outlined,
              color: Colors.black,
            ),
            SizedBox(width: 5),
            Text(
              "Pending",
              style: TextStyle(color: Colors.black),
            )
          ],
        );
    }
  }

  String? userId;
  MyTransactionModel? TransactionModel;
  List<TransactionData> data = [];
  get() async {
    try {
      data.clear();
      userId = await SharedPre.getStringValue('userId');
      print(userId);
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              '${baseUrl}/Apicontroller/get_transactions'));
      request.fields.addAll({'user_id': userId.toString()});

      http.StreamedResponse response = await request.send();
      var json = jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        TransactionModel = MyTransactionModel.fromJson(json);
        data = TransactionModel!.data;
        filterList.clear();
        data.forEach((element) {
          if(element.amount!='0'){
            filterList.add(element);
          }
        });

        setState(() {});
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, st) {
      print(st);
      throw Exception(e);
    }
  }

  // String? userId;
  getUser() async {
    userId = await SharedPre.getStringValue('userId');
    // getTransactionApi();
    // get();
  }

  // Future<void> getTransactionApi() async {
  //   // isLoading.value = true;
  //   var param = {
  //     'user_id':userId
  //   };
  //   print('__________${param}_________');
  //   apiBaseHelper.postAPICall(getTransactionHistoryAPI, param).then((getData) {
  //     print('____getData______${getData}_________');
  //     String msg = getData['msg'];
  //     getTransactionModel = GetTransactionModel.fromJson(getData);
  //     setState(() {
  //
  //     });
  //     Fluttertoast.showToast(msg: msg);
  //     //isLoading.value = false;
  //   });
  // }

//   String ?userId;
//   getLottery() async {
//     userId = await SharedPre.getStringValue('userId');
//     var headers = {
//       'Content-Type': 'application/json',
//       'Cookie': 'ci_session=18afbdd33b04ace40a80944d83e9e23e3ab91c3e'
//     };
//     var request = http.Request('POST', Uri.parse('${baseUrl}/getLottery'));
//     request.body = json.encode({
//       "game_id": widget.gId,
//       "user_id": userId
//     });
//     print('_____request.body_____${request.body}_________');
//     request.headers.addAll(headers);
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var result = await response.stream.bytesToString();
//       var finalResult  =  LotteryListModel.fromJson(json.decode(result));
//       Fluttertoast.showToast(msg: "${finalResult.msg}");
//       setState(() {
//         lotteryDetailsModel = finalResult;
//
//       });
//     }
//     else {
//       print(response.reasonPhrase);
//     }
//
//   }
}
