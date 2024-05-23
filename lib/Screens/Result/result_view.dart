import 'dart:convert';

import 'package:pricedot/Constants.dart';
import 'package:pricedot/Screens/Profile/profile_controller.dart';
import 'package:pricedot/Screens/Result/result_detaits_view.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Utils/custom_clip_path.dart';
import 'package:pricedot/Widgets/app_button.dart';
import 'package:pricedot/Widgets/auth_custom_design.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:pricedot/Widgets/custom_appbar.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/Widgets/nodatafound.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../Local_Storage/shared_pre.dart';
import '../../Models/HomeModel/get_result_model.dart';
import '../../Models/HomeModel/my_lottery_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../../Services/api_services/apiStrings.dart';
import 'package:http/http.dart' as http;

import '../Bookings/lottery_details.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key, this.isFrom}) : super(key: key);
  final bool? isFrom;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
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

  @override
  Widget build(BuildContext context) {
    bool receivedData = Get.arguments ?? false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpace,
        leading: receivedData
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ))
            : null,
        toolbarHeight: 60,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/CupIcon.png",
              scale: 2,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(
              CURR_USR == '243' ? "My Tasks" : "My Contest".tr,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 7,
            ),
            Image.asset(
              "assets/images/CupIcon.png",
              scale: 2,
            ),
          ],
        ),
      ),
      // appBar: AppBar,
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 2), () {
            getLottery();
          });
        },
        child: getResultModel == null
            ? Center(child: CircularProgressIndicator(color: AppColors.primary))
            : getResultModel!.data!.lotteries.length == 0
                ? Center(
                    child: NoDataFound())
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: getResultModel!.data!.lotteries.length,
                    // itemCount:2,
                    itemBuilder: (context, index) {
                      print("Index====> $index");
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LotteryDetails(
                                gId: getResultModel!
                                    .data!.lotteries[index].gameId
                                    .toString(),
                                lotteriItems: getResultModel!
                                    .data!.lotteries[index].lotteryNumbers!
                                    .split(',')
                                  ..sort(),
                                lot: getResultModel!.data!.lotteries[index],
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 8),
                            decoration: BoxDecoration(
                                color: AppColors.whit,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF000000).withOpacity(.12),
                                    offset: Offset(0, 3),
                                    blurRadius: 8,
                                  ),
                                ],
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        child: Text(
                                          "${getResultModel!.data!.lotteries[index].gameName}",
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: AppColors.primary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: AppColors.greyColor,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Result".tr + " : ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            Text(
                                              formatDate(getResultModel!.data!
                                                  .lotteries![index].resultDate
                                                  .toString()),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            Text(
                                              " ${getResultModel!.data!.lotteries[index].resultTime}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                        "Entry Fees".tr +
                                            ": ₹ ${getResultModel!.data!.lotteries[index].ticketPrice}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        height: 45,
                                        width: 45,
                                        child: Image.network(
                                          "${getResultModel!.data!.lotteries[index].image}",
                                          fit: BoxFit.fill,
                                        ),
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
                                          bottomRight: Radius.circular(10))),
                                  child: getResultModel!.data!.lotteries[index]
                                              .resultStatus ==
                                          "1"
                                      ? Text("Result Decleared".tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                      : Text(
                                          "Result not declared yet".tr,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                )
                              ],
                            )),
                      );
                    }),
      ),

      // Stack(
      //   children: [
      //     customResult(context, ''),
      //     Padding(
      //       // padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/3.1),
      //       padding: EdgeInsets.only(
      //           top: MediaQuery.of(context).size.height / 8.1),
      //       child:
      //
      //       Container(
      //         width: MediaQuery.of(context).size.width,
      //         height: MediaQuery.of(context).size.height,
      //         decoration: const BoxDecoration(
      //           color: Color(0xfff6f6f6),
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(30),
      //             // Top-left corner radius
      //             topRight: Radius.circular(30),
      //             // Top-right corner radius
      //           ),
      //         ),
      //         child:Padding(
      //           padding: const EdgeInsets.only(right:10,left: 10,top: 2),
      //           child:  SingleChildScrollView(
      //             child: Padding(
      //                 padding:  EdgeInsets.all(2.0),
      //                 child:RefreshIndicator(
      //                   onRefresh: (){
      //                     return Future.delayed(Duration(seconds: 2), () {
      //                       getResultDetails();
      //                     });
      //
      //                   },
      //                   child: Container(
      //                     height: MediaQuery.of(context).size.height/1.0,
      //                     child: ListView.builder(
      //                         itemCount: 1,
      //                         itemBuilder: (context,i){
      //                           return  Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               SizedBox(height: 10,),
      //                               Padding(
      //                                 padding: const EdgeInsets.all(0.0),
      //                                 child: Column(
      //                                   crossAxisAlignment: CrossAxisAlignment.start,
      //                                   children: [
      //                                     Padding(
      //                                       padding: const EdgeInsets.all(3.0),
      //                                       child: Container(
      //                                         //height: MediaQuery.of(context).size.height/1.1,
      //                                           child:getResultModel == null ? Center(child: CircularProgressIndicator(color: AppColors.primary)):getResultModel!.data!.lotteries!.length == 0?
      //                                           Center(child: Text("No Result found!!!")): ListView.builder(
      //                                               scrollDirection: Axis.vertical,
      //                                               shrinkWrap: true,
      //                                               physics: const NeverScrollableScrollPhysics(),
      //                                               itemCount:getResultModel!.data!.lotteries!.length ,
      //                                               // itemCount:2,
      //                                               itemBuilder: (context, index) {
      //                                                 return InkWell(
      //                                                   child: Padding(
      //                                                     padding: const EdgeInsets.all(5.0),
      //                                                     child: InkWell(
      //                                                       onTap: (){
      //                                                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultDetailsScreen(gId:getResultModel!.data!.lotteries![index].gameId)));
      //                                                       },
      //                                                       child: Container(
      //                                                           height: 90,
      //                                                           decoration: const BoxDecoration(
      //                                                               image: DecorationImage(
      //                                                                   image: AssetImage("assets/images/myLotterybooking.png"), fit: BoxFit.fill)),
      //                                                           child:  Column(
      //                                                             children: [
      //                                                               Padding(
      //                                                                 padding: const EdgeInsets.only(left: 5,right: 5),
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                                                   children: [
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         Text("Result Date :",style: TextStyle(color: AppColors.whit,fontSize: 12),),
      //                                                                         SizedBox(width: 2,),
      //                                                                         Text("${getResultModel!.data!.lotteries![index].resultDate}",style: TextStyle(color: AppColors.whit,fontSize: 12),)
      //                                                                       ],
      //                                                                     ),
      //                                                                     Row(
      //                                                                       children: [
      //                                                                         SizedBox(height: 25,),
      //                                                                         Text("Result Time:",style: TextStyle(color: AppColors.whit,fontSize: 12),),
      //                                                                         SizedBox(width: 2,),
      //                                                                         Text("${getResultModel!.data!.lotteries![index].resultTime}",style: TextStyle(color: AppColors.whit,fontSize: 12),)
      //                                                                       ],
      //                                                                     ),
      //
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //                                                               Padding(
      //                                                                 padding: const EdgeInsets.all(8.0),
      //                                                                 child: Row(
      //                                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                                                   children: [
      //                                                                     Column(
      //                                                                       crossAxisAlignment: CrossAxisAlignment.start,
      //                                                                       children: [
      //                                                                         Text("${getResultModel!.data!.lotteries![index].gameName}",style: TextStyle(color: AppColors.whit,fontSize: 12),),
      //                                                                         SizedBox(height: 3,),
      //                                                                         // Text("1st Price : ${getResultModel!.data!.lotteries![index].winners}",style: TextStyle(color: AppColors.whit,fontSize: 18),),
      //
      //                                                                       ],
      //                                                                     ),
      //
      //                                                                     // myLotteryModel?.data?.lotteries?[index].active == '0' ? SizedBox.shrink():  Text("Betting is Running Now",style: TextStyle(color: AppColors.whit,fontSize: 12),),
      //                                                                     Container(
      //                                                                       height: 45,width: 50,
      //                                                                       child: ClipRRect(
      //                                                                           borderRadius: BorderRadius.circular(10),
      //                                                                           child: Image.network("${getResultModel!.data!.lotteries![index].image}",fit: BoxFit.fill,)),
      //                                                                     ),
      //                                                                   ],
      //                                                                 ),
      //                                                               ),
      //
      //                                                             ],
      //                                                           )
      //                                                       ),
      //                                                     ),
      //                                                   ),
      //                                                 );
      //                                               }
      //                                           )
      //                                       ),
      //                                     ),
      //
      //                                   ],
      //                                 ),
      //                               ),
      //
      //                             ],
      //                           );
      //                         }),
      //                   ),
      //                 )
      //             ),
      //           )
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }

  String? userId;
  getUser() async {
    userId = await SharedPre.getStringValue('userId');
    getLottery();
  }
  // GetResultModel? getResultModel;
  // getResultDetails() async {
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Cookie': 'ci_session=4b8b6274f26a280877c08cfedab1d6e9b46e4d2d'
  //   };
  //   var request = http.Request('POST', Uri.parse('$baseUrl1/Apicontroller/getResults'));
  //   request.body = json.encode({
  //     "user_id":userId
  //   });
  //   print('____request.body______${request.body}_________');
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     var result = await response.stream.bytesToString();
  //     var finalResult = GetResultModel.fromJson(jsonDecode(result));
  //     setState(() {
  //       getResultModel = finalResult;
  //     });
  //    // Fluttertoast.showToast(msg: "${finalResult.msg}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }

  MyLotteryModel? getResultModel;

  getLottery() async {
    getResultModel = null;
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=4b8b6274f26a280877c08cfedab1d6e9b46e4d2d'
    };
    var request =
        http.Request('POST', Uri.parse('$baseUrl1/Apicontroller/getLotteries'));
    request.body = json.encode({"user_id": userId});
    print('_____request.b dfgbdfghgf ody_____${request.body}_________');
    request.headers.addAll(headers);
    print(request.url);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = MyLotteryModel.fromJson(jsonDecode(result));
      setState(() {
        getResultModel = finalResult;
        print(getResultModel!.data!.lotteries.length);
      });
    } else {
      print(response.reasonPhrase);
    }
  }
}
