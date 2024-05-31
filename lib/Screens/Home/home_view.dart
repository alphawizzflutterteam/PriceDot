import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:pricedot/Constants.dart';
import 'package:pricedot/Local_Storage/shared_pre.dart';
import 'package:pricedot/Models/CategoryModel.dart';
import 'package:pricedot/Models/HomeModel/get_profile_model.dart';
import 'package:pricedot/Routes/routes.dart';
import 'package:pricedot/Screens/Auth_Views/Login/login_view.dart';
import 'package:pricedot/Screens/Home/HomeController.dart';
import 'package:pricedot/Screens/Home/completedScreen.dart';
import 'package:pricedot/Screens/Splash/splash_controller.dart';
import 'package:pricedot/Screens/Winner/WinnerViewNew.dart';
import 'package:pricedot/Utils/Colors.dart';
import 'package:pricedot/Utils/PrefUtils.dart';
import 'package:pricedot/Widgets/commen_widgets.dart';
import 'package:pricedot/Widgets/designConfig.dart';
import 'package:pricedot/Widgets/nodatafound.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Models/HomeModel/get_result_model.dart';
import '../../Models/HomeModel/get_slider_model.dart';
import '../../Models/HomeModel/lottery_model.dart';
import '../../Services/api_services/apiConstants.dart';
import '../../Services/api_services/apiStrings.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../CouponDiscount.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 1;
  var channel;
  List<TimeDifferent> differenceList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    my=getCategory();
    getProfile();
    getSlider();
    getResult();
    getImage();
  }

  GetProfileModel? getProfileModel;

  getProfile() async {
    try {
      var userId = await SharedPre.getStringValue('userId');
      var request = http.Request(
          'POST', Uri.parse('$baseUrl1/Apicontroller/apiGetProfile'));
      request.body = json.encode({"user_id": userId.toString()});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        var finalResult = GetProfileModel.fromJson(json.decode(result));
        if (finalResult.profile!.status == "0") {
          Fluttertoast.showToast(msg: "User Account Inactive");
          await SharedPre.setValue(SharedPre.isLogin, false);
          await SharedPre.setValue("userId", '');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ),
              (route) => false);
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, StackTrace) {
      print(StackTrace);
      throw Exception(e);
    }
  }

  CategoryModel? CatModel;
  getCategory()async{
    try{
      var request = http.Request('GET', Uri.parse('${baseUrl}/Apicontroller/getCategory'));
      http.StreamedResponse response = await request.send();
      var json=jsonDecode(await response.stream.bytesToString());
      if (response.statusCode == 200) {
        CatModel=CategoryModel.fromJson(json);
        init(index: 1,cat: CatModel!.data[_selectedCat].categoryId.toString());
      }
      else {
        print(response.reasonPhrase);
      }

    }catch(e){
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
 late Future my;
  init({required int index,required String cat}) {
    print("index $index");
    channel = WebSocketChannel.connect(
        Uri.parse("ws://alphawizzserver.com:5000?type=${index}&category_id=${cat}&user_id=${CURR_USR.toString()}"));
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

  String image = '';
  getImage() async {
    String lang = PreferenceUtils.getString(PrefKeys.language);
    print("Language.... $lang");
    switch (lang.toString()) {
      case "1":
        image = 'assets/images/nodata-hi.png';
        break;
      case "2":
        image = 'assets/images/nodata-en.png';
        break;
      case "3":
        image = 'assets/images/nodata-ta.png';
        break;
      case "4":
        image = 'assets/images/nodata-te.png';
        break;
      default:
        image = 'assets/images/nodata-hi.png';
        break;
    }
  }




  int _currentIndex = 1;
  int _selectedCat = 0;
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          flexibleSpace: FlexibleSpace,
          automaticallyImplyLeading: false,

          title: Image.asset(
            "assets/images/logoText.png",
            height: 30,
          ),
          actions: [
            CURR_USR == '243'
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: () {
                      Get.toNamed(walletScreen);

                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.whit,
                      ),
                      child: Image.asset(
                        "assets/icons/wallet.png",
                      ),
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
          ]),
      body: FutureBuilder(
        future: my,
        builder: (context,snap) {
          return snap.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator(color: AppColors.primary,),) :StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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

              if (snapshot.hasData) {
                lotteryModel =
                    LotteryModel.fromJson(jsonDecode(snapshot.data.toString()));
                // int minutesBetween(DateTime from, DateTime to) =>
                //     (to.difference(from).inSeconds).round();
                // differenceList = [];
                // if (_currentIndex == 2 || _currentIndex == 1) {
                //   lotteryModel?.data?.lotteries?.forEach((element) {
                //     var date1 = DateTime.parse(element.openingTime.toString());
                //     var date2 = DateTime.now();
                //     int? difference = minutesBetween(date2, date1);
                //     // print('${difference}___________difference___');
                //     getTimer(difference);
                //   });
                // }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () {
                    return Future.delayed(const Duration(seconds: 2), () {
                      getSlider();
                      init(index: _currentIndex,cat: CatModel!.data[_selectedCat].categoryId.toString());
                      getResult();
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 5),
                        color: Colors.white,
                        height: kToolbarHeight,
                        child:CatModel==null?SizedBox() :ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: CatModel!.data.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCat=index;
                                init(index: _currentIndex,cat:CatModel!.data[index].categoryId.toString() );
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.zero,
                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.whit,
                                border:_selectedCat==index? Border(

                                  bottom: BorderSide(width: 3, color: AppColors.primary),
                                ):null,
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CachedNetworkImage(imageUrl: CatModel!.data[index].categoryImage.toString(),fit: BoxFit.cover,)),
                                  ),
                                  const SizedBox(width: 5),
                                  Text('${CatModel!.data[index].categoryName}',style: TextStyle(color: _selectedCat==index?AppColors.primary:AppColors.fntClr,fontSize: 12),)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      getSliderModel == null
                          ? SizedBox.shrink()
                          : CarouselSlider(
                              items: getSliderModel!.sliderdata!
                                  .map(
                                    (item) => Container(
                                      height:
                                          MediaQuery.of(context).size.height * .15,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                "${item.sliderImage}",
                                              ),
                                              fit: BoxFit.fill)),
                                    ),
                                  )
                                  .toList(),
                              carouselController: carouselController,
                              options: CarouselOptions(
                                  height: MediaQuery.of(context).size.height * .15,
                                  scrollPhysics: const BouncingScrollPhysics(),
                                  autoPlay: true,
                                  autoPlayInterval: Duration(seconds: 8),
                                  aspectRatio: 1.8,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentPost = index;
                                    });
                                  })),
                      // SizedBox(height: MediaQuery.of(context).size.height * .005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildDots(),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .01),


                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 40,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(.12),
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TabBarContainer(
                                  currentIndex: _currentIndex,
                                  text: "Today".tr,
                                  index: 1,
                                  onTap: () {
                                    lotteryModel = null;
                                    setState(() {
                                      _currentIndex = 1;
                                      init(index: _currentIndex!.toInt(),cat: CatModel!.data[_selectedCat].categoryId.toString());
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                  child: TabBarContainer(
                                currentIndex: _currentIndex,
                                text: "Upcoming".tr,
                                index: 2,
                                onTap: () {
                                  lotteryModel = null;
                                  setState(() {
                                    _currentIndex = 2;
                                    init(index: _currentIndex.toInt(),cat: CatModel!.data[_selectedCat].categoryId.toString());
                                  });
                                },
                              )),
                              // Expanded(
                              //     child: TabBarContainer(
                              //   currentIndex: _currentIndex,
                              //   text: "Completed".tr,
                              //   index: 3,
                              //   onTap: () {
                              //     lotteryModel = null;
                              //     setState(() {
                              //       _currentIndex = 3;
                              //       init(index: _currentIndex!.toInt(),cat: CatModel!.data[_selectedCat].categoryId.toString());
                              //     });
                              //   },
                              // )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * .01),
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: snapshot.connectionState == ConnectionState.waiting
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primary))
                              : lotteryModel?.data?.lotteries?.length == 0
                                  ? Center(
                                      child: Image.asset(
                                        image,
                                        height:
                                            MediaQuery.of(context).size.height * .3,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          lotteryModel?.data?.lotteries?.length ??
                                              0,
                                      // itemCount:2,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (lotteryModel!
                                                    .data!.lotteries![index].type ==
                                                "3") {
                                              if (lotteryModel!
                                                      .data!
                                                      .lotteries![index]
                                                      .resultStatus ==
                                                  '1') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CompletedScreen(
                                                        lot: lotteryModel!.data!
                                                            .lotteries![index],
                                                      ),
                                                    ));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Result will be declared soon, stay tuned in draw money app"
                                                            .tr);
                                              }
                                            } else {
                                              if (lotteryModel!.data!
                                                      .lotteries![index].active ==
                                                  '1') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WinnerScreenNew(
                                                              gId: lotteryModel
                                                                  ?.data
                                                                  ?.lotteries?[
                                                                      index]
                                                                  .gameId,
                                                              sport: lotteryModel
                                                                  ?.data
                                                                  ?.lotteries?[
                                                                      index]
                                                                  .ticketCount,
                                                              sportLeft:
                                                                  lotteryModel
                                                                      ?.data
                                                                      ?.lotteries?[
                                                                          index]
                                                                      .userCount,
                                                            )));
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please wait while the game starts, stay tuned and win exciting amount"
                                                            .tr);
                                              }
                                              // Navigator.push(context, MaterialPageRoute(builder: (context) =>  WinnerScreen(gId: lotteryModel?.data?.lotteries?[index].gameId,hours: differenceList[index].hour /*int.parse(hours ?? "")*/,minutes: differenceList[index].minutes/*int.parse(minutes ?? "")*/,sport: lotteryModel?.data?.lotteries?[index].ticketCount,sportLeft: lotteryModel?.data?.lotteries?[index].userCount)));
                                            }
                                          },
                                          child: Container(
                                              margin:
                                                  const EdgeInsets.only(bottom: 10),
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: AppColors.whit,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0xFF000000)
                                                          .withOpacity(.12),
                                                      offset: Offset(0, 3),
                                                      blurRadius: 8,
                                                    ),
                                                  ]),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  .35,
                                                          child: Text(
                                                            "${lotteryModel!.data!.lotteries![index].gameName}",
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: Theme.of(context)
                                                                .textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                                    color: AppColors
                                                                        .primary,
                                                                    fontSize: 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 5,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: AppColors.greyColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(7)),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Result".tr,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                              ),
                                                              Text(
                                                                formatDate(
                                                                    lotteryModel!
                                                                        .data!
                                                                        .lotteries![
                                                                            index]
                                                                        .resultDate
                                                                        .toString()),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                              ),
                                                              Text(
                                                                " ${lotteryModel!.data!.lotteries![index].resultTime}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: Color(0xFFCFCFCF),
                                                  ),

                                                  _currentIndex == 3
                                                      ? Container(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 5,
                                                              vertical: 5),
                                                          decoration: BoxDecoration(
                                                              color: AppColors.buttonColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(7)),
                                                          child: Text(
                                                            "Completed".tr,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .whit,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )
                                                      : differenceList.isEmpty ||
                                                              differenceList[index]
                                                                      .seconds ==
                                                                  ''
                                                          ? SizedBox.shrink():SizedBox.shrink(),


                                                  // const SizedBox(
                                                  //   height: 5,
                                                  // ),
                                                  if (_currentIndex == 3)
                                                    const SizedBox.shrink()
                                                  else
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5, right: 5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal: 5),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "  ${lotteryModel!.data!.lotteries![index].ticketCount}\n" +
                                                                      "Coupon".tr,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          height: 1,
                                                                          color: Color(
                                                                              0Xff171717),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal: 5,
                                                                      vertical: 5),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                7),
                                                                    gradient:
                                                                        const LinearGradient(
                                                                      colors: [
                                                                        AppColors.primary,
                                                                        AppColors.secondary,
                                                                      ],
                                                                      // Define the colors
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .topRight,
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        "Entry Fees"
                                                                            .tr,
                                                                        style: TextStyle(
                                                                            color: AppColors
                                                                                .whit,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 2,
                                                                      ),
                                                                      Text(
                                                                        "₹ ${lotteryModel!.data!.lotteries![index].ticketPrice}",
                                                                        style: const TextStyle(
                                                                            color: AppColors
                                                                                .whit,
                                                                            fontSize:
                                                                                10,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${int.parse("${lotteryModel!.data!.lotteries![index].ticketCount} ") - int.parse("${lotteryModel!.data!.lotteries![index].userCount}")}\n" +
                                                                      "Coupon Left"
                                                                          .tr,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          height: 1,
                                                                          color: Color(
                                                                              0XffD93B35),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // 0XffD93B35
                                                              // const SizedBox(
                                                              //   height:
                                                              //       15,
                                                              // ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            5,
                                                                        vertical:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xFF01BC09),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                7)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Start".tr,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                              fontSize:
                                                                                  10,
                                                                              color: AppColors
                                                                                  .whit,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      '${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse('${lotteryModel!.data!.lotteries![index].openingTime}'))}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                              fontSize:
                                                                                  10,
                                                                              color: AppColors
                                                                                  .whit,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            5,
                                                                        vertical:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xFF01BC09),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                7)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "End".tr,
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                              fontSize:
                                                                                  10,
                                                                              color: AppColors
                                                                                  .whit,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 2,
                                                                    ),
                                                                    Text(
                                                                      "${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse('${lotteryModel!.data!.lotteries![index].closingTime}'))}",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(
                                                                              fontSize:
                                                                                  10,
                                                                              color: AppColors
                                                                                  .whit,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            colors: [
                                                          AppColors.greyColor.withOpacity(.1),
                                                          AppColors.greyColor.withOpacity(.5),

                                                        ])),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 10),
                                                                child:
                                                                    SizedBox.square(
                                                                  dimension: 25,
                                                                  child:
                                                                      Image.network(
                                                                    lotteryModel!
                                                                        .data!
                                                                        .lotteries![
                                                                            index]
                                                                        .image
                                                                        .toString(),
                                                                  ),
                                                                )),
                                                            Container(
                                                              //width: 100,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical: 5),
                                                              // decoration: BoxDecoration(
                                                              //     color: const Color(0Xff00E701),
                                                              //     borderRadius: BorderRadius.circular(10)
                                                              // ),
                                                              child: (lotteryModel!
                                                                              .data!
                                                                              .lotteries![
                                                                                  index]
                                                                              .prizeName ==
                                                                          null ||
                                                                      lotteryModel!
                                                                          .data!
                                                                          .lotteries![
                                                                              index]
                                                                          .winningPositionHistory!
                                                                          .isEmpty)
                                                                  ? const Text(
                                                                      "",
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .whit,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                    )
                                                                  : Row(
                                                                    children: [
                                                                      Text(
                                                                           numericRegex.hasMatch("${lotteryModel!.data!.lotteries?[index].winningPositionHistory?.first.winnerPrice}")?"₹" :"",
                                                                          style: const TextStyle(
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize:
                                                                                  12,
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                        ),
                                                                      Text(
                                                                        "${lotteryModel!.data!.lotteries?[index].winningPositionHistory?.first.winnerPrice}",
                                                                        style: const TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                            12,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                            ),
                                                            //   Text(
                                                            //     "₹ ${lotteryModel!.data!.lotteries![index].winningPositionHistory!.first.winnerPrice}",
                                                            //   style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold,fontFamily: 'lora'),
                                                            // ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/teamIcon.png",
                                                              scale: 1.3,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              "Max Coupon".tr,
                                                              style: TextStyle(
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Text(
                                                              "${lotteryModel!.data!.lotteries![index].ticketMaxCount}",
                                                              style: TextStyle(
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        );
                                      }),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary));
              }
            },
          );
        }
      ),
    );
  }

  Widget sliderPointers(List doteList, int currentIndex) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: doteList.asMap().entries.map((entry) {
          return GestureDetector(
            // onTap:()=> controller.carouselController.animateToPage(entry.key),
            child: Container(
              width: currentIndex == entry.key ? 8 : 8,
              height: 8.0,
              margin: const EdgeInsets.symmetric(
                horizontal: 3.0,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: currentIndex == entry.key
                      ? AppColors.primary
                      : Colors.black),
            ),
          );
        }).toList());
  }

  int _currentPost = 0;
  _buildDots() {
    List<Widget> dots = [];
    if (getSliderModel == null) {
    } else {
      for (int i = 0; i < getSliderModel!.sliderdata!.length; i++) {
        dots.add(
          Container(
            margin: const EdgeInsets.all(1.5),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPost == i
                  ? AppColors.secondary
                  : const Color(0xFF8F8F8F),
            ),
          ),
        );
      }
    }
    return dots;
  }

  GetSliderModel? getSliderModel;
  bool isLoading = false;
  Future<void> getSlider() async {
    isLoading = true;
    // isLoading.value = true;
    var param = {
      'app_key':
          "#63Y@#)KLO57991(\$457D9(JE4dY3d2250f\$%#(mhgamesapp!xyz!punjablottery)8fm834(HKU8)5grefgr48mg1"
    };
    apiBaseHelper.postAPICall(getSliderAPI, param).then((getData) {
      bool status = getData['status'];
      String msg = getData['msg'];
      if (status == true) {
        getSliderModel = GetSliderModel.fromJson(getData);
        setState(() {
          isLoading = false;
        });
      } else {
        // Fluttertoast.showToast(msg: msg);
        setState(() {
          isLoading = false;
        });
      }
      //isLoading.value = false;
    });
  }

  LotteryModel? lotteryModel;

  getLottery(String type) async {
    var headers = {
      'Cookie': 'ci_session=9a597f0a2bd1bd75484115e7b6428843ca383d46'
    };
    var request =
        http.Request('POST', Uri.parse('${baseUrl}Apicontroller/getLotteries'));
    request.body = json.encode({"type": type});
    print('____Som_____lott_${request.body}_________' +
        "${baseUrl}Apicontroller/getLotteries");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var result = await response.stream.bytesToString();
    // dev.log(result.toString() + "______lottery_______");
    if (response.statusCode == 200) {
      var finalResult = LotteryModel.fromJson(jsonDecode(result));
      setState(() {
        lotteryModel = finalResult;
        int minutesBetween(DateTime from, DateTime to) =>
            (to.difference(from).inSeconds / 60).round();
        differenceList = [];
        if (type == "2" || type == "1") {
          lotteryModel?.data?.lotteries?.forEach((element) {
            var date1 = DateTime.parse(element.openingTime.toString());
            var date2 =
                DateTime.parse(lotteryModel!.currentDateTime.toString());
            ;
            int? difference = minutesBetween(date2, date1);
            print('${difference}___________difference___');
            getTimer(difference);
          });
        }
        //minutesBetween(date2, date1);
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  getTimer(int difference) {
    // Duration in minutes
    int? totalMinutes = difference.toInt();
    // print("Total min: ${totalMinutes}");
    // Convert minutes to Duration
    Duration duration = Duration(seconds: totalMinutes);

    String hours =
        duration.inHours <= 0 ? "" : '${duration.inHours.toString()}h';
    String minutes = duration.inMinutes.remainder(60) <= 0
        ? ""
        : '${duration.inMinutes.remainder(60).toString()}m';
    String seconds = duration.inSeconds.remainder(60) <= 0
        ? ""
        : "${duration.inSeconds.remainder(60).toString()}s";

    differenceList
        .add(TimeDifferent(hour: hours, minutes: minutes, seconds: seconds));

    // Extract hours, minutes, and seconds

    // Print the result
    // print(
    //     'sssssssssssssss$totalMinutes minutes is equal to: $hours hours, $minutes minutes, and $seconds seconds');
    return duration;
  }

  // Future<void> getLottery() async {
  //   apiBaseHelper.postAPICall2(getLotteryAPI).then((getData) {
  //     setState(() {
  //       lotteryModel = LotteryModel.fromJson(getData);
  //     });
  //     //isLoading.value = false;
  //   });
  // }

  GetResultModel? getResultModel;
  Future<void> getResult() async {
    apiBaseHelper.postAPICall2(getResultAPI).then((getData) {
      setState(() {
        getResultModel = GetResultModel.fromJson(getData);
      });

      //isLoading.value = false;
    });
  }
}

class TabBarContainer extends StatefulWidget {
  const TabBarContainer(
      {super.key,
      required this.index,
      required this.onTap,
      required this.text,
      required this.currentIndex});
  final int index;
  final VoidCallback onTap;
  final String text;
  final int? currentIndex;
  @override
  State<TabBarContainer> createState() => _TabBarContainerState();
}

class _TabBarContainerState extends State<TabBarContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: widget.currentIndex == widget.index
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary], //0Xff810C07
                  // Define the colors
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                boxShadow: const []),
        child: Center(
          child: Text(widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.currentIndex == widget.index
                      ? AppColors.whit
                      : const Color(0xFF676666),
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class TimeDifferent {
  String? hour, seconds, minutes;

  TimeDifferent({this.seconds, this.hour, this.minutes});
}
