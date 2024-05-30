import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer' as d;

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pricedot/Models/HomeModel/get_profile_model.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Screens/Dashboard/dashboard_view.dart';
import 'package:pricedot/Screens/Home/home_view.dart';

import 'package:pricedot/Utils/Colors.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Local_Storage/shared_pre.dart';

import '../../Models/HomeModel/lottery_list_model.dart';
import '../../Services/api_services/apiConstants.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../CouponDiscount.dart';

class WinnerScreenNew extends StatefulWidget {
  WinnerScreenNew({Key? key, this.isFrom, this.gId, this.sport, this.sportLeft})
      : super(key: key);
  final bool? isFrom;
  String? gId, sport, sportLeft;

  @override
  State<WinnerScreenNew> createState() => _WinnerScreenNewState();
}

class _WinnerScreenNewState extends State<WinnerScreenNew>
    with SingleTickerProviderStateMixin {
  var result = '';

  FixedExtentScrollController scrollController = FixedExtentScrollController();
  Timer? timer;
  late AnimationController controller;
  Animation? animation;
  var chanel;
  getData() async {
    String userId = await SharedPre.getStringValue('userId');
    print(
        "ws://alphawizzserver.com:5000?type=0&game_id=${widget.gId}&user_id=${userId}&api=getLottery");
    // await getLottery();
    chanel = WebSocketChannel.connect(Uri.parse(
        "ws://alphawizzserver.com:5000?type=0&game_id=${widget.gId}&user_id=${userId}&api=getLottery"));
    setState(() {});
  }

  late Future my;
  @override
  void initState() {
    super.initState();
    // getData();
    _isLoading = true;
    // scrollController = FixedExtentScrollController();

    // startAutoScroll();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    print(controller.status);
    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 0, end: 1000).animate(curve);

    getData();
  }

  bool isselected = false;
  int _counter = 60;
  // late Timer _timer;

  int _counter1 = 4;
  late Timer _timer1;

  @override
  void dispose() {
    chanel.sink.close();
    super.dispose();
  }

  bool isFirst = true;
  bool isBuy = true;
  String? amount;

  String? purchase;
  late bool _isLoading;
  void _startLoading() {
    _isLoading = true;
    genrate().then((value) {
      setState(() {
        _isLoading = false;
        isselected = true;
        controller.stop();
      });
    });
  }



  String randomNum = '';
  List<String> numbersList = [];
  List<String> removeList = [];
  Future<void> genrate() async {
    // Generate a list of numbers from a specific range
    numbersList.clear();
    removeList.clear();
    removeList = lotteryDetailsModel!.data!.lottery!.purchaseNumbers;
    await generateListInRange(
      int.parse(lotteryDetailsModel!.data!.lottery!.startNumber.toString()),
      int.parse(lotteryDetailsModel!.data!.lottery!.ticketCount.toString()),
    );

    // List from which elements will be removed
    print(numbersList.length);
    // Remove elements from numbersList
    if (removeList.isNotEmpty) {
      removeList.forEach((number) {
        numbersList.remove(number);
      });
    }

    print("List after removing elements: $numbersList");

    // Pick a random number from numbersList
    Random random = Random();
    int randomIndex = random.nextInt(numbersList.length);
    randomNum = numbersList[randomIndex];
    removeList.add(randomNum);
  }

  Future<void> generateListInRange(int start, int end) async {
    print("start: ${start} count:${end}");
    for (int i = 0; i < end; i++) {
      numbersList.add((start + i).toString());
    }
  }

  genrateNumber() {
    _isLoading = true;
    controller.forward();
    Random random = Random();
    int randomNumber = random.nextInt(
            int.parse("${lotteryDetailsModel!.data!.lottery!.ticketCount}")) +
        int.parse("${lotteryDetailsModel!.data!.lottery!.startNumber}");

    final Animation<double> curve =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = IntTween(begin: 0, end: 10000).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _startLoading();
          print("Completed1");
        }
        // if (status == AnimationStatus.dismissed) {
        //   print(randomNumber);
        //   //animation?.value = randomNumber;
        //   if (numbers.contains(randomNumber.toString())) {
        //     print("True");
        //     genrateNumber();
        //   } else {
        //     controller.stop(); // Stop the animation
        //     setState(() {
        //       // Update the state with the random number
        //       isselected = true;
        //       animation = IntTween(begin: randomNumber, end: randomNumber)
        //           .animate(CurvedAnimation(
        //               parent: controller, curve: Curves.easeOut));
        //     });
        //   }

        //   //controller?.value=randomNumber.toDouble();
        // }
      });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpace,
        automaticallyImplyLeading: false,
        //toolbarHeight: 60,
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
              "Play Contest".tr,
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
        // const Text(
        //   "Winner",
        //   style: TextStyle(
        //       color: AppColors.whit, fontSize: 22,),
        // ),
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed(bottomBar);
            },
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 30,
            )),
        actions: [],
      ),
      body: StreamBuilder(
          stream: chanel.stream,
          builder: (context, snap) {
            // d.log(snap.data.toString());
            if (snap.hasError) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                        dimension: MediaQuery.of(context).size.height * .35,
                        child: Image.asset('assets/icons/error.gif')),
                    Text(
                      "Oops! Something went wrong on our end. Our team is already on it, trying to fix the issue. Please try again later. We apologize for any inconvenience this may have caused.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              );
            }

            if (snap.hasData) {
              try {
                lotteryDetailsModel =
                    LotteryListModel.fromJson(jsonDecode(snap.data.toString()));

                startingNumber =
                    lotteryDetailsModel!.data!.lottery!.startNumber.toString();
                ticketNumber = lotteryDetailsModel!.data!.lottery!.ticketCount;
                amount =
                    lotteryDetailsModel!.data!.lottery!.ticketPrice.toString();
                time = lotteryDetailsModel!.data!.lottery!.timer.toString();
                numbers = lotteryDetailsModel!.data!.lottery!.purchaseNumbers;
              } catch (e, st) {
                print(st);
                throw Exception(e);
              }
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // widget.minutes!.length <= 0
                            //     ? Text("")
                            //     : Text(
                            //         "${widget.hours} h ${widget.minutes} m",
                            //         style: TextStyle(
                            //             fontSize: 16,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ], //0Xff810C07
                                  // Define the colors
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Entry Fees".tr,
                                    style: TextStyle(
                                        color: AppColors.whit,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    "₹ ${lotteryDetailsModel!.data!.lottery!.ticketPrice}",
                                    style: const TextStyle(
                                        color: AppColors.whit,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: height * .17,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration:  BoxDecoration(
                          color: AppColors.secondary1.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  "${lotteryDetailsModel!.data!.lottery!.gameName}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                )),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: AppColors.greyColor,
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Result".tr + ":",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "${DateFormat('dd/MM/yyyy').format(DateTime.parse('${lotteryDetailsModel!.data!.lottery!.resultDate} 00:00:00'))}, ${lotteryDetailsModel!.data!.lottery!.resultTime}",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${lotteryDetailsModel?.data?.lottery?.ticketCount} " +
                                      "Coupon".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${int.parse("${widget.sport} ") - int.parse("${lotteryDetailsModel!.data!.lottery!.purchaseNumbers.length}")} " +
                                      "Coupon Left".tr,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration:  BoxDecoration(
                          color: AppColors.secondary1.withOpacity(0.3),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: height * .075),
                            ((int.parse("${widget.sport} ") -
                                            int.parse(
                                                "${lotteryDetailsModel!.data!.lottery!.purchaseNumbers.length}") >
                                        0) &&
                                    int.parse(lotteryDetailsModel!
                                            .data!.lottery!.ticketMaxCount
                                            .toString()) >
                                        int.parse(lotteryDetailsModel!.data!
                                            .lottery!.lotteryNumbers.length
                                            .toString()))
                                ? GestureDetector(
                                    onTap: () {
                                      if (isselected == false) {
                                        genrateNumber();
                                      } else {
                                        // buyLotteryApi(context);
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            String disAmt='';
                                            String finalTotal='';
                                            String code='';
                                            return StatefulBuilder(builder: (context, setState) => Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                ),
                                                color: AppColors.secondary1.withOpacity(0.3),
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              width: width,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          padding:const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                          decoration: BoxDecoration(
                                                              color: AppColors.whit,
                                                              borderRadius: BorderRadius.circular(7)
                                                          ),
                                                          child: Text(code!=''?code :"Apply Coupon",style: TextStyle(fontSize: 16),),
                                                        ),
                                                      ),
                                                      const VerticalDivider(color: Colors.transparent),
                                                      GestureDetector(
                                                        onTap: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CouponDiscountScreen(
                                                            entryFee: lotteryDetailsModel!.data!.lottery!.ticketPrice.toString(),
                                                          ),)).then((value) {
                                                            disAmt=value['discAmt']??'';
                                                            code=value['code']??'';
                                                            finalTotal=value['finalTotal']??'';
                                                            setState((){});
                                                          });
                                                        },
                                                        child: Container(
                                                          padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: AppColors.whit,
                                                            borderRadius: BorderRadius.circular(7),
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                AppColors.primary,
                                                                AppColors.secondary,
                                                              ],
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                            ),
                                                          ),
                                                          child: Text("View",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppColors.whit),),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    padding:const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                    decoration: BoxDecoration(
                                                        color: AppColors.whit,
                                                        borderRadius: BorderRadius.circular(7)
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("Entry Fee:",style: TextStyle(fontSize: 16),),
                                                            Text("₹ ${lotteryDetailsModel!.data!.lottery!.ticketPrice}",style: TextStyle(fontSize: 16),),
                                                          ],
                                                        ),
                                                  disAmt!=''?      Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("Coupon Discount:",style: TextStyle(fontSize: 16),),
                                                            Text("-₹ ${disAmt}",style: TextStyle(fontSize: 16),),
                                                          ],
                                                        ):SizedBox.shrink(),
                                                        disAmt!=''?       Row(
                                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text("To Pay:",style: TextStyle(fontSize: 16),),
                                                            Text("₹ ${finalTotal!=''?finalTotal: lotteryDetailsModel!.data!.lottery!.ticketPrice}",style: TextStyle(fontSize: 16),),
                                                          ],
                                                        ):SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      payWallet(ctx:context,amt: finalTotal!=''?finalTotal: lotteryDetailsModel!.data!.lottery!.ticketPrice.toString(),promoName: code,disc: disAmt);
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      alignment: Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(7),
                                                          gradient:
                                                          LinearGradient(
                                                              colors: [
                                                                AppColors.primary,
                                                                AppColors.secondary,
                                                              ])),
                                                      child: Text(
                                                        "PAY BY WALLET".tr,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:
                                                            Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  // TextButton(
                                                  //   onPressed: () {
                                                  //     Navigator.pop(
                                                  //         context);
                                                  //     getTransactionUrl();
                                                  //   },
                                                  //   child: const Text(
                                                  //     'Pay Online',
                                                  //     style: TextStyle(
                                                  //         fontSize: 16,
                                                  //         fontWeight:
                                                  //             FontWeight
                                                  //                 .bold,
                                                  //         color:
                                                  //             Colors.black),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ));
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppColors.primary,
                                            AppColors.secondary,

                                          ], //0Xff810C07
                                          // Define the colors
                                          begin: Alignment.topLeft,
                                          end: Alignment.topRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: isselected == false
                                            ? Text(
                                                "TAP NOW".tr,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : isLoading
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColors.whit,
                                                    ),
                                                  )
                                                : Text(
                                                    "BUY NOW".tr,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          // padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height/3.1),
                          padding: const EdgeInsets.only(top: 0),
                          child: lotteryDetailsModel == null
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primary))
                              : lotteryDetailsModel!.data!.lottery!
                                      .winningPositionHistory!.isEmpty
                                  ? const Center(
                                      child: Text("No Lottery List!!!"))
                                  : Column(
                                      children: [
                                        Container(
                                          color: Colors.white,
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Rank".tr,
                                                  style: TextStyle(
                                                      color: AppColors.fntClr,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                                Spacer(),
                                                SizedBox.square(
                                                  dimension: 20,
                                                  child: Image.asset(
                                                      "assets/images/prize.png"),
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "Prize".tr,
                                                  style: TextStyle(
                                                      color: AppColors.fntClr,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: lotteryDetailsModel!
                                                .data!
                                                .lottery!
                                                .winningPositionHistory
                                                .length,
                                            itemBuilder: (context, i) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12),
                                                color: i % 2 != 0
                                                    ? AppColors.bgColor
                                                    : Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${lotteryDetailsModel!.data!.lottery!.winningPositionHistory![i].lotteryNo}",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        if (i < 3)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5),
                                                            child: Image.asset(
                                                              "assets/images/winner1.png",
                                                              scale: 1.2,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        // Text("Winning Price :"),
                                                        // SizedBox(width: 3,),
                                                        Text(
                                                          '₹ ${lotteryDetailsModel!.data!.lottery!.winningPositionHistory![i].winnerPrice}',
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .fntClr,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: height * .18,
                      left: width * .01,
                      right: width * .01,
                      child: Container(
                        // color: Colors.greenAccent.withOpacity(0.4),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight: height * .12, maxWidth: width*.7),
                          child: Image.asset(
                            "assets/images/slot.png",
                          ),
                        ),
                      )),
                  // Positioned(
                  //     top: height * .183,
                  //     left: width * .01,
                  //     right: width * .01,
                  //     child: Text(
                  //       '₹${lotteryDetailsModel!.data!.lottery!.winningPositionHistory.first.winnerPrice.toString()}',
                  //       textAlign: TextAlign.center,
                  //       style: const TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.bold,
                  //           color: Color(0xFFECCB78)),
                  //     )),
                  Positioned(
                      top: height * .215,
                      left: width * .01,
                      right: width * .018,
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) => DigitBasedLetterSpacing(
                          text: animation!.value == 0
                              ? '000000'
                              : _isLoading
                                  ? animation!.value.toString()
                                  : randomNum,
                        ),
                      )),
                ],
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary));
            }
          }),
    );
  }

  Color selectedItemColor = Colors.blue; //
  bool ischecktime = false;

  // void startAutoScroll() {
  //   const Duration scrollDuration = const Duration(milliseconds: 10);
  //    Duration pauseDuration =  Duration(seconds: int.parse(time ?? "15"));
  //
  //   timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     scrollController.animateToItem(
  //       scrollController.selectedItem + 1,
  //       duration: scrollDuration,
  //       curve: Curves.linear,
  //     );
  //   });
  //
  //  // Uncomment the following lines if you want to stop scrolling after a certain time
  //   Timer(pauseDuration, () {
  //
  //     print(timer.toString()+"_____________");
  //     ischecktime=true;
  //     setState(() {
  //
  //     });
  //     timer?.cancel();
  //   });
  // }

  double itemExtent = 30.0;
  List<int> selectedCardIndexes = [];
  List<String> cardData = [];

  void addTikitList() {
    // for(int i =0; i<cardData.length;i++){
    //   if(i==0){
    //     result = result + cardData[i];
    //   }else{
    //     result = "$result, ${cardData[i]}";
    //  }
    // }
    print(cardData.toString());
  }

  LotteryListModel? lotteryDetailsModel;
  String? userId;

  int? selectedNumber;
  String? time;
  String? startingNumber;
  String? lottery;
  String? ticketNumber;
  List<String> numbers = [];

  getLottery() async {
    userId = await SharedPre.getStringValue('userId');
    try {
      var request =
          http.Request('POST', Uri.parse('${baseUrl}Apicontroller/getLottery'));
      request.body = json.encode({"game_id": widget.gId, "user_id": userId});
      debugPrint(request.body);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        debugPrint(response.statusCode.toString());
        var result = await response.stream.bytesToString();
        var finalResult = LotteryListModel.fromJson(json.decode(result));
        // Fluttertoast.showToast(msg: "${finalResult.msg}");
        setState(() {
          lotteryDetailsModel = finalResult;
          debugPrint(finalResult.data!.lottery.toString());
          setState(() {
            startingNumber = finalResult.data!.lottery!.startNumber.toString();
            ticketNumber = finalResult.data!.lottery!.ticketCount;
            amount = finalResult.data!.lottery!.ticketPrice.toString();
            time = finalResult.data!.lottery!.timer.toString();
            numbers = finalResult.data!.lottery!.purchaseNumbers;
            print(numbers.length);
          });
        });
      } else {
        debugPrint(response.reasonPhrase);
      }
    } catch (e, Stacktrace) {
      print(Stacktrace);
      throw Exception(e);
    }
  }

  buyLotteryApi(BuildContext ctx) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=b573cdbddfc5117759d47585dfc702de3f6f0cc9'
    };
    var request =
        http.Request('POST', Uri.parse('$baseUrl1/Apicontroller/buyLottery'));
    request.body = json.encode({
      "user_id": userId,
      "game_id": widget.gId,
      "amount": amount,
      "lottery_numbers": animation?.value.toString() ?? "0",
      "order_number": "2675db01c965",
      "txn_id": "2675db01c965ijbdhgd"
    });
    request.headers.addAll(headers);
    print('${request.body}___________Naman');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(result);
    } else {
      print(response.reasonPhrase);
    }
  }

  payWallet({required BuildContext ctx,required String amt,required String promoName,required String disc}) async {
    setState(() {
      isLoading = true;
    });
    var user_id = await SharedPre.getStringValue('userId');
    var request = http.Request(
        'POST', Uri.parse('$baseUrl1/Apicontroller/buyLotterybywallet'));
    request.body = json.encode({
      "user_id": user_id,
      "game_id": widget.gId,
      "amount": amt,
      "lottery_numbers": randomNum ?? "0",
      "order_number": "2675db01c965",
      "txn_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "promo_amount":disc,
      "promo_name":promoName,});
    print('${request.body}___________b');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(result);
      print(jsonResponse.toString());

      if (jsonResponse['status'] == false) {
        Fluttertoast.showToast(msg: "${jsonResponse['msg']}");
        setState(() {
          isLoading = false;
          isselected = false;
          controller.reset();
        });
      } else {
        await SharedPre.setValue('drawNo', "");
        await SharedPre.setValue('orderId', "");
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (c) {
              Future.delayed(const Duration(seconds: 3)).then((value) {
                dispose();
                Navigator.pop(c);
                Navigator.pop(context);
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DashBoardScreen(),
                //     ),
                //     (route) => false);
              });
              return PopScope(
                canPop: false,
                child: Dialog(
                  backgroundColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: 180,
                        child: Stack(
                          children: [
                            Lottie.asset('assets/images/confetti.json'),
                            Divider(
                              color: Colors.transparent,
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
                                    Divider(
                                      color: Colors.transparent,
                                    ),
                                    Image.asset("assets/icons/congo.png"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Coupon".tr,
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'Pacifico',
                                              color: AppColors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "no. ${randomNum}",
                                          style: const TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'Pacifico',
                                              color: Colors.black,
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
                ),
              );
            });
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  String? paymentUrl;

  paymentStatus(String orderID) async {
    try {
      //${baseUrl}/get_game_payment_status?order_id=1710833718
      var request = await http.get(Uri.parse(
          '${baseUrl}/get_game_payment_status?order_id=' +
              orderID));
      //  request.fields.addAll({'order_id': orderID});

      print(
          '${baseUrl}/get_game_payment_status?order_id=' +
              orderID);

      //  http.StreamedResponse response = await request.send();
      var json = jsonDecode(request.body);
      print(json);

      if (request.statusCode == 200) {
        if (json['status'] == "SUCCESS") {
          var drawNo = await SharedPre.getStringValue('drawNo');

          if (drawNo == "") {
          } else {
            await SharedPre.setValue('drawNo', "");
            await SharedPre.setValue('orderId', "");
            await buyLotteryApi(context);
            showDialog(
                context: context,
                builder: (c) {
                  Future.delayed(const Duration(seconds: 3)).then((value) {
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
                          border:
                              Border.all(width: 3, color: AppColors.bgColor),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 150,
                          child: Stack(
                            children: [
                              Lottie.asset('assets/images/confetti.json'),
                              Center(
                                child: Builder(builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Congratulations",
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: AppColors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Your Draw No.",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              drawNo,
                                              style: const TextStyle(
                                                  fontSize: 32,
                                                  color: AppColors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
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
          //Fluttertoast.showToast(msg: json['message']);
          Future.delayed(const Duration(seconds: 20))
              .then((value) => paymentStatus(orderID));
        }
      } else {
        print(request.reasonPhrase);
      }
    } catch (e, Stacktrace) {
      print(Stacktrace);
      throw Exception(e);
    }
  }

  bool isLoading = false;
  getTransactionUrl() async {
    await SharedPre.setValue('drawNo', animation?.value.toString());
    await SharedPre.setValue('gameID', widget.gId);
    await SharedPre.setValue(
        'amount', lotteryDetailsModel!.data!.lottery!.ticketPrice.toString());
    setState(() {
      isLoading = true;
    });
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'ci_session=b573cdbddfc5117759d47585dfc702de3f6f0cc9'
    };
    var request = http.Request(
        'Get',
        Uri.parse(
            '$baseUrl1/Apicontroller/get_payment?amount=${lotteryDetailsModel!.data!.lottery!.ticketPrice}&user_id=${userId}&payment_for=game&game_id=${widget.gId}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(result);
      d.log(jsonResponse['data']['order_id'].toString());
      if (jsonResponse['status_code'] == 200) {
        paymentUrl = jsonResponse['data']['intent_link'];

        setState(() {
          isLoading = false;
        });
        await SharedPre.setValue('orderId', "1710833718");

        launchUPI(paymentUrl ?? '');
        // Fluttertoast.showToast(
        //   msg: 'Your amount will be credited once the transaction is confirmed',
        // );
        Future.delayed(Duration(seconds: 30)).then((value) =>
            // paymentStatus("1710833718"));

            paymentStatus(jsonResponse['data']['order_id'].toString()));
      } else {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
      });
    }
  }

  void launchUPI(String link) async {
    //const url = 'upi://pay';
    //const url = 'upi://pay?ver=01&mode=15&am=100.00&mam=100.00&cu=INR&pa=haoda.dmtechnology@timecosmos&pn=DM Technology&mc=7372&tr=HAODA4063240318115943258&tn=4063240318115943258&mid=HAODA001&msid=DMTE-9927&mtid=HAODA001';
    /* if (await (url) {*/
    var result = await launch(link);
    debugPrint(result.toString());
    if (result == true) {
      print("Done");
    } else if (result == false) {
      print("Fail");
    }
    /* } else {
      throw 'Could not launch $url';
    }*/
  }
}


class DigitBasedLetterSpacing extends StatelessWidget {
  String text;

  DigitBasedLetterSpacing({required this.text});

  @override
  Widget build(BuildContext context) {
    double letterSpacing = calculateLetterSpacing();

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 42.0,
      color: Colors.black,
        fontWeight: FontWeight.w800,
        letterSpacing: letterSpacing,
      ),
    );
  }

  double calculateLetterSpacing() {
    // Adjust the letter spacing based on the number of digits
    // if (text.length == 6) {
    //   return 14;
    // } else if (text.length == 3) {
    //   return 14;
    // } else {
    return 20;
    // }
  }
}
